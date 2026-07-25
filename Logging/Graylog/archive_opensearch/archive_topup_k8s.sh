#!/usr/bin/env bash
#
# archive_topup_k8s.sh
# Runs ON A KUBERNETES NODE (e.g. graylog02).
#
# Snapshots TOPUP indices older than RETAIN_DAYS to the 'topup_archive' NFS
# repo, verifies the snapshot, deletes the live indices via Graylog's API,
# and writes a manifest file (index name -> uuid) onto the shared NFS mount
# so the companion script on the OpenMediaVault box (tar_snapshot_indices_omv.sh)
# knows exactly which on-disk folders it's safe to compress.

set -euo pipefail

### --- Config -----------------------------------------------------------
OS_HOST="http://localhost:9200"
OS_AUTH=""                                  # e.g. "-u admin:changeme" if security plugin enabled
OS_CURL_OPTS="-s ${OS_AUTH}"

REPO_NAME="topup_archive"
INDEX_PATTERN="topup_*"
RETAIN_DAYS=30
LOG_FILE="/var/log/graylog-topup-archive-$(date +%F).log"   # one log file per calendar day, e.g. graylog-topup-archive-2026-07-25.log

GRAYLOG_URL="https://<graylog-host>/api"
GRAYLOG_AUTH="-u <api-token>:token"
GRAYLOG_INDEX_SET_ID="<index-set-id>"

KCTL="kubectl exec -n graylog opensearch-cluster-master-0 --"

# Where the NFS repo is mounted INSIDE THE OPENSEARCH POD (must match path.repo)
REPO_MOUNT_IN_POD="/usr/share/opensearch/snapshots"
MANIFEST_SUBDIR="_manifests"                # lives under the repo root, visible to OMV too
### -----------------------------------------------------------------------

TIMESTAMP=$(date +%y%m%d_%H%M)

log() { echo "$(date '+%F %T') $* [${TIMESTAMP}]" | tee -a "$LOG_FILE"; }
fail() { log "ERROR: $*"; exit 1; }

log "=== TOPUP archive run started (30-day retention) ==="

# 1. Find the currently active (write) index so we never touch it
ACTIVE_INDEX=$(curl -s ${GRAYLOG_AUTH} "${GRAYLOG_URL}/system/indices/index_sets/${GRAYLOG_INDEX_SET_ID}" \
  -H 'Accept: application/json' | jq -r '.writable // empty' 2>/dev/null || true)

if [ -z "$ACTIVE_INDEX" ]; then
  log "WARNING: could not determine active index from Graylog API, falling back to highest topup_N number"
  ACTIVE_INDEX=$($KCTL curl ${OS_CURL_OPTS} "${OS_HOST}/_cat/indices/${INDEX_PATTERN}?h=index" \
    | sed 's/topup_//' | sort -n | tail -1 | sed 's/^/topup_/')
fi
log "Active write index (will be skipped): ${ACTIVE_INDEX}"

# 2. Get creation_date for every topup_* index, pick ones older than RETAIN_DAYS
CUTOFF_MS=$(( $(date +%s) * 1000 - RETAIN_DAYS * 86400 * 1000 ))

