---
name: workflow
description: How Claude should work — driver mode (chunk granularity), documentation reflex, chunk-end persona+reflection passes, verify scope against code not stale docs.
metadata:
  type: feedback
---

How Claude should operate on Joanna's projects. The pre-implement gates ([[pre-implement-gates]]) cover „what to do before code"; this file covers „how to manage the work loop end-to-end".

---

## Driver mode — chunk granularity, senior-engineer posture

When the owner approves a scope (a phase, or a chunk like „A.CRUD" / „A.Validation"), execute the WHOLE thing end-to-end without asking permission at each sub-step. Check in at meaningful milestones, not per task.

**Ask permission only for:**
- Destructive / external actions (commit, push, delete, deploy, AWS calls).
- Real product forks where >1 answer is defensible (architectural — see [[pre-implement-gates]] strategic question test).
- Genuine blockers (missing info, conflicting requirements, broken assumption).

**Be proactive.** Add small adjacent polish, surface gotchas, propose improvements at milestone reports. Senior-engineer behavior, not task-runner.

**Owner gives direction, not exhaustive specs.** When chunk scope says „2-3 validators for the pilot" or names few example cases, treat that as starting point — run an exhaustion pass from persona's actual usage before declaring done:
- „If operator types garbage into each field, do I catch it?"
- „Are there silent skips — validators returning None for malformed input instead of warning?"
- „Are there fields with no validator at all that placeholders / sample data clearly imply a format for?"
- „What edge cases from source material am I leaving uncovered?"

If gaps surface — fix or proactively surface with concrete proposal. Don't ship the literal minimum and wait for owner to catch the holes.

**Why:** Owner is typically PM, not dev. Asking permission per task drowns them in interruptions and stops the project from moving at demo pace.

---

## Documentation reflex — capture stances as they emerge

Don't wait for owner to ask. While working, watch for documentation-worthy moments and capture them immediately to the right place.

