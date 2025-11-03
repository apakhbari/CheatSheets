#!/bin/bash
# Archive old directories
# Version: 2025-11-02
# Author: APA

set -euo pipefail

BASE_DIR="/home/apa"
LOG_DIR="/var/log"
TIMESTAMP=$(date +%y%m%d_%H%M)
BASE_LOGFILE="${LOG_DIR}/SCRIPT_${TIMESTAMP}.log"
LOCKFILE="/var/run/SCRIPT.lock"
CUTOFF_DATE="2025-10-16"
DRYRUN=true   # Set true for testing (no deletion)

# Ensure unique logfile name if one already exists
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
    echo "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
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

        if [[ -f "$tarfile" ]]; then
            log "SKIP: Already archived: $tarfile"
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

        # Verify archive integrity
        if tar -tzf "$tarfile" &>/dev/null; then
            log "Verified: $tarfile successfully created."
            rm -rf "$subdir"
            log "Deleted original directory: $subdir"
        else
            log "ERROR: Verification failed for $tarfile, keeping $subdir"
        fi
    done
}

main() {
    log "==== Archive process started ===="

    for topdir in "$BASE_DIR"/*; do
        [[ -d "$topdir" ]] || continue
        process_directory "$topdir"
    done

    log "==== Archive process finished ===="
}

main
