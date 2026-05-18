---
name: tooling
description: Tool-discipline reflexes — prefer native Claude Code tools over shell escapes; pytest/curl not python -c for backend smoke; visible Chrome over headless agent-browser.
metadata:
  type: feedback
---

Universal pattern: **before writing a Bash command, ask „is there a native Claude Code tool for this?"** If yes — use it. If genuinely no (alembic, pytest, curl, npm) — Bash is correct.

Always-loaded hard rules go in **project root `CLAUDE.md` → „Tooling discipline"**. This file is extended rationale + edge cases.

---

## Code edits → `Edit`, not `sed -i`

- `Edit` shows a diff, is reversible, doesn't require Bash permission.
- `sed -i` mutates files silently; harness rightfully prompts each call (regex mistakes corrupt files; `e` flag executes shell).

**Multi-file replacements:** `Grep`/`Glob` to enumerate → `Edit` each (or `replace_all=true`). Slower per call but auditable + reversible.

Especially dangerous for: Python (indentation), multi-line Tailwind classes.

---

## Different directory → absolute paths or `git -C`, not `cd <path> && X`

- `cd ... && git X` triggers untrusted-hook warning (real risk: target dir's `.git/hooks/` execute). Use `git -C <path> X`.
- `cd ... && some-binary` — use absolute path.
- Subsequent commands need cwd? Two separate Bash calls, not compound.

---

## Venv tools → call binary directly, never `source .venv/bin/activate`

- `source` evaluates arbitrary shell from the file — harness prompts every time.
- Call venv binary directly: `backend/.venv/bin/python`, `.../pytest`, `.../alembic`.

---

## Backend smoke → pytest or curl, not `python -c`

Project has pytest infrastructure (in-memory SQLite, async fixtures, allowlisted) AND a running API (curl allowlisted). Don't reach for ad-hoc `python -c` heredoc.

**Priority order:**
1. **Service-level smoke** → pytest test in `backend/tests/`, `pytest -k <name>`.
2. **API-level smoke** → `curl -s "http://localhost:<port>/api/..."`. Tests full stack.
3. **Browser-level smoke** → visible Chrome MCP.

**Avoid:**
- `cd backend && source .venv/bin/activate && python -c "..."` — THREE security warnings (cd-hook, source-eval, python-arbitrary).
- `python -c "..."` as pipe stage for JSON parsing — use `jq` instead. `jq` supports `.[]` iteration, `if/then/else`, `//` defaults, `"\(.field)"` interpolation, `| length`.

If genuinely need ad-hoc Python eval (rare): `backend/.venv/bin/python -c "..."` (no cd, no source). Still prompts once but only once.

---

## Browser smoke → visible Chrome preferred over headless

**Default to visible Chrome MCP** (Claude in Chrome) for end-to-end browser smoke. Owner watches the flow — sees clicks land, forms fill, pages navigate. „I can see what's happening" is part of trust mechanism.

**When visible (default):** chunk-end smoke, anything owner may want to watch, visual debugging, demo dry runs.

**When headless agent-browser acceptable:** batch verification with no user-watching value, background runs, fallback if Chrome plugin not connected.

**Process:**
1. Verify connection: `mcp__Claude_in_Chrome__list_connected_browsers`.
2. Connected → visible. Not connected → fall back, surface to owner.
3. Take screenshots at key states.

---

## Why the security prompts aren't noise

The prompts that fire on `sed -i`, `cd && X`, `source`, `python -c` catch real risk classes (file corruption, hook execution, shell injection, arbitrary code). Native tools (Edit, Read, Grep, Glob) exist precisely to do these workflows without those gates.

---

## Cross-link

- [[workflow]] — chunk-end browser smoke is part of persona pass.
