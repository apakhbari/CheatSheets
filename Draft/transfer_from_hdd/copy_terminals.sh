#!/bin/bash
# Copy terminal directories from external HDD to destination
# Version: 2025-01-08
# Author: APA

set -euo pipefail

# Configuration
DRYRUN=true   # Set false to actually copy files
CODE_VERSION="1.0"
CURRENTSEC=$(date +%s)
TIMESTAMP=$(date +%y%m%d_%H%M)

SOURCE_DIR="/mnt/external-hdd/before-cutoff"
DEST_DIR="/sdd/cashless"

LOG_DIR="./logs/"
BASE_LOGFILE="${LOG_DIR}/copy_terminals_${TIMESTAMP}.log"
LOCKFILE="/var/run/copy_terminals.lock"

DIVIDER="%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

# Create log directory
mkdir -p "$LOG_DIR"

# Handle duplicate log filenames
LOGFILE="$BASE_LOGFILE"
count=2
while [[ -e "$LOGFILE" ]]; do
    LOGFILE="${LOG_DIR}/copy_terminals_${TIMESTAMP}_$count.log"
    ((count++))
done

# Lock file to prevent multiple instances
exec 200>"$LOCKFILE"
flock -n 200 || { echo "$(date '+%F %T') - Another instance is running." | tee -a "$LOGFILE"; exit 1; }

# Logging function
log() {
    echo -e "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

# Count total terminals
count_terminals() {
    local total=0
    log "Scanning source directory to count terminals..."
    
    for terminal in "$SOURCE_DIR"/*; do
        [[ -d "$terminal" ]] || continue
        ((total++))
    done
    
    echo "$total"
}

# Copy a single terminal directory
copy_terminal() {
    local terminal_path="$1"
    local terminal_name=$(basename "$terminal_path")
    local dest_path="$DEST_DIR/$terminal_name"
    
    if [[ "$DRYRUN" == "true" ]]; then
        log "[DRYRUN] Would copy: $terminal_name"
        # Simulate some work time
        sleep 0.01
    else
        # Create destination if it doesn't exist
        mkdir -p "$DEST_DIR"
        
        # Use rsync for efficient copying with progress
        if rsync -a "$terminal_path/" "$dest_path/" >> "$LOGFILE" 2>&1; then
            log "✓ Copied: $terminal_name"
        else
            log "✗ ERROR copying: $terminal_name"
            return 1
        fi
    fi
    
    return 0
}

# Main processing function
process_terminals() {
    local total_terminals="$1"
    local processed=0
    local successful=0
    local failed=0
    
    log "\n$DIVIDER"
    log "Starting to process $total_terminals terminals...\n"
    
    for terminal in "$SOURCE_DIR"/*; do
        [[ -d "$terminal" ]] || continue
        
        ((processed++))
        
        # Show progress every terminal (or adjust frequency as needed)
        echo -ne "\r$(date '+%F %T') - STATUS: Processed $processed/$total_terminals terminals" | tee -a "$LOGFILE"
        
        if copy_terminal "$terminal"; then
            ((successful++))
        else
            ((failed++))
        fi
        
        # More detailed progress every 100 terminals
        if ((processed % 100 == 0)); then
            log "\n--- Progress checkpoint: $processed/$total_terminals terminals processed ---"
        fi
    done
    
    echo "" | tee -a "$LOGFILE"  # New line after progress
    
    log "\n$DIVIDER"
    log "Processing complete!"
    log "Total terminals: $total_terminals"
    log "Successfully processed: $successful"
    log "Failed: $failed"
}

# Main execution
main() {
    log "$DIVIDER"
    log "==== Terminal copy process started ===="
    log "==== $(date '+%F %T') ===="
    log "CODE_VERSION: $CODE_VERSION"
    log "SOURCE: $SOURCE_DIR"
    log "DESTINATION: $DEST_DIR"
    log "DRYRUN MODE: $DRYRUN"
    log "$DIVIDER\n"
    
    # Verify source directory exists
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log "ERROR: Source directory does not exist: $SOURCE_DIR"
        exit 1
    fi
    
    # Count terminals first
    TOTAL_TERMINALS=$(count_terminals)
    log "Found $TOTAL_TERMINALS terminal directories\n"
    
    if [[ "$TOTAL_TERMINALS" -eq 0 ]]; then
        log "No terminals found to process. Exiting."
        exit 0
    fi
    
    # Process all terminals
    process_terminals "$TOTAL_TERMINALS"
    
    # Calculate duration
    END_TIME=$(date '+%s')
    DURATION=$((END_TIME - CURRENTSEC))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    log "\nProcess took ${MINUTES}m ${SECONDS}s (${DURATION} seconds total)."
    log "==== Terminal copy process finished ===="
    log "$DIVIDER"
}

# Trap to ensure cleanup on exit
trap 'rm -f "$LOCKFILE"' EXIT

# Run main function
main