**Trigger moments — capture when:**
- Owner expresses a strong stance („I really care about X", „never Y", „always Z") — even casually mid-conversation.
- A non-obvious decision gets made (architectural, library, data shape, test approach).
- Something bites us or a future session (gotcha, footgun, environment quirk).
- A convention is crystallizing across multiple files (we did it this way twice — it's now a pattern).
- A scope shift or re-prioritization happens.
- **Owner confirms a non-obvious approach worked** — validation moments are as important as corrections.

### Decision tree — where each kind of knowledge goes

| Kind of knowledge | Destination |
|---|---|
| Owner's stance elevated to project principle | Root `CLAUDE.md` principles section |
| Concrete backend convention or pattern | `backend/CLAUDE.md` |
| Concrete frontend convention | `frontend/CLAUDE.md` |
| Non-obvious architectural decision | `STATUS.md` → „Key decisions made" |
| Gotcha that bit us | `STATUS.md` → „Known issues / gotchas" |
| Scope shift, new plan, re-prioritization | `ROADMAP.md` |
| How owner wants Claude to work (operating reflex) | Memory feedback file |
| Pointers to external resources | Memory reference file |

**Err on the side of writing.** Over-capture is fixable (consolidate later); under-capture loses knowledge permanently.

---

## Chunk-end ritual — persona pass + reflection pass

End of every chunk (= unit of work owner declared „done"), run two successive passes BEFORE final commit/push:

### Pass 1 — Persona walk-through

Walk user-facing flows as the operator persona would. Smoke test in real browser (see [[tooling]] „visible Chrome").

- Does the golden path work without interruption?
- Are edge cases (empty / error / read-only) handled gracefully?
- Does anything jump / shift / surprise?
- Long text wrap, large numbers fit, sort order correct, truncations have tooltips, empty states meaningful, loading skeletons shape-match content, tab switches preserve context.

5-10 minutes catches MANY „owner catches → revert and fix" loops.

### Pass 2 — Reflection pass (analyze MY behavior)

Walk my own behavior across the chunk. Learnings worth durable rule?

1. **Catches by owner.** Each: pre-existing rule that didn't apply (reinforce); new pattern uncaptured (new rule); recurring catch in same chunk (top-priority reflex).
2. **Iteration loops.** Which tasks took >2 iterations? Pre-implement gate extension candidate?
3. **Recurring patterns.** Issues appearing in multiple unrelated tasks = cross-cutting, high-leverage rule candidate.
4. **Single-incident curiosities.** One-off issues = project-specific gotcha (STATUS.md, not durable rule).
5. **Successful approaches.** What pre-empted pitfalls? Capture positive lessons too.

### Categorize each finding

| Type | Examples | Route |
|---|---|---|
| **Project-specific** | Persona name, brand strings, schema design, domain entities | Project CLAUDE.md + STATUS iteration log |
| **Cross-project generic** | UI pattern, workflow, code convention | Project CLAUDE.md + project memory + bootstrap memory + bootstrap overlay template |
| **Pure process / collaboration** | Communication style, decision protocol | Project memory + bootstrap memory (no CLAUDE.md mirror — meta-rule) |

**Test for cross-project:** „Will this pattern apply unchanged in a hypothetical new project?" Yes → cross-project.

### End-of-chunk sequence

```
1. Implementation tasks complete.
2. Persona pass: walk user flows, smoke test.
3. ⭐ Reflection pass: analyze my behavior, extract findings.
4. Categorize + route + write findings.
5. Update STATUS.md (chunk summary + iteration log if catches occurred).
6. Update ROADMAP.md if plan shifted.
7. Commit + push (only when owner approves).
8. Declare chunk done.
```

---

## When fixing a bug — generalize the rule before documenting

**Meta-lesson from a recurring bug class (caught + fixed twice).**

When fixing a bug, the rule you write becomes durable. If the rule is too narrow, the same bug class recurs through a different trigger. The narrow rule doesn't pattern-match the new trigger → author of refactor feels safe → bug returns.

**Pattern:** Before documenting a fix, ask:
1. **What is the BUG CLASS?** (the underlying mechanism — not just „what triggered it this time")
2. **What are ALL the triggers that could surface the same class?** (think beyond what you just hit)
3. **Is the symptom invisible in dev flow?** (no throw, no visual jump) — if yes, narrow rules will recur; needs regression test + multi-layer defense.
4. **Will subsequent refactors naturally re-introduce the bug?** (if your fix relies on a particular pattern that „looks unnecessary" later) — leave defensive code comment explaining WHY.

**Anti-pattern (causes recurrence):**
- „When X happens, do Y." — narrow rule, only matches X
- One-line gotcha entry without code example
- Fix without regression test
- No code comment at the fix site

**Pattern (survives refactors):**
- „This bug class happens when ANY of [A, B, C, D] cascades through [Z]." — broad rule, matches all triggers
- Code example with `❌ bug` vs `✓ fix` side-by-side
- Repo-tracked regression test that fails if bug returns
- Code comment at fix site explaining WHY the seemingly-redundant code is critical
- Multiple layers: STATUS gotcha + memory checkpoint + frontend/backend conventions section + regression test

**Concrete example (the originating case):** Reference instability in `useMemo` dep chains feeding TanStack Table parent → cells re-mount → child component state lost. First fix wrote „don't put mutation object in `useMemo` deps". Subsequent refactor used `?? []` + `.filter()` — different triggers, same bug class. Author felt safe (no mutation in deps), bug returned. Second fix broadened the rule to all reference-instability triggers + added regression test + code comment + multi-layer doc defenses. See `feedback_pre_implement_gates.md` Gate 3 „Reference stability" for the full pattern.

---

## Verify scope against code, not stale docs

STATUS.md / ROADMAP.md / handoff sections can desync from reality. Each chunk often ships more than its bullets describe (small adjacent polish, drive-by fixes); deferred concern may be addressed in tangential change.

**Before:**
- Recommending a chunk's scope to owner („variant A vs B vs C")
- Estimating effort / blast radius
- Choosing next priority based on „what's deferred"
- Designing migrations or refactor plans

→ **READ the relevant code.** Verify the doc's „missing X, deferred Y" claims are still true.

When owner pushes back with „check first" / „verify" → **accept immediately**. Don't double down on framing derived from docs. Owner has direct usage signal that docs are out of step.

---

## Cross-link

- [[pre-implement-gates]] — what to do before code.
- [[persona-doctrine]] — the persona test, applied throughout.
- [[iteration-killers]] — when in iteration loop and want to break it fast.
- [[tooling]] — which tool for what.
- [[audit-default]] — value statement on persistence.
