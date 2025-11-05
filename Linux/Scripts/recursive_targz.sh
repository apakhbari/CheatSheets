#!/bin/bash
# Archive old directories under /export/archive_s3/cashless/
# Version: 2025-11-04
# Author: APA

set -euo pipefail

DRYRUN=false   # Set true for testing (no deletion)
CODE_VERSION="1.3"

CUTOFF_DATE="2025-10-15"      # Files created after this time are not being processed
CURRENTSEC=$(date +%s)
TIMESTAMP=$(date +%y%m%d_%H%M)

BASE_DIR="/mnt/s3"
LOG_DIR="./logs/"
BASE_LOGFILE="${LOG_DIR}/SCRIPT_${TIMESTAMP}.log"
LOCKFILE="/var/run/SCRIPT.lock"

DIVIDER="%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

# Ensure unique logfile name if one already exists
mkdir -p "$LOG_DIR"
LOGFILE="$BASE_LOGFILE"
count=2
while [[ -e "$LOGFILE" ]]; do
    LOGFILE="${LOG_DIR}/SCRIPT_${TIMESTAMP}_$count.log"
    ((count++))
done

# Exclusive lock
exec 200>"$LOCKFILE"
flock -n 200 || { echo "$(date '+%F %T') - Another instance is running." | tee -a "$LOGFILE"; exit 1; }

log() {
    echo -e "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

is_older_than_cutoff() {
    local dir="$1"
    local mtime
    mtime=$(stat -c %Y "$dir")
    cutoff_epoch=$(date -d "$CUTOFF_DATE" +%s)
    [[ "$mtime" -lt "$cutoff_epoch" ]]
}

process_directory() {
    local dir="$1"

    # Skip if not a directory
    [[ -d "$dir" ]] || return 0

    # Skip directories newer than cutoff
    if ! is_older_than_cutoff "$dir"; then
        log "SKIP: $dir (newer than cutoff)"
        return 0
    fi

    # Go inside and check subdirectories
    find "$dir" -mindepth 1 -maxdepth 1 -type d | while read -r subdir; do
        local tarfile="${subdir}.tar.gz"

        # (1) Skip if tar.gz already exists
        if [[ -f "$tarfile" ]]; then
            log "SKIP: Archive already exists: $tarfile"
            continue
        fi

        # (2) Skip if directory is empty (no files at all)
        if [[ -z "$(find "$subdir" -type f | head -n 1)" ]]; then
            log "SKIP: $subdir is empty, skipping."
            continue
        fi

        log "Archiving: $subdir → $tarfile"

        if [ "$DRYRUN" = true ]; then
            log "[DRYRUN] Would run: tar -czf '$tarfile' -C '$(dirname "$subdir")' '$(basename "$subdir")'"
            continue
        fi

        tar -czf "$tarfile" -C "$(dirname "$subdir")" "$(basename "$subdir")" 2>>"$LOGFILE"
        if [[ $? -ne 0 ]]; then
            log "ERROR: Failed to create archive for $subdir"
            continue
        fi

        # Basic Verification
        #if tar -tzf "$tarfile" &>/dev/null; then
            # orig_size=$(du -sb "$subdir" | awk '{print $1}')
            # archive_size=$(du -sb "$tarfile" | awk '{print $1}')
            # if (( archive_size > 0 && archive_size < orig_size * 2 )); then
                # log "Verified: $tarfile is valid (size check passed)."
                # rm -rf "$subdir" # log "Deleted original directory: $subdir"
            # else
                # log "WARNING: Size check failed for $tarfile, keeping original $subdir"
            # fi
        #else
            # log "ERROR: Verification failed for $tarfile, keeping $subdir"
        #fi

        # Verify archive integrity
        if tar -tzf "$tarfile" &>/dev/null; then
            # Count files inside archive and original folder
            orig_count=$(find "$subdir" -type f -name '*.jpg' | wc -l)
            tar_count=$(tar -tzf "$tarfile" | grep -E '\.jpg$' | wc -l)

            if [[ "$orig_count" -eq "$tar_count" && "$orig_count" -gt 0 ]]; then
                log "Verified: $tarfile (count=$tar_count) matches $subdir"
                rm -rf "$subdir"
                log "Deleted original directory: $subdir"
            else
                log "ERROR: Mismatch in file count for $subdir (orig=$orig_count, tar=$tar_count). Keeping directory."
            fi
        else
            log "ERROR: Archive integrity check failed for $tarfile, keeping $subdir"
        fi

    done
}

main() {
    log "$DIVIDER"
    log "==== Archive process started ===="
    log "==== $(date '+%F %T') ===="
    log "CODE_VERSION: $CODE_VERSION\n"

    for topdir in "$BASE_DIR"/*; do
        [[ -d "$topdir" ]] || continue
        process_directory "$topdir"
    done

    END_TIME=$(date '+%s')
    DURATION=$((END_TIME - CURRENTSEC))

    log "\nProcess took $DURATION seconds."
    log "==== Archive process finished ===="
    log "$DIVIDER"
}

main