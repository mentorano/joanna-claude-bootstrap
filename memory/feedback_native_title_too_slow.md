---
name: native-title-too-slow-for-discovery
description: "Native HTML `title=` attribute has 1-2s delay before the browser tooltip appears — adequate for accessibility / screen readers, but too slow for primary visual discovery (abbreviated headers, icon-only buttons, abbreviated badges). For immediate hover affordance build a CSS-only tooltip (absolute-positioned span with opacity transition). Keep `title=` too as accessibility fallback."
metadata:
  type: feedback
---

Native HTML `title=` attribute shows the browser tooltip after ~1-2 seconds of hover delay. That delay is fine for accessibility (screen readers parse the attribute immediately, regardless of visual delay) and for secondary discoverability, but it is too slow for primary visual hint — users typically do not hold hover for 1-2 seconds before moving on.

**Why:** The tooltip delay is a platform-level decision (Apple HIG, Windows accessibility guidance). You can't override it via CSS/JS.

**How to apply:** For affordances the user needs to discover via hover (abbreviated table headers, icon-only buttons without visible label, abbreviated badges, truncated text with full value on hover) — build a CSS-only tooltip as the primary visual hint. Keep `title=` set as accessibility fallback.

CSS tooltip pattern (Tailwind):

```tsx
<button className="group relative ..." title={fullLabel}>
  {icon}
  <span
    role="tooltip"
    className="pointer-events-none invisible absolute left-0 top-full z-30 mt-1 whitespace-nowrap rounded-md bg-slate-900 px-2 py-1 text-xs text-white opacity-0 shadow-md transition-opacity duration-100 group-hover:visible group-hover:opacity-100"
  >
    {fullLabel}
  </span>
</button>
```

Key:
- `pointer-events-none` so it doesn't block clicks on the trigger
- `z-30` over sticky elements (z-20)
- `whitespace-nowrap` so tooltip doesn't wrap in narrow contexts
- `transition-opacity duration-100` for gentle reveal
- Set `position: relative` on a parent (or via Tailwind `relative`) for absolute positioning to anchor correctly

Test for applicability: if you expect the user to see the tooltip in normal flow (without deliberately holding hover) → use CSS tooltip. If the tooltip is purely an a11y fallback / occasional reminder → native `title=` is sufficient.

Pairs with [[native-affordances]] — different angle: native is NOT enough when speed of disclosure matters. The two memories together: use native when it's good enough; build custom only when native is genuinely insufficient.
