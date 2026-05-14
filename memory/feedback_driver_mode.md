---
name: Driver mode — chunk-granularity execution, senior-engineer posture
description: How Joanna wants Claude to operate on this project — drive at chunk level not task level, ask only for destructive/external actions or real product forks, group fine-grained slices into milestones.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
When Joanna approves a scope (a phase, or a chunk like "A.CRUD" or "A.Validation"), execute the WHOLE thing without asking permission at each sub-step. Check in at meaningful milestones, not per task.

**Ask permission only for:**
- Destructive/external actions (commit, push, delete, deploy, AWS calls)
- Real product forks where more than one answer is defensible
- Genuine blockers (missing info, conflicting requirements, broken assumption)

**Be proactive** — add small adjacent polish, surface gotchas, propose improvements at milestone reports. Senior-engineer behavior, not task-runner.

**Bigger slices than they look on paper.** `_workspace/product-notes.md` section 10 lists fine-grained slices (A0, A1, ..., D2). In execution, group them into chunks. The agreed mapping:
- A0 + A1 + A2 + A6 = **A.CRUD** chunk
- A3 = **A.Validation**
- A4 + A6 = **A.Roles+Hide+Dashboard**
- A5 = **A.Search**

Each chunk is one milestone, not one task.

**Why:** Joanna is the PM and the project's only "engineer" is Claude — there's no in-house dev. Asking permission per task drowns her in interruptions and stops the project from moving at the pace it needs to hit demo gates. The driver-mode pattern was explicitly agreed and captured in STATUS.md "Working mode notes" section.

**How to apply:** Once Joanna says "do chunk X" or "next chunk", proceed end-to-end (backend + frontend + tests + polish), only surfacing decisions when they matter at chunk-completion debrief. If unsure whether something is "in scope for this chunk", lean toward including reasonable polish that supports the chunk's user-facing story; ask only when including-or-not would meaningfully change the chunk's shape or timeline.

---

## Extend the spec, don't take it literally — persona-usage exhaustion pass

Joanna gives **direction**, not exhaustive specs. When the chunk scope says "2-3 validators for the pilot section" or names a few example cases, treat the count and the named examples as a starting point and a direction — not as the full deliverable. Before declaring the chunk done, run an exhaustion pass from the persona's actual usage:

- "If Леля Гинче types garbage / random / sloppy data into each field, do I catch it?"
- "Are there silent skips — validators returning None for malformed input instead of warning?"
- "Are there fields with no validator at all that the placeholder / sample data clearly implies a format for?"
- "What edge cases from `_workspace/product-notes.md`, scan samples, or transcripts am I leaving uncovered?"

If gaps surface, either fix them or proactively surface them with a concrete proposal — don't ship the literal minimum and wait for Joanna to catch the holes.

**Why this is here:** 2026-05-13 — Joanna entered obvious garbage ("acg" for all prices, "agacgфacg" for АОС) on the freshly-shipped A.Validation chunk; only 2 of 4+ expected warnings fired. Price validators silently SKIP-ed unparseable strings; АОС / decision_text / disposition_type had no validators despite clear format hints in their placeholders. Joanna's explicit framing: she wants to give direction, not exhaustive lists, and have Claude extend the case coverage. This is a sharpening of the "be proactive, senior-engineer" stance above — same principle, concrete enforcement mechanism.

**The closing-pass rule:** At the end of every chunk, before TaskUpdate → completed and before STATUS.md updates, do a one-paragraph mental walk-through as the persona. List what is being caught and what is NOT being caught. Either patch or propose. Pair this with [[feedback-doc-reflex]]'s chunk-end checkpoint — both run at the same closing moment.
