#!/bin/bash
# Quick server resource check

echo "=== CPU Info ==="
echo "CPU Cores: $(nproc)"
echo "CPU Model: $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)"
echo ""

echo "=== Memory Info ==="
free -h
echo ""

echo "=== Disk I/O - Source (S3) ==="
echo "Mount point for /opt/s3/minio_data:"
df -h /opt/s3/minio_data | tail -1
echo ""

echo "=== Disk I/O - Destination (OMV) ==="
echo "Mount point for /mnt/Archive_cashless:"
df -h /mnt/Archive_cashless 2>/dev/null || echo "Not mounted or doesn't exist"
echo ""

echo "=== Load Average ==="
uptime
echo ""

echo "=== Disk I/O Test (5 second sample) ==="
if command -v iostat &> /dev/null; then
    iostat -x 1 5 | tail -20
else
    echo "iostat not available (install sysstat package)"
fi