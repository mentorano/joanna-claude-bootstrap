---
name: feedback-html5-dnd-click-guard
description: HTML5 native DnD fires click event AFTER drop. Ако header има клик handler (sort, popover open) И drag handler (reorder), click trigger-ва след drop → unintended popover/sort. Guard с justDraggedRef + setTimeout(100).
metadata:
  type: feedback
---

При HTML5 native DnD, browser event sequence е: mousedown → dragstart → dragover → drop → click. Click event firing AFTER drop е DOM standard, но често unintended когато същият element има и click handler за різне purpose.

**Why:** Hit digital-archives Chunk C (2026-05-26) при column reorder в edit mode. Headers имаха:
- `onClick`: opens style popover в edit mode
- `onDragStart` / `onDrop`: reorder колоните

Drop на header → reorder happens → click event fires → popover opens unintentionally. User: „защо popover-ът отваря след drag?".

**How to apply:**
- Pattern за guarding:
```ts
const justDraggedRef = useRef(false);
const onDragEnd = () => {
  justDraggedRef.current = true;
  setTimeout(() => { justDraggedRef.current = false; }, 100);
};
const onClick = () => {
  if (justDraggedRef.current) return;  // skip click след drag
  doNormalClickAction();
};
```
- 100ms е safe window — click fires immediately after drop, ref се reset-ва преди next user gesture.
- Alternative: `e.preventDefault()` в drop handler не works за click — те са separate event lifecycles.
- Свързано с general principle „separate gesture handlers must coexist без interference" — important за edit modes които multiplex single element with multiple actions.
