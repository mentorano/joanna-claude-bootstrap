---
name: cache-invalidation-audit
description: "Всяка нова TanStack Query queryKey изисква audit на existing mutations — кои affect данните → добави invalidateQueries в onSuccess. Без този checkpoint, нови queries silently stale след mutations. Common pitfall."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 80f34a86-2229-4260-b8ee-98451bbf8175
---

Когато добавя нов `useQuery({ queryKey: ["X"] })` — audit checklist:

1. Списък на mutations които affect-ват X data (which writes / deletes might change it?)
2. За всяка такава mutation, провери `onSuccess`: invalidate-ва ли `["X"]`?
3. Ако не → add `qc.invalidateQueries({ queryKey: ["X"] })`.

**Anti-pattern (caught 2026-05-15 dashboard):** добавих `useDashboard()` hook новия dashboard. Не updated `useEntries.ts` mutations (`useCreateEntry`, `useUpdateEntry`, `useHideEntry`, `useUnhideEntry`) да invalidate-ват `["dashboard"]`. Result: създадeн entry → dashboard не reflects до 60s (staleTime default). Joanna catch: „направих запис за 100 хил., не виждам да се е отразило на дашборда. ние навързали ли сме нещо изобщо или всичко е фейк?"

**Why predictable:** TanStack Query има `staleTime: 60_000` globally → данните остават „fresh" 60s, не refetch-ват автоматично на window focus / mount. Cache invalidation е explicit-only mechanism за reactivity. Лесно forgetting когато добавя нов query тип.

**How to apply:**
- При adding new query: edit existing mutation files в same PR. Не leave it „за after".
- При adding new mutation: audit existing queries, invalidate всичко potential affected.
- Project pattern: всички entry mutations invalidate `["register-entries"]`, `["audit-events"]`, `["dashboard"]`, `["register-instances"]` (latter за entry_count update).

Pair-ва се с [[simulate-e2e-before-done]] — pre-flight mental simulation на cycle „mutation → query reactivity" е част от done-check.

Pair-ва се с broader pattern: реактивност изисква explicit wiring (cache invalidation, websocket events, polling intervals). Default React Query поведение е stale-while-revalidate с дълъг stale window.
