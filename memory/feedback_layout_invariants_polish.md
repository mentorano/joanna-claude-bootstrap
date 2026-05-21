---
name: layout-invariants-polish
description: When polishing card / list-item content in iteration N, explicitly verify that paired-height / h-full / className-forward / sticky positioning / overflow defaults from prior polish chunks remain intact. Recurring bug class — silent regression of „we already fixed this".
metadata:
  type: feedback
---

# Preserve layout invariants when iterating cards/components

**Rule:** При editing на card / list-item / table-row content в iteration N+1, **explicit-но** verify, че paired-height / h-full / className-forward / sticky positioning / overflow defaults от предишни polish chunks остават intact. Не приемай, че „предишният chunk вече ги фиксира — те просто работят".

**Why:** Polish iterations често засягат отделни props (color, spacing, hover state, label text). Промените изглеждат isolated, но компонентите имат cross-cutting layout invariants — equal heights между paired cards, h-full propagation through wrapper layers, sticky-column z-index, overflow-clip behavior. Тези invariants често живеят в **various** places (Tailwind classes на parent, prop forwarding на child, CSS containment). Една tiny промяна може silently да break един от тях, и резултатът е visible само в specific viewport / data state.

Recurring pattern: dev polish chunk N → fix layout. Polish chunk N+2 → tiny prop change → re-breaks invariant N fixed. User catches: „пак го оправяме".

**How to apply:**

- **При editing на card / list-item visual** → snapshot before-state visually (screenshot or mental model: „what does this look like с минимални data, максимални data, paired with neighbors"). After change → verify same scenarios.
- **Trace className forwarding** when adding new props. Specifically: `className`, `style`, `aria-*` are paths that easily get lost during refactor.
- **Paired-height heuristic:** if component has `h-full` или explicit `min-h-*`, и appear paired (side-by-side in flex/grid), audit за siblings preserving the pair invariant. „Just" tweaking one of them often breaks alignment.
- **Audit sticky positioning** on tables/lists when adding new columns/rows. `sticky left-0 z-20 bg-muted` must stay or first column scrolls under data.
- **Re-render component с realistic data shapes** (empty, single, multi, very long) after change. Not just dev's currently-loaded shape.
- **CSS containment / overflow** check — when wrapping в new container, watch for `overflow-hidden` that clips floating elements (popover dots, badge ribbons).

**Anti-pattern:** assume „polish chunk N fixed this, won't break". Polish chunks have a tendency to break each other if not actively defended.

Related: [[smoke-test-downstream]], [[ui-pattern-symmetry-catch]] — same family of „walk the surface, не just the change point".
