---
name: ui-state-hygiene
description: User shouldn't get stuck in implicit states they didn't choose. Auto-close after natural completion; wrap-around for serial navigation; progressive disclosure for affordances that aren't useful yet.
metadata:
  type: feedback
---

**Rule:** Don't leave the user in implicit UI states they didn't actively enter. After an action with a natural completion (create, save, submit, archive, restore), auto-close the surrounding mode UI. For serial navigation, wrap around at boundaries instead of dead-ending. For affordances that have no purpose given current data state, hide them.

**Why:** "Hanging" UI states force users to manually close — but they didn't enter them manually either. They're left with a "Close" or "Done" button whose purpose they don't understand. Worse: they don't notice the state at all and abandon, only to realize later they were stuck in a transitional UI.

Caught multiple times this session:
- "Add new entry" row stayed open after successful create → user saw "Close" button and was confused about what it did.
- Arrow keys in serial-entry form didn't wrap → user pressed Right on the last cell, nothing happened, didn't know how to continue.
- Search/filter UI showed on empty registers where filtering had no purpose → noise.

**How to apply:**

**1. Auto-close after implicit completion:**

If an action has a "natural endpoint" (created the record, saved the file, archived the entry), close the surrounding mode UI:
- After `mutate` resolves, call `setMode(false)` or `onClose?.()`.
- Show success toast (so feedback isn't lost in the close).
- For batch flows (user wants to add many in succession): re-open via the entry trigger ("Нов запис" / "Add new"). One extra click per batch item is fine — the trade is between batch convenience and getting-stuck-in-mode confusion.

Examples:
- Add-row in a table: close after save, re-open on next add click.
- Form modal: close after submit.
- Inline create: collapse back to original view.

**2. Wrap-around for serial navigation:**

In keyboard-driven serial-entry surfaces (filling cells in a row, completing a multi-step form):
- Tab/→ at the last field → wrap to the first.
- Shift+Tab/← at the first → wrap to the last.
- Enter+save → jump to next empty, wrapping if needed.

Without wrap: user hits the boundary, nothing happens, has to manually click back. Boundary should be invisible to the user — they keep typing/saving until everything is done.

**3. Progressive disclosure for unhelpful affordances:**

Hide UI elements when they have no purpose given current state:
- Search box: hide when item count < N (typically 2-3) — searching across 1 item is silly.
- Filter row: hide when list is fully empty AND no active filter (nothing to filter, no filter to clear).
- "Bulk action" buttons: hide when no items selected.
- Pagination: hide when total fits in one page.

Show the affordance only when actively useful. Don't reserve space for it "in case" — that's static noise.

**4. Sensible defaults when state is unclear:**

When the user lands in a mode without explicit intent, pick a default that's "obvious next step":
- Empty register → focus on "create first entry" CTA, not empty filters.
- Just-archived register → auto-flip filter so archived items stay visible (user just acted on one, wants to see results).
- Just-restored item → switch view to active.

**Anti-pattern (the trap):**

Mode-without-exit: opening a transitional UI (modal, inline expanded row, drawer) and not auto-closing it after the natural completion. User is left holding the bag — a "Close" button that they didn't ask for.

**Pair with:** [[user-visible-errors]] — auto-close on success requires that errors are visibly surfaced; otherwise user thinks it succeeded just because UI closed.
