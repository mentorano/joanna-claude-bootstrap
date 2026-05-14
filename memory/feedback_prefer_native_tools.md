---
name: Prefer Claude Code's native tools over shell escapes for edits and cwd-bound work
description: For code mutations use the Edit tool, not `sed -i`. For commands in a specific directory use absolute paths or git's `-C` flag, not `cd <path> && X`. The shell escapes trigger security prompts that exist for real reasons, and the native tools are safer and reversible.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
Claude Code has native tools designed for these workflows. Use them. Shell escapes are a fallback for genuinely-shell-only operations, not a first reach.

**For editing source files — use `Edit`, not `sed -i`:**
- `Edit` shows a diff, is reversible, doesn't require Bash permission.
- `sed -i` mutates files silently; the harness rightfully prompts each call (regex mistakes corrupt files, `e` flag executes shell).
- Pattern: `Read` the file → `Edit` with `old_string`/`new_string`. Done.

**For multi-file replacements — still avoid `sed -i`:**
- `Grep` or `Glob` to enumerate files containing the pattern.
- `Edit` each one (or `Edit` with `replace_all=true` for whole-file repeats).
- Slower per call than `sed`, but no permission cost, proper diff visibility, no risk of corrupting files on regex misfires.

**For commands in a different directory — don't `cd <path> && X`:**
- `cd ... && git X` triggers an untrusted-hook warning (real risk: target dir's `.git/hooks/` execute). Use `git -C <path> X` instead — git's built-in path flag avoids cd entirely.
- `cd ... && some-binary` — use the absolute path: `<path>/some-binary` or `<absolute>/<binary>`.
- Subsequent commands need the cwd? Two separate Bash calls, not a compound.
- Claude Code's Bash tool already runs in project root; for most commands, no cwd manipulation is needed at all.

**For running venv tools — don't `source .venv/bin/activate`:**
- `source` evaluates arbitrary shell from the file — the harness prompts every time.
- Call the venv binary directly: `backend/.venv/bin/python`, `backend/.venv/bin/pytest`, `backend/.venv/bin/alembic`. Or just use `pytest` / `alembic` (the project's allowlist covers them, and they pick up the venv from `start_backend.sh`'s context).

**Why:** The security prompts that fire on `sed -i`, `cd && X`, `source`, and `python -c` aren't noise — they catch real risk classes (file corruption, hook execution, shell injection, arbitrary code). The native tools (Edit, Read, Grep, Glob) exist precisely to do these workflows without triggering those gates. Reaching for shell escapes when a native primitive exists is choosing prompt fatigue over working with the harness.

**How to apply:** Before writing a Bash command, ask: "Is there a native tool for this?" If yes — use it. If genuinely no (e.g. `alembic upgrade`, `pytest -k X`, `curl`) — Bash is correct. The test is whether a Claude Code tool exists for the same outcome, not whether shell *could* do it.
