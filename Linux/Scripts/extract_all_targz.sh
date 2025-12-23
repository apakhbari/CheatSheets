#!/bin/bash

# Script to extract all .tar.gz files in a directory

set -e  # Exit on error

# Check if directory argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory> [extract_directory]"
    echo "If extract_directory is not provided, files will be extracted in place."
    exit 1
fi

BASE_DIR="$1"
EXTRACT_DIR="${2:-$BASE_DIR}"

# Check if directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Directory '$BASE_DIR' does not exist."
    exit 1
fi

# Create extraction directory if it doesn't exist
mkdir -p "$EXTRACT_DIR"

# Count tar.gz files
count=$(find "$BASE_DIR" -maxdepth 1 -name "*.tar.gz" | wc -l)

if [ $count -eq 0 ]; then
    echo "No .tar.gz files found in '$BASE_DIR'."
    exit 0
fi

echo "Found $count .tar.gz file(s) in '$BASE_DIR'."
echo "Extracting to: $EXTRACT_DIR"

# Extract all tar.gz files
success=0
fail=0

for file in "$BASE_DIR"/*.tar.gz; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Extracting: $filename"
        
        # Try to extract
        if tar -xzf "$file" -C "$EXTRACT_DIR"; then
            echo "✓ Successfully extracted: $filename"
            ((success++))
        else
            echo "✗ Failed to extract: $filename"
            ((fail++))
        fi
    fi
done

echo ""
echo "="*50
echo "Extraction Summary:"
echo "Total files: $count"
echo "Successfully extracted: $success"
echo "Failed: $fail"
echo "="*50