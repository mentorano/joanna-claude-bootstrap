---
name: ""
metadata: 
  node_type: memory
  originSessionId: 80f34a86-2229-4260-b8ee-98451bbf8175
---

Когато feature има multiple cards / components с similar interaction (e.g. period selectors, scope selectors, filter controls): **declare ONE pattern upfront за целия feature** преди да build-вам първата card.

**Anti-pattern (caught 2026-05-15 dashboard):** Picked Select dropdown за TopDeals period filter, Select for ProcessedByPeriod period selector, но Tabs за TrendCard granulation, plain buttons за viewMode toggle. Random per-card consistency. Joanna's feedback (после 2 итерации): „предпочитам подходът ни да е еднакъв във всички карти и да заложим на табулацията." Cost: 1 iteration switching Select → Tabs everywhere.

**How to apply:**
Преди да imp-нал първия component на feature, declare на писмено или в коментар:

```
// Feature: Dashboard
// Interaction patterns:
//  - Period selector (30д/12мес/...) → Tabs (always)
//  - Granulation (Day/Week/Month/Year) → Tabs
//  - Scope selector (всички/секция X) → Select (>4 options)
//  - Confirmation → ConfirmDialog
//  - Loading → Skeleton shape-matched
```

Validate с „one-of-each UI element" rule: едно period selector в проекта = един и същ control type навсякъде. Не pick-and-choose per-card.

Pair-ва се с [[extend-match-existing]] — patterns inventory е част от foundation reconnaissance.

Pair-ва се с „one of each UI element" (project principle #3) — generalized: едно pattern per interaction type.

**Test:** Когато добавиш нова card с similar control: задължително use declared pattern. Ако не паска — спри, питай (вероятно declared pattern е грешно за тоя use case → update declaration globally, не deviate locally).
