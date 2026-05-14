---
name: overlay-not-floating-for-anchored-ui
description: "Когато добавям UI element 'anchored до друг element' (warning panel под input, popover до cell), preferred pattern е position:absolute спрямо relative parent → scroll следва anchor. Position:fixed (floating) detach-ва от anchor при scroll → визуално 'се отдeля'. Joanna 2026-05-14 explicit: 'не може ли да е овеър панел без да е флоутинг'."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

В A.Multi-register-Polish session 2026-05-14 имплементирах FloatingWarningPanel като `position: fixed` с portal към document.body. Логика: warning не push-ва flow. Но: при scroll на page-а, warning стои фиксиран на viewport top/left, anchor input-ът се мести → warning „отделя се". Joanna хвана: „не може ли да е овеър панел без да е флоутинг".

Refactor: `position: absolute` спрямо `relative` parent — warning scroll-ва се с anchor-а в document flow.

## Правило

За UI element „anchored до известен trigger/anchor":

### Use absolute (overlay) когато:
- Anchor е в document flow (не fixed).
- Containing container НЕ има `overflow: hidden` clipping issues.
- Acceptable за overlay-а да scroll-ва с anchor.
- Use case: detail page warning panels, dropdowns под inputs, tooltips.

### Use fixed (floating) когато:
- Anchor е в `overflow: hidden` container и overlay трябва да излезе извън.
- Use case: cell editor popover в horizontally-scrolled table (cell е overflow-x-auto'-нат); modal centered in viewport; global toasts.
- Изисква: scroll listener да recalc position така че следва anchor — иначе detach-ва.

## Specific implementation patterns

**Absolute overlay (preferred):**
```tsx
<div className="relative">
  <input ... />
  {showOverlay && (
    <div className="absolute left-0 right-0 top-full z-30 mt-1 ...">
      {/* overlay content */}
    </div>
  )}
</div>
```

**Fixed floating (when needed):**
```tsx
{open && createPortal(
  <div style={{ position: "fixed", top, left, zIndex: 50 }}>
    {/* content */}
  </div>,
  document.body
)}
// + scroll/resize listeners reposition
```

## Anti-pattern

Default to `position: fixed + portal` без помисляне дали anchor scroll-context-ът е problematic. Fixed е „по-силен" tool, не „по-чист" — често е unnecessary.

## Decision tree

1. Anchor в document flow? И parent НЕ е overflow-hidden? → **absolute overlay** в relative parent.
2. Anchor е в overflow-restricted container (table cell, scrollable list item)? → **fixed + portal + scroll listener**.
3. Не е anchored (global toast, modal centered)? → **fixed + portal** without anchor.

Pair-ва се с frontend/CLAUDE.md „Filter / options panels = absolute-positioned dropdown" rule.
