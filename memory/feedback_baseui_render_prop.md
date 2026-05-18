---
name: baseui-render-prop-not-aschild
description: Base UI primitives use `render` prop for element substitution, not Radix's `asChild`. Hits at every shadcn primitive that wraps Link/anchor/custom element
metadata:
  type: feedback
---

shadcn v4 uses **Base UI** primitives (not Radix UI). Different substitution API: Base UI uses `render={<Component />}` prop, not Radix's `asChild` + child element pattern.

```tsx
// ❌ TypeScript error: 'asChild' does not exist on type ...
<Button asChild><Link to="/x">Click</Link></Button>
<DropdownMenuItem asChild><Link to="/x">Item</Link></DropdownMenuItem>
<SheetTrigger asChild><Button>Open</Button></SheetTrigger>

// ✅ Base UI render prop
<DropdownMenuItem render={<Link to="/x" />}>Item</DropdownMenuItem>
<SheetTrigger render={<Button>Open</Button>} />

// ✅ Or: use `buttonVariants` className on Link directly (without primitive)
<Link to="/x" className={buttonVariants({ size: "lg" })}>Click</Link>
```

**Why:** Radix's `asChild` merged props into child element via Slot pattern; Base UI's `render` prop substitutes the underlying element on the way down. Different mechanism, different API. shadcn v4 generator emits Base UI code (since 2025 migration), not Radix.

**How to apply:**
- Reach for `render={<X />}` on first instinct, not `asChild`.
- When `render` doesn't fit cleanly (e.g. for `Button` styled link): pull the `buttonVariants` named export and className it on the underlying Link/anchor directly. Canonical shadcn pattern when `render` is awkward.

Same Base UI gotcha family: [[baseui-select-value-children-as-function]], [[shadcn-grouplabel-needs-group]].
