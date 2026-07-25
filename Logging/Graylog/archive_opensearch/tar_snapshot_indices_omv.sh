#!/usr/bin/env bash
#
# tar_snapshot_indices_omv.sh
# Runs ON THE OPENMEDIAVAULT BOX, directly against the local disk backing
# the NFS export (NOT over the NFS mount itself - much faster and avoids
# any NFS-locking edge cases while tarring/deleting).
#
# Reads manifest files written by archive_topup_k8s.sh (index name -> uuid)
# and tar.gz's each index's actual data directory under indices/<uuid>/,
# then removes the original directory to reclaim space, since each index's
# data has its own dedicated uuid folder here (no cross-index sharing to
# worry about for these one-time, non-incremental snapshots).
#
# IMPORTANT: after this runs, restoring an archived index via OpenSearch's
# _restore API will NOT work directly - the raw data folder is gone, replaced
# by a .tar.gz. To restore something archived this way, you must first
# extract the relevant tar.gz back into indices/<uuid>/ before calling
# _restore. This script trades "instantly restorable" for "smaller footprint".

set -euo pipefail

### --- Config -----------------------------------------------------------
REPO_ROOT="/srv/dev-disk-by-uuid-XXXX/opensearch-snapshots"   # <-- SET THIS to the real local path (not the NFS client mount)
MANIFEST_DIR="${REPO_ROOT}/_manifests"
DONE_DIR="${MANIFEST_DIR}/done"
INDICES_DIR="${REPO_ROOT}/indices"
ARCHIVE_DIR="${REPO_ROOT}/compressed_indices"
LOG_FILE="/var/log/topup-tar-archive-$(date +%F).log"   # one log file per calendar day, e.g. topup-tar-archive-2026-07-25.log
MIN_AGE_MINUTES=30   # skip anything modified in the last 30 min, in case a snapshot is still finishing writes
### -----------------------------------------------------------------------

TIMESTAMP=$(date +%y%m%d_%H%M)

log() { echo "$(date '+%F %T') $* [${TIMESTAMP}]" | tee -a "$LOG_FILE"; }
fail() { log "ERROR: $*"; exit 1; }

mkdir -p "$DONE_DIR" "$ARCHIVE_DIR"

log "=== tar-compress run started ==="

shopt -s nullglob
MANIFESTS=("${MANIFEST_DIR}"/*.manifest)

if [ ${#MANIFESTS[@]} -eq 0 ]; then
  log "No new manifests found. Nothing to do."
  exit 0
fi

for manifest in "${MANIFESTS[@]}"; do
  manifest_name=$(basename "$manifest")
  log "Processing manifest: ${manifest_name}"

  # skip if too fresh (snapshot might still be finalizing on disk)
  if [ -n "$(find "$manifest" -mmin -${MIN_AGE_MINUTES})" ]; then
    log "  ${manifest_name} is younger than ${MIN_AGE_MINUTES}m, skipping this run"
    continue
  fi

  all_ok=true

  while read -r index_name uuid snap_name; do
    [ -z "$index_name" ] && continue

    src_dir="${INDICES_DIR}/${uuid}"
    tar_path="${ARCHIVE_DIR}/${index_name}_${uuid}.tar.gz"

    if [ ! -d "$src_dir" ]; then
      log "  WARNING: ${index_name} (uuid ${uuid}) - source directory not found, may already be archived. Skipping."
      continue
    fi

    if [ -f "$tar_path" ]; then
      log "  ${index_name} (uuid ${uuid}) - tar.gz already exists, skipping"
      continue
    fi

    log "  Compressing ${index_name} (uuid ${uuid}) -> $(basename "$tar_path")"
    if tar -czf "$tar_path" -C "$INDICES_DIR" "$uuid"; then
      # verify the tarball is readable before touching the original
      if tar -tzf "$tar_path" > /dev/null 2>&1; then
        original_size=$(du -sh "$src_dir" | cut -f1)
        tar_size=$(du -sh "$tar_path" | cut -f1)
        log "  OK: ${index_name} original=${original_size} compressed=${tar_size}"
        rm -rf "$src_dir"
        log "  Removed original directory for ${index_name} (uuid ${uuid})"
      else
        log "  ERROR: tar.gz for ${index_name} failed integrity check (tar -tzf). NOT deleting original."
        rm -f "$tar_path"
        all_ok=false
      fi
    else
      log "  ERROR: tar command failed for ${index_name} (uuid ${uuid}). NOT deleting original."
      all_ok=false
    fi
  done < "$manifest"

  if $all_ok; then
    mv "$manifest" "${DONE_DIR}/${manifest_name}"
    log "  Manifest ${manifest_name} fully processed, moved to done/"
  else
    log "  Manifest ${manifest_name} had failures, left in place for retry next run"
  fi
done

log "=== tar-compress run complete ==="

# --- Scheduling -------------------------------------------------------------
# Run daily via cron, offset a few hours after the k8s script's daily run so
# manifests have time to land and settle:
#
#   crontab -e
#   0 6 * * * /usr/local/bin/tar_snapshot_indices_omv.sh
#
# Or, if you prefer OMV's own scheduler: System -> Scheduled Jobs -> Add,
# same command and cron expression, in the OMV web UI.
# -----------------------------------------------------------------------