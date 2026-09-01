#!/bin/bash

# Space Housekeeping Script for Ubuntu Server
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="/var/log/cleanup-$(date +%Y%m%d-%H%M%S).log"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[+]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[!]${NC} $1" | tee -a "$LOG_FILE"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1" | tee -a "$LOG_FILE"
}

# Function to check disk usage before and after
check_disk_usage() {
    echo -e "\n${BLUE}=== Disk Usage ${1} ===${NC}" | tee -a "$LOG_FILE"
    df -h / | tail -1 | awk '{print "Used: " $3 " / " $2 " (" $5 " used)"}' | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

# Function to calculate freed space
calculate_freed() {
    local before=$1
    local after=$2
    local freed=$((before - after))
    if [ $freed -gt 0 ]; then
        print_status "Freed: $(numfmt --to=iec $freed) bytes"
    fi
}

# Start script
echo "=========================================" | tee -a "$LOG_FILE"
echo "Server Cleanup Script - $(date)" | tee -a "$LOG_FILE"
echo "=========================================" | tee -a "$LOG_FILE"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root (use sudo)"
    exit 1
fi

# Record initial disk usage
print_info "Recording initial disk usage..."
INITIAL_USAGE=$(df / --output=used | tail -1)
check_disk_usage "BEFORE CLEANUP"

# 1. APT Cleanup
print_status "Cleaning APT packages..."
print_info "Before APT cleanup:"
du -sh /var/cache/apt/archives 2>/dev/null | tee -a "$LOG_FILE"

# Remove downloaded packages
apt-get clean -y 2>&1 | tee -a "$LOG_FILE"
# Remove obsolete packages
apt-get autoclean -y 2>&1 | tee -a "$LOG_FILE"
# Remove unnecessary packages
apt-get autoremove -y 2>&1 | tee -a "$LOG_FILE"
# Remove old kernels (keep current and 1 previous)
apt-get autoremove --purge -y 2>&1 | tee -a "$LOG_FILE"

print_info "After APT cleanup:"
du -sh /var/cache/apt/archives 2>/dev/null | tee -a "$LOG_FILE"

# 2. Snap Cleanup
if command -v snap &> /dev/null; then
    print_status "Cleaning Snap packages..."
    
    # Get snap disk usage before
    SNAP_BEFORE=$(du -sb /var/lib/snapd/snaps 2>/dev/null | cut -f1)
    
    # Remove old snap revisions
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
        print_info "Removing old revision $revision of $snapname"
        snap remove "$snapname" --revision="$revision" 2>&1 | tee -a "$LOG_FILE"
    done
    
    # Clean snap cache
    rm -rf /var/lib/snapd/cache/* 2>/dev/null
    
    # Clean old snap versions (keep last 2)
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
        snap remove "$snapname" --revision="$revision" 2>&1 | tee -a "$LOG_FILE"
    done
    
    print_info "Snap cleanup completed"
else
    print_info "Snap not installed, skipping..."
fi

# 3. Journald Logs Cleanup
print_status "Cleaning journald logs..."
if command -v journalctl &> /dev/null; then
    # Check current journal size
    print_info "Current journal size:"
    journalctl --disk-usage | tee -a "$LOG_FILE"
    
    # Keep logs from last 30 days only
    print_info "Keeping logs from last 30 days..."
    journalctl --vacuum-time=30d 2>&1 | tee -a "$LOG_FILE"
    
    # Or limit to 500MB (uncomment if preferred)
    # journalctl --vacuum-size=500M
    
    print_info "After cleanup:"
    journalctl --disk-usage | tee -a "$LOG_FILE"
else
    print_info "journalctl not found, skipping..."
fi

# 4. Clean Temporary Files
print_status "Cleaning temporary files..."
# Clean /tmp (files older than 10 days)
find /tmp -type f -atime +10 -delete 2>/dev/null
find /tmp -type d -empty -delete 2>/dev/null

# Clean /var/tmp
find /var/tmp -type f -atime +30 -delete 2>/dev/null
find /var/tmp -type d -empty -delete 2>/dev/null

# Clean old systemd journal (already done above)
print_info "Temporary files cleaned"

# 5. Clean Log Files
print_status "Cleaning old log files..."
# Rotate and compress logs
logrotate -f /etc/logrotate.conf 2>&1 | tee -a "$LOG_FILE"

# Remove old rotated logs (older than 30 days)
#find /var/log -name "*.gz" -mtime +30 -delete 2>/dev/null
#find /var/log -name "*.1" -mtime +30 -delete 2>/dev/null
#find /var/log -name "*.old" -mtime +30 -delete 2>/dev/null

# Clean specific log directories
for log_dir in /var/log /var/log/nginx /var/log/apache2 /var/log/mysql; do
    if [ -d "$log_dir" ]; then
        print_info "Cleaning $log_dir"
        find "$log_dir" -name "*.log.*" -mtime +30 -delete 2>/dev/null
        find "$log_dir" -name "*.log" -mtime +30 -exec truncate -s 0 {} \; 2>/dev/null
    fi
done

# 6. Clean Old Backups
print_status "Cleaning old backup files..."
# Find and remove old backup files (older than 60 days)
find / -type f \( -name "*.bak" -o -name "*.backup" -o -name "*.old" \) -mtime +60 -delete 2>/dev/null

# Clean /var/backups (keep only last 7 days)
find /var/backups -type f -mtime +7 -delete 2>/dev/null

# 7. Clean Trash/Cache for Users
print_status "Cleaning user caches and trash..."
for user_home in /home/*; do
    if [ -d "$user_home" ]; then
        username=$(basename "$user_home")
        print_info "Cleaning for user: $username"
        
        # Clean browser caches
        rm -rf "$user_home/.cache"/* 2>/dev/null
        
        # Clean trash
        rm -rf "$user_home/.local/share/Trash"/* 2>/dev/null
        
        # Clean thumbnails
        rm -rf "$user_home/.thumbnails"/* 2>/dev/null
    fi
done

# Clean root's cache
rm -rf /root/.cache/* 2>/dev/null

# 8. Docker Cleanup (if installed)
if command -v docker &> /dev/null; then
    print_status "Cleaning Docker resources..."
    print_info "Before Docker cleanup:"
    docker system df | tee -a "$LOG_FILE"
    
    # Remove unused containers, networks, and images
    docker system prune -a -f --volumes 2>&1 | tee -a "$LOG_FILE"
    
    print_info "After Docker cleanup:"
    docker system df | tee -a "$LOG_FILE"
fi

# 9. Remove Old Kernels
print_status "Removing old kernels..."
# Keep only current and 1 previous kernel
dpkg -l 'linux-*' | awk '/^ii/{print $2}' | grep -v "$(uname -r)" | grep -E 'linux-image-[0-9]' | head -n -1 | xargs apt-get remove --purge -y 2>&1 | tee -a "$LOG_FILE"

# 10. Clean Package Manager Lock files
print_status "Cleaning stale lock files..."
find /var/lib/apt/lists -type f -name "*.lock" -delete 2>/dev/null
find /var/cache/apt -type f -name "*.lock" -delete 2>/dev/null

# 11. Clean MySQL Binary Logs (if MySQL/MariaDB installed)
if command -v mysql &> /dev/null; then
    print_status "Cleaning MySQL logs..."
    # Remove binary logs older than 7 days
    mysql -e "PURGE BINARY LOGS BEFORE NOW() - INTERVAL 7 DAY;" 2>/dev/null || print_warning "MySQL purge failed (check permissions)"
fi

# 12. Clean Failed Systemd Services Logs
print_status "Cleaning failed service logs..."
journalctl --vacuum-size=100M 2>&1 | tee -a "$LOG_FILE"

# Record final disk usage
print_info "Recording final disk usage..."
FINAL_USAGE=$(df / --output=used | tail -1)
check_disk_usage "AFTER CLEANUP"

# Calculate and display freed space
INITIAL_USAGE_NUM=${INITIAL_USAGE//[!0-9]/}
FINAL_USAGE_NUM=${FINAL_USAGE//[!0-9]/}
FREED_SPACE=$((INITIAL_USAGE_NUM - FINAL_USAGE_NUM))

if [ $FREED_SPACE -gt 0 ]; then
    print_status "Total space freed: $(numfmt --to=iec $FREED_SPACE) bytes"
else
    print_warning "No significant space freed"
fi

# Show top 10 largest directories after cleanup
print_info "Top 10 largest directories in /:"
du -sh /* 2>/dev/null | sort -hr | head -10 | tee -a "$LOG_FILE"

# Show large files (>100MB)
print_info "Large files (>100MB) that might need attention:"
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{print $5 "\t" $9}' | head -20 | tee -a "$LOG_FILE"

print_status "Cleanup completed! Log saved to: $LOG_FILE"

# Optional: Create a daily cron job
print_info "To run this script automatically daily, add to crontab:"
print_info "  0 2 * * * /path/to/cleanup-server.sh"

echo "=========================================" | tee -a "$LOG_FILE"
echo "Cleanup finished at $(date)" | tee -a "$LOG_FILE"
echo "=========================================" | tee -a "$LOG_FILE"