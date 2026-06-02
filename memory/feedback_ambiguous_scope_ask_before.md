---
name: feedback-ambiguous-scope-ask-before
description: При user request с „per X" formulation където X има hierarchical multiple interpretations (per-user-global vs per-user-per-column), ASK преди да commit-неш дизайна. Refactor-ът след fact е expensive.
metadata:
  type: feedback
---

User requests с „пер X" wording често имат implicit hierarchical interpretations:
- „пер потребител" → global per user OR per (user, sub-resource)?
- „пер документ" → at doc level OR at section level within doc?
- „навсякъде" → all instances OR all-of-current-context?

Picking wrong interpretation requires refactor на schema, hooks, UI controls. Cost compounds защото имаш cascade of dependent decisions.

**Why:** Hit digital-archives Chunk C (2026-05-22). Joanna's spec: „да променя големината на шрифта пер потребител". Аз picked: global per user (single value applies to whole table). Implementation: useTableSettings.font_size_pct + table-level toolbar control. Joanna's correction (after I shipped): „трябва да е пер колона, не общо". Refactor: backend migration adding font_size_pct to user_column_styles + schema + service + frontend type + popover UI + cell-level apply. ~30 min wasted.

**How to apply:**
- При „per X" requests където X може да е different levels: explicitly clarify before designing. „Per-user means: same value for the whole table for that user? Or per-(user, column)?".
- Use concrete examples в clarification: „Леля Гинче чете font size 12 за buyer column, font size 14 за amount — да го разрешим?". Forces user-а да дисamiguate.
- Сomon scope ambiguities:
  - per-user: global vs per-context (per-register, per-section, per-column)
  - per-resource: global vs per-instance
  - per-page: global vs per-route
- Default to ASKING if uncertain. Cost на 1 message чакане << cost на schema refactor.
- Related: AskUserQuestion tool е legitimately useful here — small clarification question с 2-3 concrete options.
