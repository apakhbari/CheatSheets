#!/bin/bash

# ============================================
# Script: compress_individual_dirs.sh
# Purpose: Compress each directory/subdirectory 
#          into separate .tar.gz files with logging
# ============================================

# Configuration
SOURCE_DIR="/export/opensearch-snapshots/indices"
OUTPUT_DIR="${SOURCE_DIR}"  # Change if you want different output location
LOG_FILE="./logs/compress_$(date +%Y%m%d_%H%M%S).log"
ERROR_LOG="./logs/compress_errors_$(date +%Y%m%d_%H%M%S).log"
PID_FILE="/var/run/compress_script.pid"

# Color codes for terminal output (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Also print to console with colors
    case "$level" in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        *)
            echo "[$level] $message"
            ;;
    esac
}

# Function to log errors to separate error file
log_error() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$ERROR_LOG"
}

# Function to check if directory exists
check_directory() {
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_message "ERROR" "Source directory '$SOURCE_DIR' does not exist!"
        exit 1
    fi
    
    if [[ ! -r "$SOURCE_DIR" ]]; then
        log_message "ERROR" "Cannot read source directory '$SOURCE_DIR'!"
        exit 1
    fi
}

# Function to check disk space
check_disk_space() {
    local source_size=$(du -sb "$SOURCE_DIR" | cut -f1)
    local available_space=$(df "$OUTPUT_DIR" | awk 'NR==2 {print $4}')
    
    # Convert to bytes (assuming 1K blocks)
    available_space=$((available_space * 1024))
    
    # Estimate compression (assume 50% compression ratio for safety)
    local estimated_size=$((source_size / 2))
    
    if [[ $available_space -lt $estimated_size ]]; then
        log_message "WARNING" "Low disk space! Available: $(($available_space/1024/1024))MB, Estimated needed: $(($estimated_size/1024/1024))MB"
        log_message "WARNING" "Continuing anyway, but may fail if disk fills up"
    else
        log_message "INFO" "Sufficient disk space available. Available: $(($available_space/1024/1024))MB, Estimated needed: $(($estimated_size/1024/1024))MB"
    fi
}

# Function to compress a single directory
compress_directory() {
    local dir_path="$1"
    local dir_name=$(basename "$dir_path")
    local output_file="${OUTPUT_DIR}/${dir_name}.tar.gz"
    local start_time=$(date +%s)
    
    log_message "INFO" "Starting compression of: $dir_name"
    
    # Check if output file already exists
    if [[ -f "$output_file" ]]; then
        log_message "WARNING" "Output file $output_file already exists. Skipping $dir_name"
        return 1
    fi
    
    # Perform compression
    if tar -czf "$output_file" -C "$dir_path" . 2>> "$ERROR_LOG"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        local size=$(du -h "$output_file" | cut -f1)
        
        log_message "INFO" "✓ Successfully compressed: $dir_name (Size: $size, Time: ${duration}s)"
        return 0
    else
        log_message "ERROR" "✗ Failed to compress: $dir_name"
        log_error "Failed to compress: $dir_name"
        return 1
    fi
}

# Function to display summary
display_summary() {
    local total_dirs=$1
    local success_count=$2
    local fail_count=$3
    local total_time=$4
    
    log_message "INFO" "=========================================="
    log_message "INFO" "COMPRESSION SUMMARY"
    log_message "INFO" "=========================================="
    log_message "INFO" "Total directories processed: $total_dirs"
    log_message "INFO" "Successfully compressed: $success_count"
    log_message "INFO" "Failed: $fail_count"
    log_message "INFO" "Total time: ${total_time}s"
    log_message "INFO" "Log file: $LOG_FILE"
    log_message "INFO" "Error log: $ERROR_LOG"
    log_message "INFO" "=========================================="
}

# Main execution
main() {
    local start_time=$(date +%s)
    local success_count=0
    local fail_count=0
    
    # Write PID
    echo $$ > "$PID_FILE"
    
    # Start logging
    log_message "INFO" "=========================================="
    log_message "INFO" "Starting compression script"
    log_message "INFO" "Source directory: $SOURCE_DIR"
    log_message "INFO" "Output directory: $OUTPUT_DIR"
    log_message "INFO" "=========================================="
    
    # Initial checks
    check_directory
    check_disk_space
    
    # Count total directories
    local total_dirs=$(find "$SOURCE_DIR" -maxdepth 1 -type d ! -path "$SOURCE_DIR" | wc -l)
    log_message "INFO" "Found $total_dirs directories to process"
    
    if [[ $total_dirs -eq 0 ]]; then
        log_message "WARNING" "No directories found to compress!"
        rm -f "$PID_FILE"
        exit 0
    fi
    
    # Process each directory
    local current=0
    for dir in "$SOURCE_DIR"/*/; do
        [[ -d "$dir" ]] || continue
        ((current++))
        
        log_message "INFO" "Processing $current of $total_dirs"
        
        if compress_directory "$dir"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    done
    
    # Calculate total time
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    
    # Display summary
    display_summary "$total_dirs" "$success_count" "$fail_count" "$total_time"
    
    # Clean up PID file
    rm -f "$PID_FILE"
    
    # Exit with error code if any failures
    if [[ $fail_count -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Trap signals for clean exit
trap 'log_message "WARNING" "Script interrupted"; rm -f "$PID_FILE"; exit 1' INT TERM

# Run main function
main