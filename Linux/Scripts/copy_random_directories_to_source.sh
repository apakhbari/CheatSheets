#!/bin/bash

SOURCE_DIR="/mnt/s3/"
DEST_DIR="/home/apa"
NUM_DIRS=20

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Starting to copy $NUM_DIRS random directories from $SOURCE_DIR to $DEST_DIR"

# Initialize counter
counter=1

# Copy random directories with numbered logging
find "$SOURCE_DIR" -maxdepth 1 -type d | shuf -n "$NUM_DIRS" | while read dir; do
    if [[ "$dir" != "$SOURCE_DIR" ]]; then
        dir_name=$(basename "$dir")
        echo "${counter}- Copying: $dir"
        cp -r "$dir" "$DEST_DIR/"
        echo "  ✓ Successfully copied: $dir_name"
        ((counter++))
    fi
done

echo "Completed! Successfully copied $((counter-1)) random directories to $DEST_DIR"