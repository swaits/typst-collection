#!/usr/bin/env bash
# remove-diff-out.sh
#
# Removes all files (including hidden) in any <pkg>/tests/<test>/diff or out directories.

set -euo pipefail

# 1) Make the shell match hidden files (dotfiles) in globs.
# 2) Let an empty glob expand to zero arguments rather than itself.
shopt -s dotglob nullglob

# 2) Loop over any matching directories: <pkg>/tests/<test>/{diff,out}
for dir in */tests/*/{diff,out}; do
  # Only proceed if it's actually a directory
  if [[ -d "$dir" ]]; then
    echo "Removing files under: $dir"
    # Remove everything inside (including hidden files)
    rm -rf -- "$dir"/*
  fi
done

echo "Done!"
