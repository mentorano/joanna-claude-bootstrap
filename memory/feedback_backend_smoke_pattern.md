---
name: Backend smoke testing — use pytest or curl, not `python -c` heredoc
description: When smoke-verifying backend behavior, default to the project's pytest infrastructure or curl against the running API. Avoid `cd ... && source venv && python -c "..."` — triple security warning, and there's always a cleaner alternative.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
When smoke-verifying backend behavior at chunk-end, **don't reach for ad-hoc `python -c` heredoc**. The project has pytest infrastructure and a running API — use them.

**Default smoke patterns (in this priority order):**

1. **Service-level smoke** → add a pytest test in `backend/tests/` and run `pytest -k <name>`. The conftest has in-memory SQLite with async fixtures already wired. Already in allowlist.

2. **API-level smoke** → `curl -s "http://localhost:8001/api/..."` with appropriate query/payload. Already in allowlist. Tests the full stack (API → service → DB), not just the service in isolation.

3. **Browser-level smoke** → Claude in Chrome MCP (per `feedback_browser_smoke.md`). For end-to-end user flows.

**Avoid these patterns:**

- `cd backend && source .venv/bin/activate && python -c "..."` — triggers three security warnings at once (cd-hook-execution, source-as-shell-eval, python-arbitrary-code). Each prompts. The value over pytest is zero — pytest already gives you the venv, the imports, the async runner, and the DB fixture.
- `python3 -c "import sys, json; ..."` for JSON pretty-printing — use `python3 -m json.tool` (already approved) or `jq` (auto-allowed) instead.
- **`python -c "..."` as a pipe stage** for *any* JSON parsing or formatting — including iterating arrays, conditional output, field extraction, length calculations. The reflex to reach for python because "this is too complex for jq" is wrong: jq is designed for exactly this. It supports `.[]` iteration, `if/then/else`, `//` defaults, `"\(.field)"` interpolation, `| length`. If you can write it in python `for t in items: print(f"...")`, you can write it in jq `.[] | "..."`. Example: `curl -s "http://localhost:8001/api/register-types" | jq -r '.[] | "\(.code): \(.field_definitions // [] | length) fields"'` instead of a python heredoc.
- `source <venv>/bin/activate` in any context — `source` evaluates arbitrary shell code; the harness will always prompt. If you need the venv's interpreter, call it directly: `backend/.venv/bin/python <script>` or `backend/.venv/bin/pytest`.

**If you genuinely need ad-hoc Python evaluation** (rare — usually a pytest test is faster):
- Use `backend/.venv/bin/python -c "..."` (no cd, no source). Still prompts (`python -c` is interpreter execution), but only once per invocation instead of three warnings stacking.

**Why:** This project's prototype phase has been generating prompt fatigue around backend smoke. Looking at `.claude/settings.local.json` historically, multiple sessions have approved one-off `python3 -c "..."` invocations as separate entries — each unique payload became its own entry. The cleaner pattern (write a real test, or hit the API via curl) avoids this entirely and produces durable artifacts (a test that runs in CI later).

**How to apply:** Before writing a backend smoke command, ask: "Could this be a pytest test in 3 minutes, or a curl call?" Almost always yes. If yes — write the test or curl. The 3 minutes pay back many times over (no prompts, reproducible verification, future regressions caught).
