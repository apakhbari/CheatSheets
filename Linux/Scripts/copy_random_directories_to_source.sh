#!/bin/bash

SOURCE_DIR="/mnt/s3/"
DEST_DIR="/home/apa"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Copy 20 random directories
find "$SOURCE_DIR" -maxdepth 1 -type d | shuf -n 20 | while read dir; do
    if [[ "$dir" != "$SOURCE_DIR" ]]; then
        echo "Copying: $dir"
        cp -r "$dir" "$DEST_DIR/"
    fi
done

echo "Done! Copied 20 random directories to $DEST_DIR"