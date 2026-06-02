---
name: feedback-validation-bounds-match
description: Backend Pydantic ge/le bounds трябва да match frontend min/max constraints. Mismatch → 422 reject на valid input → optimistic rollback → user вижда „bounce back" без error.
metadata:
  type: feedback
---

Когато frontend има min/max constraints (slider, input min/max, drag-resize floors), backend Pydantic Field(ge=, le=) трябва да match. Mismatch case: frontend позволява V, backend rejects with 422 → optimistic rollback wipes user input → user sees „bounce back" без visible error.

**Why:** Frontend defaultColumn `minSize: 40` (drag floor). Backend `width_px: int = Field(ge=60, le=2000)` rejected 40-59 range. Frontend optimistic update succeeded; mutation hit backend → 422 → onError rolled back → column snapped back. User: „драгвам, връща се". Silent failure без error message в UI.

**How to apply:**
- При нов user input control с bounds (min/max, range, step): cross-check backend Field bounds SAME chunk. Document choice in BOTH places.
- При adjusting bounds на едната страна → audit other side immediately.
- 422 responses should map to user-visible errors (Pydantic detail → toast/inline). Silent 422 = invisible bounce-back perception.
- Litmus test за „X не персиства / връща се": check Network tab → 422 → bounds mismatch #1 hypothesis.
- Свързано: frontend clamping (TanStack getSize, Math.clamp) може да различава от raw drag state. Винаги clamp BEFORE mutate, не разчитай че getSize() returns post-clamp value за rxxxxw state.
