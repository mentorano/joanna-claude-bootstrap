---
name: Documentation reflex — capture stances, decisions, gotchas as they emerge
description: Proactively catch documentation-worthy moments during work and write them to the correct file without waiting for Joanna to ask. Includes the decision tree for where each kind of knowledge belongs and the chunk-end checkpoint as a safety net.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
Don't wait for Joanna to ask. While working, watch for documentation-worthy moments and capture them immediately to the right place.

**Trigger moments — capture when:**
- Joanna expresses a strong stance ("много държа на X", "никога Y", "винаги Z") — even casually mid-conversation
- A non-obvious decision gets made (architectural, library, data shape, test approach)
- Something bites us or a future session (gotcha, footgun, environment quirk)
- A convention is crystallizing across multiple files (we did it this way twice — it's now a pattern)
- A scope shift or re-prioritization happens
- Joanna confirms a non-obvious approach worked — validation moments are as important as corrections

**Decision tree — where each kind of knowledge goes:**

| Kind of knowledge | Place | Example |
|---|---|---|
| Joanna's stance elevated to project principle | Root `CLAUDE.md` principles section | "Audit every mutation" |
| Concrete backend convention or pattern | `backend/CLAUDE.md` | "Emit audit event in same DB transaction as the mutation" |
| Concrete frontend convention | `frontend/CLAUDE.md` | "Inline edit, not modal-on-click" |
| Non-obvious architectural decision | `STATUS.md` → "Key decisions made" | "JSON not JSONB until A.Search" |
| Gotcha that bit us | `STATUS.md` → "Known issues / gotchas" | "macOS python3 is 3.9 — venv must be python3.11" |
| Scope shift, new plan, re-prioritization | `ROADMAP.md` | "Phase B no longer depends on Moni's runtime" |
| How Joanna wants Claude to work | Memory feedback file | "Drive at chunk granularity" |
| Pointers to external resources | Memory reference file | "Moni's CSV samples in `_workspace/moni-artifacts/`" |

**Chunk-end checkpoint** — before declaring a chunk done, run this list:
1. Did we crystallize a stance worth elevating to a principle?
2. Did we make architectural decisions for `STATUS.md` "Key decisions"?
3. Did anything bite us → `STATUS.md` "Known issues"?
4. Did the chunk reveal a new backend/frontend pattern?
5. Did the chunk change the plan in `ROADMAP.md`?
6. Did Joanna give working-mode guidance worth a memory file?

Apply continuously, not only at chunk end. The chunk-end checkpoint is a safety net — the primary mechanism is: when the moment happens, name it out loud ("noting this — worth elevating to a principle") and write it before continuing.

**Why:** Joanna is PM, not developer. She catches stance/decision moments verbally; she expects Claude to catch them in writing. The doc-reflex closes the loop between her verbal direction and persistent project state. Without it, every new session re-learns from zero and her strong preferences get diluted. This is the reinforcement loop she explicitly asked for.

**How to apply:** Err on the side of writing. Over-capture is fixable (consolidate later — see `consolidate-memory` skill); under-capture loses knowledge permanently. When unsure whether something is worth capturing, write a 1-line note in `STATUS.md` "Key decisions" or a quick memory file — better than losing it.

**Reinforcement:** If Joanna ever says "this should have been in X" or "why isn't this written down" — that's a meta-correction. Capture it as an addendum to this file, not a separate one. The doc-reflex itself gets sharper over time through her corrections.
