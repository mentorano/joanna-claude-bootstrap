---
name: memory-birth-audit
description: When formalizing a new memory rule that names a bug class, IMMEDIATELY audit existing codebase for other instances of the same pattern. Don't wait for the next bug — symmetric instances are likely already lurking.
metadata:
  type: feedback
---

**Rule:** The moment you formalize a memory rule that names a class of bug (e.g., "archived entries shouldn't block active-resource constraints", "every async mutation needs user-visible feedback"), pause and grep/audit existing code for OTHER instances of the same pattern. Fix them in the SAME chunk, or file an explicit follow-up task.

**Why:** Memory rules are written FROM observed bugs. The pattern that caused one bug is almost always present in N other places — the codebase has uniform conventions, so bug patterns spread. If you write the memory and move on, you've documented the rule but left existing symmetric anti-patterns in place. The next bug from the SAME class will hit user-facing code before your rule applies.

Caught explicitly in digital-archives session 2026-05-19: I wrote `cross-impact-reasoning.md` after fixing a `entry_number_duplicate` bug where archived entries blocked active reuse. Memory clearly stated "archived ≠ blocker for active-resource constraints". **30 minutes later, user hit the EXACT same pattern in `kind-change data check`** — also counted archived entries. The bug pre-existed; my memory just didn't trigger an audit sweep.

**How to apply:**

When writing a new memory rule:

1. **Identify the class** of bug the rule covers. Name the pattern (e.g., "archived data counted as active for X constraint", "validator hardcodes canonical keys").
2. **Grep the codebase** for the pattern signature:
   - Searches like `RegisterEntry.status` and check if it filters; `field_definitions` consumers; etc.
   - If the bug was in a validator, audit all validators. If in a mutation handler, audit all mutation handlers.
3. **Fix all in same chunk** (small risk) OR **file a TODO/followup** (large risk, may need separate PR).
4. **In the memory file itself**, list the audited locations + their fix status.

**Mental model:**

Rule-writing = "I've named a bug class". Bug class = "exists in N places, fixed only 1". Memory without sweep = "I documented the rule, the codebase still has N-1 instances".

**Anti-pattern (the trap):**

Memory pattern: "discovered bug X → fixed instance A → wrote memory about pattern → moved on". Instance B/C/D in codebase wait for next user discovery → repeat hit → embarrassment.

Better pattern: "discovered bug X → wrote rule → swept codebase for instances B/C/D → fixed all → wrote memory listing covered locations".

**Pair with:**

- [[cross-impact-reasoning]] — cross-impact is the broader rule about behavior changes. This is the specific complement: when you ALSO formalize the cross-impact pattern as a memory, audit existing code immediately.
- [[retro-rank-by-impact]] — both rules concern HOW you apply learning, not just what to learn.
