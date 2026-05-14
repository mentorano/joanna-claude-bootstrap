#!/usr/bin/env bash
# Install joanna-claude-bootstrap pre-commit hook into a project.
#
# Usage:
#   hooks/install.sh [/path/to/project]
#
# Default target is current working directory.
# Creates symlink, so future bootstrap hook updates apply automatically.

set -euo pipefail

TARGET="${1:-$PWD}"

if [[ ! -d "$TARGET/.git" ]]; then
  echo "Not a git repository: $TARGET" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/pre-commit-bootstrap-audit.sh"
DEST="$TARGET/.git/hooks/pre-commit"

if [[ ! -f "$SOURCE" ]]; then
  echo "Hook source missing: $SOURCE" >&2
  exit 1
fi

if [[ -L "$DEST" ]]; then
  EXISTING=$(readlink "$DEST")
  if [[ "$EXISTING" == "$SOURCE" ]]; then
    echo "✓ Already installed (symlink → $SOURCE)"
    exit 0
  fi
  echo "⚠ Existing pre-commit hook is a symlink to: $EXISTING"
  echo "  Move it aside first, или delete to replace."
  exit 1
fi

if [[ -f "$DEST" ]]; then
  echo "⚠ Existing pre-commit hook found at $DEST"
  echo "  Move it aside (mv .git/hooks/pre-commit .git/hooks/pre-commit.bak),"
  echo "  then re-run this script."
  exit 1
fi

ln -s "$SOURCE" "$DEST"
echo "✓ Installed pre-commit hook → $DEST"
echo "  Source: $SOURCE"
echo
echo "Test it:"
echo "  echo 'test' >> CLAUDE.md"
echo "  git add CLAUDE.md"
echo "  git commit -m 'test'  # ще видиш reminder banner"
echo "  git reset HEAD~1 && git checkout CLAUDE.md  # revert test"
