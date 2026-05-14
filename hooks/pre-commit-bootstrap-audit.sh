#!/usr/bin/env bash
# joanna-claude-bootstrap — pre-commit reminder.
#
# Scans staged changes for CLAUDE.md / memory file modifications. If found,
# prints a reminder asking whether cross-project patterns from this commit
# should be promoted to ~/Documents/Projects/joanna-claude-bootstrap/.
#
# NON-BLOCKING. Just a reminder — doesn't reject the commit. Set
# `BOOTSTRAP_AUDIT_SKIP=1` env var to suppress completely.

set -euo pipefail

# Skip if explicitly disabled.
if [[ "${BOOTSTRAP_AUDIT_SKIP:-0}" == "1" ]]; then
  exit 0
fi

# Patterns that indicate cross-project candidates may exist.
PATTERNS=(
  "CLAUDE.md$"
  "^backend/CLAUDE.md$"
  "^frontend/CLAUDE.md$"
  "/memory/.*\.md$"
)

# Get staged file list (added + modified + renamed-target).
STAGED=$(git diff --cached --name-only --diff-filter=AMR)

# Match against patterns.
MATCHED=()
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  for pattern in "${PATTERNS[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      MATCHED+=("$file")
      break
    fi
  done
done <<< "$STAGED"

# No matches → silent exit.
if [[ ${#MATCHED[@]} -eq 0 ]]; then
  exit 0
fi

# Print reminder.
echo
echo "─────────────────────────────────────────────────────────────────"
echo "  ⚠  joanna-claude-bootstrap audit — staged convention/memory changes"
echo "─────────────────────────────────────────────────────────────────"
echo
echo "  Modified files:"
for file in "${MATCHED[@]}"; do
  echo "    • $file"
done
echo
echo "  Filter test за всеки нов pattern: ще се прилага ли в hypothetical"
echo "  next project, или е project-specific?"
echo
echo "  Cross-project (PROMOTE)   : JSONB seed gotcha, UI patterns, tool"
echo "                              discipline, generic memory feedback."
echo "  Project-specific (KEEP)   : persona name, domain labels, конкретен"
echo "                              schema design, brand strings."
echo
echo "  Ако promote → sync към:"
echo "    ~/Documents/Projects/joanna-claude-bootstrap/"
echo "  и push отделен commit там."
echo
echo "  (Reminder only — commit-ът ще тече без блокаж.)"
echo "  Suppress: BOOTSTRAP_AUDIT_SKIP=1 git commit ..."
echo "─────────────────────────────────────────────────────────────────"
echo

exit 0
