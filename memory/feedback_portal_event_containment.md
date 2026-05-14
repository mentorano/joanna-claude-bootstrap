---
name: portalled-content-needs-explicit-event-containment
description: "React events bubble чрез REACT tree, не DOM tree. Portalled content (EditPopover, modals, FloatingWarningPanel) пак propagates events до parent React component → click на бутон в popover може да fire onClick на parent row. Винаги stopPropagation на boundary на portalled content."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

В A.Multi-register-Polish session 2026-05-14 добавих row-click navigation на <tr> в EntriesList. Очаквах, че EditPopover (portal-ed към document.body) не bubble-ва до row. Грешка: React events propagate чрез React component tree, не през DOM. Click на toggle „Към общо свободно поле" вътре в hybrid_property editor → bubble до EditPopover → bubble до <td> → bubble до <tr onClick> → navigate. Joanna хвана.

## Правило

Portalled content (createPortal към document.body — EditPopover, modal-и, dropdown overlays, FloatingWarningPanel) изисква **explicit event containment** ако parent React component има relevant event handler.

## Pattern

На popover/overlay root:
```tsx
<div
  ref={popoverRef}
  onClick={(e) => e.stopPropagation()}
  // ...
>
  {/* All interactive children — buttons, links, toggles — propagate
      events UP до parent, освен ако този onClick ги хваща */}
</div>
```

Single stopPropagation на boundary е по-добре от per-button. По-малко обстоятелствено code, harder да забравиш.

## Кога важи

- Row click → детайл page: всички EditPopover/InlineEditField/InlineEditPanel cells изискват boundary stop.
- Modal с outside-click-to-close: modal content stops propagation, иначе button click closes modal.
- Dropdown menus: same.
- Tooltip с interactive content: same.

## Кога НЕ важи

Single-purpose portalled content без relevant parent handler (e.g. toast notification на top-right) — не нужно.

## Anti-pattern

Per-child stopPropagation:
```tsx
<button onClick={(e) => { e.stopPropagation(); doX(); }}>X</button>
<button onClick={(e) => { e.stopPropagation(); doY(); }}>Y</button>
<a onClick={(e) => e.stopPropagation()} href="...">Z</a>
```
Дублирано, easy да забравиш на нов button. Boundary stop е DRY.

## How to apply

При adding row-click или similar parent handler:
1. Mental scan на all portal-ed content вътре в row (EditPopover в всяка cell, warning overlays, etc.).
2. Verify all portalled roots stop propagation.
3. Test с persona pass — click on every interactive element inside popover, проверявай че row click не fire-ва.

Pair-ва се с frontend/CLAUDE.md „React subtle bugs that surface server-side".
