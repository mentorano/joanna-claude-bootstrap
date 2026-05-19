---
name: confirm-dialog-rule
description: Every impactful or destructive save in admin/config surfaces MUST go through a ConfirmDialog with old→new preview before persisting. Project-wide core rule.
metadata:
  type: feedback
---

**Rule:** Every impactful or destructive save action goes through a ConfirmDialog before persisting. This applies to ALL projects, not project-specific.

**Why:** Auto-save UX where admin/config changes "just save" leads to accidents. Admin clicks by mistake, labels get mangled, schema gets reshuffled, settings disappear. Confirmation friction is intentional UX cost for impactful operations.

Better: "register accidentally renamed once, fixed in 30 seconds" >> "one confirm dialog click per change".

**How to apply:**

In **admin / config surfaces** (anything touching schema, lookups, register metadata, permissions, archive, kind change, structural settings):

- **Confirm BEFORE persist.** Every save handler:
  1. Validates input.
  2. Opens ConfirmDialog with descriptive title + before/after preview.
  3. Awaits user confirm/cancel.
  4. On confirm → `mutateAsync` → toast.
  5. On cancel → throw "cancelled" (for InlineEditField stays in edit mode) or return (for select/checkbox — natural revert via cache state).

Use a **Promise-based `useConfirm()` hook** pattern:

```tsx
const { requestConfirm, ConfirmModal } = useConfirm();

const handleSave = async (next) => {
  // ... validation
  const ok = await requestConfirm({
    title: "Rename the column?",
    description: `From „${old}" to „${new}".`,
  });
  if (!ok) throw new Error("cancelled");
  await mutate(...);
};

return <>{...} {ConfirmModal}</>;
```

**Description content:** Show old → new value pairs, or clear description of impact. Not just "Are you sure?". User must see WHAT will change before they confirm.

**Per-edit pattern matches per-action auto-save:** Each individual change goes through its own confirm. Admin has explicit visibility for every change. See [[consistent-save-model]].

**Where this applies:**

- Schema changes (rename column, kind change, reorder, add column, compact toggle, section change)
- Resource metadata (title, legal_basis, description)
- Lookup values (rename, add new, archive)
- Permission grants/revokes
- Archive/unarchive (often already has ConfirmDialog with reason — keep)

**Where NOT applicable:**

- Normal CRUD by end users (employees editing records, etc.) — inline edit + audit log is sufficient.
- Read-only views / navigation actions.
- Trivially reversible UI state (toggle compact view, change sort order — local-only, no backend persistence).

**Pair with:** [[consistent-save-model]] (per-action save) — confirms are per-action too, not batched.
