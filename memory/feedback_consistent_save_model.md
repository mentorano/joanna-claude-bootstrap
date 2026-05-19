---
name: consistent-save-model
description: Don't mix batched save (Save/Cancel) and per-action auto-save in the same surface. Users settle into one mental model; mixed surfaces cause silent data loss.
metadata:
  type: feedback
---

**Rule:** Within a single configuration/admin surface, commit to ONE save model — either everything auto-saves on action, or everything batches into an explicit Save. Don't mix. The user develops muscle memory for one pattern; if some controls save and others don't, they will lose work without noticing.

**Why:** User feedback (caught multiple times): "I added a column then walked away, came back, my changes were gone — I thought it auto-saved like everywhere else".

A hybrid model (auto-save for simple edits, batched for complex) seems elegant in design but breaks under real usage. User can't always tell which actions are which class. They click, see the UI update, assume it's persisted. With batched save, they need an explicit save action — but if other surfaces auto-save, the muscle is wrong.

**How to apply:**

When designing a config/admin surface, pick **one** model upfront:

**Per-action auto-save (recommended for most cases):**
- Each user action immediately calls the mutation.
- Optimistic UI optional (state updates immediately, mutation in background).
- Toast on success/failure.
- No global Save/Cancel buttons.
- Matches "inline edit" pattern users learn first.

**Batched with explicit Save/Cancel:**
- All edits accumulate in local "draft" state.
- Visible "dirty" indicator (banner, prominent Save button).
- Save button is prominent — not subtle.
- Browser `beforeunload` warning on dirty state.
- Cancel reverts everything.

**Choose by context:**

- Simple admin edit (rename a label, toggle a flag): auto-save.
- Multi-step config with interdependencies (database migration design, user-permission grid): batched.
- Forms with required-field validation: depends — auto-save if independent fields, batched if must validate as a whole.

**If the surface has many controls** — auto-save is almost always right. Batched introduces "I forgot to save" risk that compounds with control count.

**Pairing with confirm dialogs:**

Auto-save model + ConfirmDialog for impactful actions = best balance. Each action requires explicit confirm step (no silent change), but no global save needed. See [[confirm-dialog-rule]].

**Anti-patterns:**

- Mixing: rename auto-saves, reorder batches — user assumes auto-save throughout, loses reorder work.
- Batched save with subtle indicator: user doesn't see dirty state, leaves with unsaved.
- Optimistic UI without error rollback: user sees change, mutation silently fails, state diverges from server.

**When in doubt: ask the user before deciding.** Save model is one of the few UX choices that's costly to change later (users have already trained their muscle memory). Discuss upfront, then commit.
