---
name: iteration-killers
description: When already in iteration loop, four moves that break it fast — ask for console+network evidence, prototype UX variants, ask the strategic question, stop the half-baked compromise. Companion to pre-implement-gates (which prevents loops) — this is what to do when prevention failed.
metadata:
  type: feedback
---

[[pre-implement-gates]] is prevention. This file is rescue — when prevention failed and you're already iterating. The four moves below short-circuit the most expensive loops.

---

## Move 1 — Frontend bug: ask for console + network on iteration #2

When owner reports a frontend bug whose symptom is „it doesn't work" / „doesn't save" / „nothing happens" and you can't see from code alone where the break is — DO NOT iterate 3-4 times guessing.

**The rule:** after the FIRST diagnostic attempt fails to clearly identify the cause, ask for:
1. Screenshot of the **browser console** (errors, logger output, AxiosError detail, React render warnings, stack traces).
2. Screenshot of the **network panel** (relevant request + response body).

User clicking through one more time to share two screenshots is cheaper than three failed shipping cycles.

### React subtle bugs to check before guessing further

- **`useMutation` returns NEW object reference on every state change.** If it's in `useMemo` deps (e.g. `columns`), children remount on every `isPending` flip → all internal state lost.
  Fix: don't put mutation object in deps — `mutation.mutateAsync` is stable.
- **`instanceof` fails across module boundaries under Vite HMR.** After dev server restart, `instanceof MyError` returns false even for valid instances.
  Fix: duck-type with `name` + property checks.
- **`useEffect` with `[open, value]` deps resets state on every parent re-render** that creates a new `value` object literal.
  Fix: deps `[open]` only; sync on false→true transition.
- **`autoFocus` on inputs inside floating popovers can trigger window scroll events.** If popover closes on scroll → disappears immediately.
  Fix: scroll-close → NO. Outside-click + Esc — yes.

---

## Move 2 — Multi-variant UX → prototype, not text

When you reach a UX choice point with >1 defensible options (e.g. how warning panel should not push content below: floating popover / reserved slot / toast+border), the reflex should be:

1. **Implement prototypes of 2-3 variants.** Real code, not markdown.
2. **Make them switchable.** Dev toggle (`?warning_variant=A`), feature flag, dev preview page showing all side-by-side.
3. **Tell owner what to test.** Specific user action + expected difference.
4. **They pick; THEN commit full implementation.** Don't start with my favorite — wait for verdict.

**When applies:** multi-variant UX questions, visual decisions with trade-offs felt only in real UI (animation, layout shift, focus, scroll behavior), pattern decisions reused system-wide.

**When NOT applicable:** pure tech decisions (no visual character), single-best-answer UX with clear persona rules, trivial cosmetics.

**Delivery:** 2-3 options max (not more — decision fatigue). Include my recommendation with reasoning. Prototype implementations are temporary — picked one stays, others deleted. Save branch/git tag if abandoned variants have future reference value.

---

## Move 3 — Strategic question before deep build (when >1 architectural path)

When feature has **>1 defensible architectural path**, ask owner choice **BEFORE deep implementation** — not after.

**Signals:**
- >1 way to organize / layout / scope data.
- Long-term implications (multi-tenant, scaling, future features).
- User mental model varies (one persona vs another).
- Architectural — touches data shape OR navigation OR primary surface.

**The ask template:**
> There are N defensible architectural paths for <feature>:
> A) ... B) ... C) ...
> Which path before I deep-build?

List 2-4 paths with one-line trade-off each. Owner picks; commit. Don't deep-build without this answer.

**Counter-signal — don't ask for tactical decisions** (font size, exact wording). Those are own-judgement.

**Step-back signal:** when 3+ catches in a row on „cosmetics" — STOP. The overall structure is likely wrong, not the polish.

### Why pivots are expensive

Mid-implementation revert: discard partially-built code → mental context switch → re-design new approach (often with same blind spots) → re-build → ≥2x time of initial estimate.

---

## Move 4 — STOP half-baked compromises

When trade-offs between consistency vs cleanliness vs work effort are incomplete, don't implement „middle compromise".

**Anti-pattern triggers (correct reflex: STOP):**
- „Add `min-h-[Xrem]` to reserve space" → check if whitespace will be visible problem.
- „Remove `mx-auto`, will align left" → wide empty space on right = half-baked.
- „Add `overflow-x-auto` to keep `h-8`" → hides content that should wrap.
- „Constrain width on this element to match neighbour" → maybe the other should change too?
- „Quick partial fix, we'll see for the rest" → don't.

→ **STOP.** Three options, never the middle:
1. **Make real trade-off** (visually clean, with conscious sacrifice).
2. **Keep current state.** Don't change until better solution.
3. **Ask before deciding unilaterally** (pair with Move 2).

---

## Cross-link

- [[pre-implement-gates]] — preventing the loops in the first place.
- [[persona-doctrine]] — the persona test for when „good enough" really is.
- [[workflow]] — chunk-end reflection codifies these patterns end-of-chunk.
