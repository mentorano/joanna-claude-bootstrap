---
name: keyboard-nav-popover-iterations
description: Popovers с heterogeneous editors (text input + date picker trigger + select + multi-value button) require hybrid keyboard nav — cursor-aware за text inputs, unconditional за triggers, escape rule за role=option/menuitem/gridcell. Plain „arrows always navigate cells" and „arrows only navigate when cursor at edge" both fail.
metadata:
  type: feedback
---

# Keyboard nav в popovers с mixed editor types

**Rule:** Когато popover съдържа heterogeneous editors (text input + date picker trigger + select dropdown + button + multi-value field), arrow-key navigation MUST be hybrid:

1. **Text input children** → cursor-aware: arrow ← / → navigates cell ONLY когато cursor е на edge на input value. Mid-text arrows move caret normally.
2. **Date trigger / select trigger / button / dropdown trigger** (no text caret context) → unconditional cell navigation.
3. **Inside open dropdown / calendar / menu** (role=option / menuitem / gridcell) → escape: native nav wins, cell nav suppressed. User е „внутре" в widget-а, не на cell level.

**Why:** Pure „arrows always navigate cells" breaks text editing — user can't move caret to fix typo in middle of name. Pure „arrows navigate only when cursor at edge" breaks non-text controls — date trigger / select / button have no caret edge → arrow never works.

Hybrid feels right naturally because user mental model matches: „arrows on text edge mean done with this cell; arrows on non-text mean navigate" — and inside open dropdown, arrows belong to the dropdown.

**How to apply:**

```ts
function handleArrow(e: KeyboardEvent, direction: "next" | "prev") {
  const target = e.target as HTMLElement;
  
  // 1. Inside open menu/list/calendar — let native nav handle
  if (target.matches('[role="option"], [role="menuitem"], [role="gridcell"]')) {
    return;
  }
  
  // 2. Non-text controls — unconditional navigate
  if (target.matches('button, [role="combobox"], [role="button"]')) {
    e.preventDefault();
    navigateCell(direction);
    return;
  }
  
  // 3. Text inputs — cursor-aware
  if (target.matches('input[type="text"], input[type="number"], textarea')) {
    const input = target as HTMLInputElement;
    const atEdge =
      direction === "next"
        ? input.selectionStart === input.value.length
        : input.selectionStart === 0;
    if (atEdge) {
      e.preventDefault();
      navigateCell(direction);
    }
    return;
  }
}
```

**Anti-patterns hit during iterations:**
- v1 „always navigate" → user can't fix typo in name; reports „typing is broken".
- v2 „only at cursor edge" → arrows never work on date triggers / selects; user can't escape cell.
- v3 hybrid (above) → ships.

**Validation:** after change, manually verify keyboard nav in popover на:
- Text input (mid-text, cursor at start, cursor at end)
- Date trigger (calendar closed, calendar open)
- Select trigger (dropdown closed, dropdown open)
- Multi-value field (add button, remove button)
- Tab / Shift+Tab between cells (always works, regardless of cursor position)
- Enter / Escape (commit / cancel)

Related: [[react-identity-churn]] — controls inside popover often have stable-key sensitivities that compound with nav state.
