---
name: pre-implement-gates
description: The 3 gates (Inventory / Persona value / Mental simulate) plus Strategic-question + Half-baked tests. Skipping any of them is the root cause of most iteration loops. Procedural ritual lives in root CLAUDE.md.
metadata:
  type: feedback
---

The procedural ritual lives in **project root `CLAUDE.md` → „Pre-implement gates"** (always-loaded). This file holds the **why** + the **patterns** that calibrate how each gate should fire in edge cases.

Three gates plus two tests. When all three fire pre-implement, iteration count drops dramatically.

---

## Gate 1 — Inventory (foundation reconnaissance)

**Trigger:** any new UI feature, extension OR feels-greenfield. Wrong intuition: „feels new → skip inventory". Feels-new only means foundation = shadcn primitives + design tokens + adjacent pages instead of a pilot component. Foundation always exists.

**What to inventory:**
- **Existing pilot/analogue features.** Layout (single/multi column? sections? grid?), sortable/filterable elements, view modes (compact/detailed toggles), affordances (icons always-visible? hover-only?), state transitions (read↔edit without jump?), URL state sync, loading/empty/error states, keyboard shortcuts, pagination, search highlight, bulk actions, audit links.
- **Shadcn foundation** (when no pilot exists): primitives installed in `src/components/ui/` (Card, Badge, Tabs, Select, Skeleton), design tokens in `index.css` (`--card`, `--primary`, `--chart-1..5`), chart palette default — is it grayscale needing override?
- **Visual baseline V1** is part of inventory: mixed card sizes (hero + secondary + footer), icons in headers colored with chart tokens, design tokens not raw colors, trend chips / badges / tabular-nums for numbers, visual separation between sections.

**Default action:** match the foundation. New surface should be visually indistinguishable from existing analogue — a persona swapping between surfaces should say „same UI". Only schema-driven internals differ.

### Anti-pattern triggers (correct reflex: stop and inventory first)

- „Greenfield design for the new component" — pilot is the shape.
- „Modern look" — pilot is the shape.
- „Default for new components" — pilot is the default.
- „Schema-driven means generic = flatter" — schema-driven means declarative, not shape-loss.
- „This feature is not strictly needed for minimum viable" — feature parity IS minimum viable for extension.

### Conflict resolution (when pilot doesn't fit cleanly)

| Case | Right move |
|---|---|
| Pilot has feature, new use case doesn't conceptually need it | Add it anyway (dormant). Persona consistency > minor dead code. |
| Pilot has feature, new use case needs different declarative knobs | Extract pilot's hardcoded logic into schema config knob, default to pilot's value. |
| Pilot feature genuinely non-applicable | **ASK.** Show the feature, explain why it doesn't fit, give options. Owner decides. |

### Schema-aware sub-rule (no hardcoded reference data ids)

Shared components that load per-scope data **NEVER** hardcode pilot/default scope id (e.g. `PILOT_REGISTER_TYPE_ID = 1`). Always:
1. Accept scope (`registerType` / `tenantId` / `instanceId`) as prop.
2. Conditional render based on schema config, not assumed pilot schema.
3. Skip data loading entirely if schema doesn't have the field.

### One pattern per interaction (declared upfront)

For features with multiple cards/components with similar controls (period selectors, scope selectors, granulation, confirmation), declare ONE pattern globally **before building the first card**, not per-card. Record the declaration in a comment on the feature composer.

When adding a new card with similar control: use declared pattern. If it doesn't fit — stop, ask, update declaration globally; don't deviate locally.

---

## Gate 2 — Persona value (user-facing UI only)

**Trigger:** any feature with user-visible value — affordances, analytics, dashboards, navigation, search.

**For analytics / dashboards / reporting** — the dangerous category:

1. **Brainstorm 5-8 candidate insights per persona** before any backend query design.
   - „What does the operator persona want to see/do day-to-day?"
   - „What does the boss/decision-maker want politically/strategically?"
   - „What's impossible on paper / in existing tooling that becomes possible here?" — that's the real value-add.
2. Score each candidate: collective demand? Impossible-on-paper? Data available? Pick 3-5 strongest.
3. Validate with owner if >3 plausible variants.
4. **Then build.** This list drives backend queries, not the other way around.

Common boss-relevant analytics axes for data-rich domains:
- Aggregate value (total turnover)
- Concentration (top N — concentration signal can be anti-corruption-adjacent)
- Distribution (price brackets, categories, time)
- Trend (vs previous period — accelerating/slowing)
- Comparison (market vs contract — discount signals)
- Compliance (% missing data, % overdue)

**For new affordances** — the restraint category:

Persona test = 4 questions, default „don't add" unless 2+ say yes:
1. **Use case clarity** — real persona use case, or theoretical?
2. **Redundancy check** — alternative path exists (nav, breadcrumb, related surface)?
3. **Noise cost** — for users who don't use it, is it visual clutter?
4. **Persona test** — would the operator actually use this?

Anti-pattern triggers:
- „Better to add this, just in case."
- „Convenient to have a shortcut here."
- „Pilot has it, copy-paste here." (Valid only if pilot added it deliberately.)
- „Easy to add, no harm." — affordances cost user attention.

**For axes / filters / scopes** — persona mental model:

