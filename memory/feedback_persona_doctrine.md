---
name: persona-doctrine
description: Persona-friendly UX defaults, affordance restraint, mock-the-breadth — the tiebreaker for any UX micro-decision. Project supplies the specific persona name and terminology.
metadata:
  type: feedback
---

Every project has a primary user persona — the pragmatic operator who just wants to complete a task and move on. The persona's primary risk is **adoption friction**, not lack of features. Every UX micro-decision passes through the mental test: „what would this persona do seeing this for the first time?" — pick the option where they succeed without thinking.

This doctrine is applied as **Gate 2 of the pre-implement gates** (see project root CLAUDE.md). This file is the generic calibration manual; project supplies the specific persona name (e.g. „Леля Гинче" for municipal employees, „the analyst" for finance dashboards) and any domain-specific terminology canon.

---

## Persona-friendly defaults table

| Decision | Persona-friendly default | Wrong default to reach for |
|---|---|---|
| Save/cancel affordance | Visible ✓/✕ buttons next to input | Keyboard shortcut hint only |
| Edit affordance on filled field | Always-visible pencil icon | Show pencil on hover only |
| Empty editable field | Render input directly, ready to type | „— click to edit" placeholder |
| Long-form label vs abbreviation | Full term in detail/form labels | Abbreviation (in user-facing space) |
| Composed cells in dense table | Pencil on hover (concession to density) | Same-as-detail always-visible |
| Toggle/preference default | Whatever requires least learning | Whatever I think is „more powerful" |
| Mode switch (toggle) | Preserve user input, transfer between modes | Wipe content on switch |
| Entity card / row representing one thing | Whole element clickable | Small button in corner |
| Conditional element appears | Stable container slot, no shift | Bare `{cond && <X/>}` sibling |

**The mental test:** „What would the operator persona do seeing this for the first time?" Pick the option where they succeed without thinking.

**Less obviously: don't ask owner to choose the default when the persona already tells you which one.** The default IS part of the implicit spec.

---

## Affordance restraint — less is more

Before adding ANY new interactive element (link, button, dropdown, scope, affordance), four questions, default „don't add" unless 2+ say yes:

1. **Use case clarity.** Real persona use case, or theoretical?
2. **Redundancy check.** Alternative path exists (nav, breadcrumb, related surface)?
3. **Noise cost.** For users who don't use it, is it visual clutter?
4. **Persona test.** Would the operator actually use this?

Anti-pattern triggers (correct reflex: STOP):
- „Better to add this, just in case."
- „Convenient to have a shortcut here."
- „Pilot has it, copy-paste here." (Valid only if pilot added it deliberately.)
- „Easy to add, no harm." — affordances cost user attention.

---

## Domain terminology canon (project supplies the canon)

Each project picks ONE term per concept in UI labels (the principle is „one of each UI element" extended to terminology). Project's CLAUDE.md / frontend CLAUDE.md should define a canon table:

| Concept | UI label | Avoid in UI |
|---|---|---|
| (e.g. hidden-status record) | (e.g. „Архивиран") | (e.g. „Скрит") |
| (e.g. paper original) | (e.g. „регистър") | (e.g. „тефтер") |
| ... | ... | ... |

**Abbreviation rule:** in dense tables where horizontal space is constrained, abbreviated headers are OK (with CSS-tooltip for full label on hover). In detail or form labels, write the full term — operator doesn't know jargon abbreviations by heart.

Code identifiers, API names, file names → English. UI text to user → project's UI language.

---

## Mock the breadth, deliver the depth

For multi-X features (multi-tenant, multi-section, multi-register, multi-anything): **render the breadth in UI early, even before functional impl supports all X-es.**

**Why:** Multi-X design conversations become 1000× more concrete when you look at real UI with N rendered items vs abstract spec. Mistakes surface immediately. Otherwise you find them late when expensive.

**How:**
- Start with migration/seed for breadth.
- Render UI shell with all items, using real names from source material — not „Test 2".
- Add functionality for depth of one X afterward.
- Document explicitly in STATUS.md: „X breadth is visual mock; functional depth only for primary X".
- Empty states for not-yet-implemented X must explain, not look broken.

---

## Cross-link

- [[pre-implement-gates]] Gate 2 = brainstorm persona value pre-build.
- [[workflow]] — extend the spec, don't take literally; default IS part of the implicit spec.
- [[iteration-killers]] — when persona test was skipped.
