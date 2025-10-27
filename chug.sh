#!/usr/bin/env bash
set -euo pipefail

SRC_REPO_ROOT="$(pwd)"
DEST_PARENT="../swaits-typst-collection" # change if you like

DIRS=(
  codly-languages
)

command -v git-filter-repo >/dev/null || {
  echo "git-filter-repo is required. Install via 'uv tool install git-filter-repo' (or pipx/pip)."
  exit 1
}

mkdir -p "$DEST_PARENT"

for d in "${DIRS[@]}"; do
  [ -d "$d" ] || {
    echo "Skip: '$d' not found in $(pwd)"
    continue
  }

  TARGET="$DEST_PARENT/$d"
  echo
  echo "==> Splitting '$d' → '$TARGET'"

  rm -rf "$TARGET"
  git clone --no-local --branch main --origin origin "$SRC_REPO_ROOT" "$TARGET"

  (
    cd "$TARGET"

    git filter-repo --force \
      --path "$d/" \
      --path-rename "$d/:"

    # ---- Tag rename: '<dir>-X.Y.Z' -> 'vX.Y.Z' (annotated, with message) ----
    # Peel old tags to the commit/object they point to to avoid nested tags.
    while IFS= read -r oldtag; do
      # only proceed if the (filtered) repo still has this tag
      git rev-parse -q --verify "refs/tags/$oldtag" >/dev/null || continue

      peeled=$(git rev-parse -q --verify "${oldtag}^{}" || true)
      [ -z "$peeled" ] && continue

      ver="${oldtag#${d}-}"
      newtag="v${ver}"

      if git rev-parse -q --verify "refs/tags/$newtag" >/dev/null; then
        echo "Tag exists, deleting old: $oldtag"
        git tag -d "$oldtag" >/dev/null
      else
        # annotated tag with message equal to tag name (avoids interactive prompt)
        git -c advice.nestedTag=false tag -a "$newtag" -m "$newtag" "$peeled"
        git tag -d "$oldtag" >/dev/null
        echo "Renamed: $oldtag -> $newtag  (at $peeled)"
      fi
    done < <(git tag -l "${d}-*")

    # standalone: drop the monorepo remote that filter-repo rewired
    git remote remove origin || true

    echo "Done: $TARGET"
  )
done

echo
echo "All splits complete under: $DEST_PARENT"
