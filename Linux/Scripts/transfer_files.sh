#!/bin/bash
# Archive old .tar.gz files based on Jalali Date in Filename
# Source: /export/archive_s3/cashless/
# Destination: /mnt/external-hdd/
# Version: 2025-11-04
# Author: APA (Modified by Assistant)

set -euo pipefail

# ================= CONFIGURATION =================
DRYRUN=true                     # SET TO false TO ENABLE ACTUAL MOVE/DELETE
CODE_VERSION="2.0"

# JALALI CUTOFF: Files with names LESS THAN this will be moved.
# Format: YYMMDD (e.g., 040317)
CUTOFF_JALALI="040317"

SOURCE_BASE="/export/archive_s3/cashless"
DEST_BASE="/mnt/external-hdd//before_cutoff"

LOG_DIR="./logs/"
LOCKFILE="/var/run/archive_cashless.lock"

# ================= SETUP =================
CURRENTSEC=$(date +%s)
TIMESTAMP=$(date +%y%m%d_%H%M)
BASE_LOGFILE="${LOG_DIR}/transfer_cashless_${TIMESTAMP}.log"
DIVIDER="%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

mkdir -p "$LOG_DIR"
LOGFILE="$BASE_LOGFILE"
count=2
while [[ -e "$LOGFILE" ]]; do
    LOGFILE="${LOG_DIR}/transfer_cashless_${TIMESTAMP}_$count.log"
    ((count++))
done

# Check if destination mount exists to prevent filling root partition
if [[ ! -d "$DEST_BASE" ]]; then
    echo "CRITICAL ERROR: Destination $DEST_BASE does not exist or is not mounted."
    exit 1
fi

# Locking mechanism
exec 200>"$LOCKFILE"
flock -n 200 || { echo "$(date '+%F %T') - Another instance is running." | tee -a "$LOGFILE"; exit 1; }

# ================= FUNCTIONS =================

log() {
    echo -e "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

# Verifies file integrity using MD5
# Returns 0 if identical, 1 if different
verify_copy() {
    local src="$1"
    local dst="$2"
    
    local src_md5
    local dst_md5

    src_md5=$(md5sum "$src" | awk '{print $1}')
    dst_md5=$(md5sum "$dst" | awk '{print $1}')

    if [[ "$src_md5" == "$dst_md5" ]]; then
        return 0
    else
        return 1
    fi
}

process_terminal() {
    local terminal_dir="$1"
    local terminal_id
    terminal_id=$(basename "$terminal_dir")

    # Iterate over .tar.gz files inside the terminal directory
    # Nullglob handles cases where directory might be empty of tar.gz files
    shopt -s nullglob
    for filepath in "$terminal_dir"/*.tar.gz; do
        filename=$(basename "$filepath")
        
        # Extract Date part (assumes format 030529.tar.gz)
        # We strip the extension to get the numbers
        file_date_str="${filename%%.tar.gz}"

        # Validate that the filename is exactly 6 digits (YYMMDD)
        if [[ ! "$file_date_str" =~ ^[0-9]{6}$ ]]; then
            log "WARNING: Skipping invalid filename format: $filepath"
            continue
        fi

        # LOGIC: Check if file date is LESS THAN cutoff
        if [[ "$file_date_str" < "$CUTOFF_JALALI" ]]; then
            
            dest_dir="${DEST_BASE}/${terminal_id}"
            dest_file="${dest_dir}/${filename}"

            if [[ "$DRYRUN" == "true" ]]; then
                log "[DRYRUN] Would move $filepath -> $dest_file (Date: $file_date_str < $CUTOFF_JALALI)"
            else
                # 1. Create Destination Directory
                if ! mkdir -p "$dest_dir"; then
                    log "ERROR: Failed to create directory $dest_dir"
                    continue
                fi

                # 2. Check if file already exists at destination
                if [[ -f "$dest_file" ]]; then
                    log "WARNING: File already exists at destination. Skipping to avoid overwrite: $dest_file"
                    continue
                fi

                # 3. Copy File
                log "Copying $filepath..."
                if cp "$filepath" "$dest_file"; then
                    
                    # 4. Verify Integrity (MD5)
                    # Since data is SENSITIVE, we verify contents, not just size.
                    if verify_copy "$filepath" "$dest_file"; then
                        
                        # 5. Delete Source
                        rm "$filepath"
                        log "SUCCESS: Moved and Verified $filename"
                    else
                        log "CRITICAL ERROR: Checksum mismatch for $filename. Source NOT deleted."
                        # Attempt to remove the corrupted destination file
                        rm -f "$dest_file"
                    fi
                else
                    log "ERROR: Copy failed for $filepath"
                fi
            fi
        # Optional: Log that we are skipping newer files (can be noisy, maybe comment out)
        # else
        #    log "Skipping newer file: $filename ($file_date_str >= $CUTOFF_JALALI)"
        fi
    done
    shopt -u nullglob
}

main() {
    log "$DIVIDER"
    log "==== Transfer process started ===="
    log "==== $(date '+%F %T') ===="
    log "CODE_VERSION: $CODE_VERSION"
    log "MODE: $( [[ "$DRYRUN" == "true" ]] && echo "DRY RUN (No changes)" || echo "LIVE EXECUTION" )"
    log "CUTOFF DATE (Jalali): $CUTOFF_JALALI"
    log "SOURCE: $SOURCE_BASE"
    log "DESTINATION: $DEST_BASE\n"

    # Loop through the 13000 terminal directories
    for terminal_path in "$SOURCE_BASE"/*; do
        if [[ -d "$terminal_path" ]]; then
            process_terminal "$terminal_path"
        fi
    done

    END_TIME=$(date '+%s')
    DURATION=$((END_TIME - CURRENTSEC))

    log "\nProcess took $DURATION seconds."
    log "==== Transfer process finished ===="
    log "$DIVIDER"
}

main