CANDIDATES=$($KCTL curl ${OS_CURL_OPTS} "${OS_HOST}/${INDEX_PATTERN}/_settings/index.creation_date" \
  | jq -r --arg cutoff "$CUTOFF_MS" --arg active "$ACTIVE_INDEX" '
      to_entries[]
      | select(.key != $active)
      | select((.value.settings.index.creation_date | tonumber) < ($cutoff | tonumber))
      | .key' | sort)

if [ -z "$CANDIDATES" ]; then
  log "No indices older than ${RETAIN_DAYS} days found. Nothing to do."
  exit 0
fi

log "Indices to archive: $(echo $CANDIDATES | tr '\n' ' ')"

# 3. Capture index UUIDs BEFORE deletion - this is what maps index names to
#    the actual on-disk folder names inside the repo (indices/<uuid>/), which
#    the OMV-side script needs to know what to compress.
declare -A INDEX_UUIDS
for idx in $CANDIDATES; do
  uuid=$($KCTL curl ${OS_CURL_OPTS} "${OS_HOST}/${idx}/_settings" | jq -r ".[\"${idx}\"].settings.index.uuid")
  INDEX_UUIDS[$idx]=$uuid
  log "  ${idx} -> uuid ${uuid}"
done

# 4. Build indices list and take the snapshot, named with the real date range
INDICES_CSV=$(echo "$CANDIDATES" | paste -sd, -)

DATE_RANGE=$($KCTL curl ${OS_CURL_OPTS} "${OS_HOST}/${INDICES_CSV}/_settings/index.creation_date" \
  | jq -r '[.[].settings.index.creation_date | tonumber] | "\(min)-\(max)"')
MIN_MS=$(echo "$DATE_RANGE" | cut -d- -f1)
MAX_MS=$(echo "$DATE_RANGE" | cut -d- -f2)
MIN_DATE=$(date -d "@$((MIN_MS/1000))" +%Y%m%d)
MAX_DATE=$(date -d "@$((MAX_MS/1000))" +%Y%m%d)

SNAP_NAME="topup-${MIN_DATE}_to_${MAX_DATE}-run${TIMESTAMP}"

log "Starting snapshot ${SNAP_NAME} for: ${INDICES_CSV}"
SNAP_RESULT=$($KCTL curl ${OS_CURL_OPTS} -X PUT \
  "${OS_HOST}/_snapshot/${REPO_NAME}/${SNAP_NAME}?wait_for_completion=true" \
  -H 'Content-Type: application/json' \
  -d "{\"indices\": \"${INDICES_CSV}\", \"ignore_unavailable\": false, \"include_global_state\": false}")

STATE=$(echo "$SNAP_RESULT" | jq -r '.snapshot.state // "UNKNOWN"')
FAILED_SHARDS=$(echo "$SNAP_RESULT" | jq -r '.snapshot.shards.failed // -1')
log "Snapshot state: ${STATE}, failed shards: ${FAILED_SHARDS}"

if [ "$STATE" != "SUCCESS" ] || [ "$FAILED_SHARDS" != "0" ]; then
  fail "Snapshot ${SNAP_NAME} did not complete cleanly. Aborting before delete. Response: $SNAP_RESULT"
fi

# 5. Doc-count sanity check
for idx in $CANDIDATES; do
  live_count=$($KCTL curl ${OS_CURL_OPTS} "${OS_HOST}/${idx}/_count" | jq '.count')
  log "  ${idx}: ${live_count} docs confirmed archived in ${SNAP_NAME}"
done

# 6. Write the manifest for the OMV-side compression script.
#    Format: one line per index -> "index_name uuid snapshot_name"
MANIFEST_FILE="/tmp/${SNAP_NAME}.manifest"
> "$MANIFEST_FILE"
for idx in $CANDIDATES; do
  echo "${idx} ${INDEX_UUIDS[$idx]} ${SNAP_NAME}" >> "$MANIFEST_FILE"
done

log "Copying manifest into repo (visible to OMV over the same NFS export)"
$KCTL sh -c "mkdir -p ${REPO_MOUNT_IN_POD}/${MANIFEST_SUBDIR}"
kubectl cp -n graylog "$MANIFEST_FILE" \
  "opensearch-cluster-master-0:${REPO_MOUNT_IN_POD}/${MANIFEST_SUBDIR}/${SNAP_NAME}.manifest" \
  || fail "Could not write manifest file for ${SNAP_NAME} - OMV-side compression will not know about this run"
log "Manifest written: ${MANIFEST_SUBDIR}/${SNAP_NAME}.manifest"

# 7. Delete each archived index via Graylog (keeps index_ranges metadata clean)
for idx in $CANDIDATES; do
  log "Closing+deleting ${idx} via Graylog API"
  curl -s ${GRAYLOG_AUTH} -X POST "${GRAYLOG_URL}/system/indices/${idx}/close" \
    -H 'X-Requested-By: cron' -H 'Accept: application/json' >> "$LOG_FILE" 2>&1
  curl -s ${GRAYLOG_AUTH} -X DELETE "${GRAYLOG_URL}/system/indices/${idx}" \
    -H 'X-Requested-By: cron' -H 'Accept: application/json' >> "$LOG_FILE" 2>&1
  log "  ${idx} deleted from live cluster"
done

log "=== TOPUP archive run complete: snapshot=${SNAP_NAME} indices=$(echo $CANDIDATES | tr '\n' ' ') ==="

# --- Scheduling -------------------------------------------------------------
# Run DAILY (not every-30-days) so aging indices get archived promptly as soon
# as they cross the 30-day mark, rather than in one big batch periodically:
#
#   /etc/systemd/system/topup-archive.service
#     [Unit]
#     Description=Archive TOPUP indices older than 30 days
#     [Service]
#     Type=oneshot
#     ExecStart=/usr/local/bin/archive_topup_k8s.sh
#
#   /etc/systemd/system/topup-archive.timer
#     [Unit]
#     Description=Run topup-archive daily
#     [Timer]
#     OnCalendar=daily
#     RandomizedDelaySec=30m
#     Persistent=true
#     [Install]
#     WantedBy=timers.target
#
#   systemctl daemon-reload
#   systemctl enable --now topup-archive.timer
# -----------------------------------------------------------------------