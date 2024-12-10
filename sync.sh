#!/bin/bash

# How we use rsync
RSYNC_OPTS="--archive --delete --itemize-changes --human-readable"

# Set the destination base directory
DEST_DIR="$HOME/Code/forks/typst-packages-fork/packages/preview"

# Ensure the destination base directory exists
mkdir -p "$DEST_DIR"

# ANSI color codes
BOLD="\033[1m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
RESET="\033[0m"

echo -e "${BOLD}${BLUE}============================="
echo -e "      Typst Sync Tool"
echo -e "=============================${RESET}\n"

# Loop through all subdirectories in the current directory
for dir in */; do
  if [ -d "$dir" ]; then
    # Remove trailing slash from directory name
    dir=${dir%/}

    # Check if typst.toml exists in the directory
    TYPST_TOML="$dir/typst.toml"
    if [ ! -f "$TYPST_TOML" ]; then
      echo -e "${RED}Warning:${RESET} $TYPST_TOML not found. Skipping ${CYAN}$dir${RESET}."
      continue
    fi

    # Extract the version number from typst.toml
    version=$(awk -F '"' '/^version/ {print $2}' "$TYPST_TOML")

    if [ -z "$version" ]; then
      echo -e "${RED}Warning:${RESET} Could not determine version for ${CYAN}$dir${RESET}. Skipping."
      continue
    fi

    # Construct the destination directory path including version
    VERSIONED_DEST_DIR="$DEST_DIR/$dir/$version"

    # Create a shortened path representation, replacing the DEST_DIR part with '...'
    SHORT_PATH="\$${VERSIONED_DEST_DIR#$DEST_DIR}"

    # Ensure the versioned destination directory exists
    mkdir -p "$VERSIONED_DEST_DIR"

    echo -e "${BLUE}----------------------------------------------------------------${RESET}"
    echo -e "${BOLD}${BLUE}Syncing ${CYAN}$dir${BLUE} to ${CYAN}$SHORT_PATH${BLUE}${RESET}"
    echo -e "${BLUE}----------------------------------------------------------------${RESET}"

    # Run rsync and colorize output
    rsync $RSYNC_OPTS "$dir/" "$VERSIONED_DEST_DIR/" | while IFS= read -r line; do
      if [[ "$line" == *"deleting "* ]]; then
        echo -e "${RED}$line${RESET}"
      elif [[ "$line" == ">"* || "$line" == "<"* ]]; then
        echo -e "${GREEN}$line${RESET}"
      else
        echo "$line"
      fi
    done

    echo -e "${BOLD}${CYAN}Done syncing ${dir}${RESET}\n"
  fi
done

echo -e "${BOLD}${GREEN}Sync complete!${RESET}"
