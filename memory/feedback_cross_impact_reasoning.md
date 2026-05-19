---
name: cross-impact-reasoning
description: When changing behavior, immediately scan related code paths for cases that need parallel updates. Core rule — bugs from forgotten cross-impact cost more than the original change.
metadata:
  type: feedback
---

**Rule:** When changing the behavior of a constraint, validator, lifecycle transition, or shared invariant — IMMEDIATELY enumerate all related code paths that participate in the same invariant and update them in the same chunk. Don't ship the change and wait for downstream bugs.

**Why:** Bugs from forgotten cross-impact are far more expensive than the original change. The user has to test, find the bug, report, fix path-by-path. Every extra round-trip is unnecessary friction and lost trust. Caught multiple times where a "scoped" change turned out to need 2-3 paths updated.

**How to apply:**

Before declaring a behavior change done, run this checklist:

1. **What invariant did I just change?** (e.g., "duplicate entry_number" — was global-unique, is now active-unique).
2. **Which other code paths touch this invariant?**
   - CREATE path — validators on input
   - UPDATE path — validators on input
   - **Lifecycle transitions** — hide, unhide, archive, unarchive (the trap)
   - DELETE path — even if soft-delete
   - Restore-from-trash / unarchive — re-validate before activating
   - Bulk ops, imports, migrations
3. **For each: does the new invariant still hold?** Walk through manually OR write a quick test that explores the new edge case.
4. **If not — fix in same chunk OR explicitly defer with TODO + memory note.**

**Classic trap example (the one that prompted this rule):**

Changed: "duplicate entry_number" check from "all entries" to "only active". Reasoning: archived entries should release the number. Sound.

What I missed: unhide path. With new rule, two entries with same number can both exist (one active, one hidden) at rest. But when user unhides the archived one → two ACTIVE entries with the same number. The unhide path didn't re-validate, so the duplicate slipped in.

Fix would have been trivial IF caught at the same time. Found via user testing → embarrassing.

**Mental model:**

Each invariant has multiple "guard posts" — write, update, lifecycle transition, bulk import. Changing the invariant means **walking the same checklist at every guard post**. If you only update one, the invariant is leaky.

**Cross-impact triggers — situations that almost always need a scan:**

- Constraint relaxation (allow X that was previously forbidden) → check restore/promote/unarchive paths
- Validation tightening → check existing data + bulk import + migrations
- Status field semantics change → check all paths that read status (display, filters, search)
- Soft-delete behavior → check whether "hidden" entities still occupy unique constraints
- Schema config knob change → check all consumers (form, list, detail, search, validator, export)
- Cache invalidation change → check all queries that touch the affected data (also see [[cache-invalidation-cascade]])

**Pair with:** [[pre-implement-gates]] Gate 3 (Mental simulate end-to-end) — cross-impact is one specific form of mental simulation. If you can name an invariant being changed, run the path enumeration explicitly.

Related: [[user-visible-errors]] — when a missed cross-impact case eventually triggers a backend rejection, it MUST surface to the user (not just console).
