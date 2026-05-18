---
name: shadcn-grouplabel-needs-group
description: shadcn v4 DropdownMenu / Menu / Select / Radio *Label primitives wrap Base UI GroupLabel which requires a Group ancestor — runtime crash without it
metadata:
  type: feedback
---

`DropdownMenuLabel` (and analogous `*Label` primitives in shadcn v4 Menu / Select / Radio components) wraps Base UI's `MenuPrimitive.GroupLabel`, which requires a `MenuPrimitive.Group` (i.e. `<DropdownMenuGroup>`) ancestor in the React tree. Without it: runtime crash on first open — `Base UI: MenuGroupRootContext is missing. Menu group parts must be used within <Menu.Group>.`

**Why:** Base UI separated GroupLabel from Item to give a11y consumers explicit `role="group"` + `aria-labelledby` wiring. The crash is intentional — silent fall-through would break screen readers.

**How to apply:** Whenever using `DropdownMenuLabel`, wrap label + items it labels in `<DropdownMenuGroup>`. Same for analogous primitives. TypeScript passes; browser opens; crash on first dropdown open. Catch via browser smoke pre-commit ([[workflow]] chunk-end persona pass).

Pattern:

```tsx
<DropdownMenuContent>
  <DropdownMenuGroup>
    <DropdownMenuLabel>...</DropdownMenuLabel>
    <DropdownMenuItem>...</DropdownMenuItem>
  </DropdownMenuGroup>
  <DropdownMenuSeparator />
  <DropdownMenuItem>...</DropdownMenuItem>  {/* outside group OK */}
</DropdownMenuContent>
```