What does the user remember when searching this record? — that's the filter axis. Date filters → semantic event date (the date user remembers), NOT `created_at` (audit concern). Audit vs search separation: `created_at` + `created_by_id` live in audit log filters; search filters are for finding business records.

**Inspect data shape before defaulting** — before defaulting chart windows / default tab / range param:
1. Query actual data (curl API or DB) and inspect spread.
2. Sparse fields need different default than dense.
3. Default tab/window = where data shape is richest.

---

## Gate 3 — Mental simulate end-to-end

**Trigger:** any UI change, however small.

### Layout shift (the most common catch)

For each state transition: read↔edit, show/hide of conditional element, loading→loaded, empty→filled, toggle, append:
- Does anything push siblings or content below?
- Heights match between alternative renders?
- Reserved slot for conditional content?

Standard techniques:
- `table-layout: fixed` + explicit column widths.
- `min-h-[Xrem]` reserved space for elements that change size.
- Floating/absolute overlays (Portal or absolute child).
- Equal-height between alternative renders.
- Stable footer slot for counters/status (not inline-on-active).
- Buttons hold focus on click (`onMouseDown={(e) => e.preventDefault()}`).
- `useLayoutEffect` deps for popover repositioning include EVERYTHING that changes popover size.

### Conditional render audit

For each `{cond && <X/>}`:
- What stays in place when condition flips? What appears new?
- Sibling in flex row → reserve slot or use `invisible pointer-events-none` placeholder.
- Container slot stable, not pop-up new sibling.

### Event flow / portal containment

React events bubble via **React tree**, not DOM. Portalled content (createPortal → document.body) still propagates to parent React component.

When parent has relevant `onClick` (row-click → navigate), every portalled overlay inside needs explicit boundary stop:

```tsx
<div ref={popoverRef} onClick={(e) => e.stopPropagation()}>
  {/* All interactive children inside */}
</div>
```

Single boundary stop is DRY (vs per-button `stopPropagation`).

### Cache reactivity (TanStack Query)

New `useQuery({ queryKey: ["X"] })` → audit ALL existing mutations:
- Which writes/deletes might change X data?
- Each one must `invalidateQueries({ queryKey: ["X"] })` in `onSuccess`.
- Edit existing mutation files **in the same PR**.

Without this, queries silently stale (60s default `staleTime`).

### Native HTML defaults (no duplicate, no slow)

- `<input type="search">` has native ×. Custom × → suppress native.
- `<input type="date">` has native calendar icon — keep by default.
- `<select>` has native dropdown arrow — don't add own.
- Native `title=` has 1-2s browser delay → fine for a11y, too slow for primary discovery. For affordances needing fast hover reveal (abbreviated headers, icon-only buttons) → CSS-only tooltip; keep `title=` as a11y fallback.

### Overlay vs floating (anchored UI)

| Use absolute (overlay) when | Use fixed (floating + portal) when |
|---|---|
| Anchor in document flow, parent NOT overflow-hidden | Anchor in overflow-restricted container (table cell, scrollable list item) |
| Acceptable for overlay to scroll with anchor | Overlay must escape clipping context |

**Default: absolute overlay.** Fixed is escape hatch — requires scroll listener for reposition.

---

## Strategic question test (architectural choice points)

**Trigger before deep-building any feature.**

Are there >1 defensible architectural paths? Examples:
- Multi-X dashboard: two-zone vs single-dropdown vs primary-with-swap.
- IA shift: Home = dashboard vs registers list with dashboard above vs separate route.
- Data scope: cross-X aggregates vs X-specific only vs both.

**Signals:** >1 way to organize / layout / scope data; long-term implications (multi-tenant, scaling); user mental model varies; architectural — touches data shape OR navigation OR primary surface.

**The ask template:**
> Има N defensible architectural paths за <feature>:
> A) ... B) ... C) ...
> Кой path преди да тръгна с deep build?

List 2-4 paths with one-line trade-off each. Owner picks; commit. Don't deep-build without this answer.

Counter-signal — don't ask for tactical decisions (font size, exact wording). Those are own-judgement.

### UX choice points → prototype, not text

When choice points have UX trade-offs felt only in real UI (animation, layout shift, focus, scroll behavior), **don't describe in markdown** — prototype switchable variants (`?variant=A/B/C`). Owner picks on real UI behavior, then commit full implementation.

---

## Half-baked test (before declaring „ready")

If the result is visually whole — ship.

If you're tempted to ship „a compromise" — STOP. Anti-pattern triggers:
- „Add `min-h-[Xrem]` to reserve space" → check if whitespace will be visible problem.
- „Remove `mx-auto`, align left" → wide empty space on right = half-baked.
- „Add `overflow-x-auto` to keep `h-8`" → hides content that should wrap.
- „Quick partial fix, we'll see for the rest" → don't.

→ Either commit to full clean solution, leave existing state, or ask. Don't ship the middle.

---

## Cross-link

- [[workflow]] — chunk-end persona pass + reflection pass is safety net; pre-implement gates are first line.
- [[persona-doctrine]] — persona-friendly defaults are the tiebreaker for Gate 2 micro-decisions.
- [[iteration-killers]] — when pre-implement gates fail and you're already in iteration loop.
