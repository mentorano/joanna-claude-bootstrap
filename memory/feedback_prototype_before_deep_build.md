---
name: prototype-before-deep-build
description: For UX decisions where the right pattern is uncertain (save model, mode behavior, interaction granularity), prototype the minimum first. Don't write 15 ConfirmDialogs before validating whether ANY of them is correct.
metadata:
  type: feedback
---

**Rule:** When an interaction pattern decision is genuinely uncertain (save model, gating, mode granularity, navigation behavior), build the MINIMUM viable version first to validate. Don't deeply implement a pattern only to throw it away after user testing reveals a different model fits better.

**Why:** Real UX trade-offs (perceived friction, focus flow, layout shift, error recoverability) are only felt with actual interaction. Verbose text descriptions or bullet trade-offs don't surface them. Building a deep implementation of pattern A, then learning A is wrong and refactoring to B, is sunk-cost work. The wider the surface implementing pattern A, the more thrown away.

Caught in digital-archives session 2026-05-19: save model went through three iterations in one session:
- v1: per-action auto-save (no confirms)
- v2: per-action auto-save + ConfirmDialog per action (15+ confirms wired across surface)
- v3: per-section edit-mode toggle + batched save with one ConfirmDialog

v2 was fully implemented (every save handler wrapped in `useConfirm()`), then user found it too friction-heavy. Threw it away for v3. ~30-45 min of wired-up confirms wasted.

**How to apply:**

When making a UX decision where >1 pattern is defensible:

1. **Identify the decision** ("save model", "edit mode granularity", "navigation behavior").
2. **Pick 2-3 candidate patterns** with brief description of each (1-2 lines).
3. **Implement the MINIMUM of one pattern** — single control / single section / single instance — enough for user to feel the interaction.
4. **Show the user.** Ask "does this feel right?"
5. **Only after validation, replicate the pattern across the full surface.**

**Specific cases:**

- **Save model** (per-action auto / batched / hybrid): wire ONE control with the proposed model. Show user. Don't wire all 15 before validating.
- **Confirmation dialogs** (when/where): wire one impactful action's dialog. Get feel for friction. Then decide universal rule.
- **Mode toggle granularity** (per-section / global / inline): build ONE section's mode toggle. Validate. Then replicate.
- **Layout / scroll behavior**: real interaction reveals issues invisible in mockup.

**Anti-pattern (the trap):**

"I've decided on pattern X, I'll just go ahead and apply it everywhere." Then user sees the full thing and says "wait, this is wrong" — and now N controls need refactoring.

Cost asymmetry: prototype-first costs 5-10 min extra for the first instance. Deep-build-first costs 30+ min refactor when wrong.

**When this rule DOESN'T apply:**

- Pattern is canonical/proven (e.g., InlineEditField inline edit). Just use it.
- Pattern is purely procedural with no UX surface (backend refactor, config restructure).
- Decision was already validated in prior work.

The rule kicks in specifically when: **decision is novel AND uncertain AND has UX trade-offs felt only in real interaction**.

**Pair with:**

- [[pre-implement-gates]] Strategic question test ("prototype switchable variants before deep build") — this is the same principle, generalized beyond architectural choices to interaction patterns.
- [[consistent-save-model]] — save model specifically is one of the canonical decisions that benefits from prototype-first.
