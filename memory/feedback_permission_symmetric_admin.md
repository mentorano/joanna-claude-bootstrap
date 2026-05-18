---
name: permission-symmetric-admin-for-shared-resources
description: Admin pages for resources that lower-role users mutate through another flow default to that-role view + non-destructive edit. Restrict only destructive ops to admin
metadata:
  type: feedback
---

When building an admin page for resource X, and a lower-role user (e.g. employee, not admin) already CREATES X through another flow (e.g. inline "+ new option" in a form), default the admin page to:

- **View:** lower-role+ (they need to see what exists, to avoid creating duplicates).
- **Edit non-destructive** (label, description, name): lower-role+ (symmetric with inline create — same role that can introduce can also fix typos).
- **Destructive** (archive, delete, deactivate, merge): admin+ (affects all users, higher impact).

**Why:** if the lower role can already add X, asymmetric to forbid them from reading X back or fixing a typo on their own contribution. Also: seeing existing inventory before adding new is a discrete duplicate-prevention behavior — admin-only barrier on view suppresses it.

**Backend pattern:** one PATCH endpoint, service-level guard for destructive fields:

```python
@router.patch("/{id}", ...)
async def update(payload, actor=Depends(require_lower_role)):
    if payload.status is not None and actor.role not in {"admin", "superadmin"}:
        raise HTTPException(403, "Destructive op admin-only")
    ...
```

One endpoint, split permissions per operation. Cleaner than two endpoints.

**Frontend pattern:**
- Page top-level gate: lower-role helper (e.g. `canEditX = canCreateX`).
- Per-action button gating: hide destructive buttons for non-admin (placeholder "—" in action column, **not** disabled grey'd button — disabled attracts attention to action user can't take).

Reinforces [[persona-doctrine]] visible-affordances principle (don't hide affordances from users who conceptually should have them).
