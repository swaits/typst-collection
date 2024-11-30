#!/bin/bash

# Set the destination directory
DEST_DIR="$HOME/Code/typst-packages-fork/packages/preview"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Loop through all directories in the current directory
for dir in preview/*/; do
  if [ -d "$dir" ]; then
    # Remove trailing slash from directory name
    dir=${dir%/}

    echo "Syncing $dir to $DEST_DIR/$dir..."

    # Use rsync with these options:
    # -a: archive mode (preserves permissions, timestamps, etc.)
    # -v: verbose
    # -z: compress during transfer
    # --delete: remove files in dest that don't exist in source
    rsync -avz --delete "$dir/" "$DEST_DIR/$dir/"
  fi
done

echo "Sync complete!"
