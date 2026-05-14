#!/usr/bin/env bash
# joanna-claude-bootstrap — apply overlay to a target project directory.
#
# Usage:
#   apply.sh [--target PATH] [--project-name "Name"] [--persona "Persona Name"] \
#            [--owner-name "Owner Name"] [--no-memory]
#
# Default --target is the current working directory.
# Placeholders in templates get substituted; result files lose the .template suffix.

set -euo pipefail

# Defaults
TARGET="$PWD"
PROJECT_NAME="My New Project"
PERSONA_NAME="The persona — name placeholder"
OWNER_NAME="Owner"
COPY_MEMORY=1

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --project-name) PROJECT_NAME="$2"; shift 2 ;;
    --persona) PERSONA_NAME="$2"; shift 2 ;;
    --owner-name) OWNER_NAME="$2"; shift 2 ;;
    --no-memory) COPY_MEMORY=0; shift ;;
    -h|--help)
      sed -n '1,15p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ ! -d "$TARGET" ]]; then
  echo "Target directory does not exist: $TARGET" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OVERLAY="$SCRIPT_DIR/overlay"
MEMORY_SRC="$SCRIPT_DIR/memory"

DATE=$(date +%Y-%m-%d)

substitute() {
  local input="$1"
  local output="$2"
  # Note: avoid `sed -i` (per memory feedback_prefer_native_tools); read + write.
  python3 - "$input" "$output" "$PROJECT_NAME" "$PERSONA_NAME" "$OWNER_NAME" "$DATE" <<'PY'
import sys
src, dst, project, persona, owner, date_str = sys.argv[1:]
with open(src, encoding="utf-8") as f:
    text = f.read()
text = (
    text.replace("{{PROJECT_NAME}}", project)
        .replace("{{PERSONA_NAME}}", persona)
        .replace("{{OWNER_NAME}}", owner)
        .replace("{{DATE}}", date_str)
)
with open(dst, "w", encoding="utf-8") as f:
    f.write(text)
PY
}

# Process each .template under overlay/, mirror tree into TARGET (без .template suffix).
echo "Applying overlay → $TARGET"
echo "  project: $PROJECT_NAME"
echo "  persona: $PERSONA_NAME"
echo "  owner:   $OWNER_NAME"

find "$OVERLAY" -type f -name "*.template" | while read -r template; do
  rel="${template#$OVERLAY/}"
  rel="${rel%.template}"
  # Map STATUS/ROADMAP/product-notes templates to root и `_workspace/`.
  case "$rel" in
    product-notes.md)
      dst="$TARGET/_workspace/product-notes.md"
      mkdir -p "$TARGET/_workspace"
      ;;
    *)
      dst="$TARGET/$rel"
      mkdir -p "$(dirname "$dst")"
      ;;
  esac
  if [[ -e "$dst" ]]; then
    echo "  ⚠ $rel — exists, skipping (delete manually if you want to overwrite)"
    continue
  fi
  substitute "$template" "$dst"
  echo "  ✓ $rel → $dst"
done

# Copy memory files. Target depends on CC's per-project memory layout —
# typical path is ~/.claude/projects/<encoded-cwd>/memory/. Здесь го пропускаме
# по default — owner-ът ще ги cp manual когато стартира session в проекта.
if [[ $COPY_MEMORY -eq 1 ]]; then
  echo
  echo "Memory bootstrap (manual step):"
  echo "  Copy memory files from $MEMORY_SRC/"
  echo "  to ~/.claude/projects/<your-project>/memory/"
  echo "  when you first run Claude Code в новия проект."
  echo
  echo "  Files to copy:"
  ls "$MEMORY_SRC" | sed 's/^/    - /'
fi

echo
echo "Done. Next:"
echo "  1. Edit CLAUDE.md (root) — add product context, persona details, principles."
echo "  2. Edit _workspace/product-notes.md — authoritative product knowledge."
echo "  3. git add -A && git commit -m 'Apply joanna-claude-bootstrap overlay'"
