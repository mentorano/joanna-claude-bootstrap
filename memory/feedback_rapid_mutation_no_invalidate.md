---
name: feedback-rapid-mutation-no-invalidate
description: При rapid React Query mutations (drag-resize, slider, draft typing) НЕ invalidate-вай — refetch race-ва с in-progress local state и wipe-ва user input.
metadata:
  type: feedback
---

При mutations които fire-ват бързо в последователност (drag-resize, slider movements, type-as-you-go), стандартният `onSettled: invalidateQueries` създава race condition: refetch returns canonical server state ДОКАТО user-ът прави следваща промяна → useEffect-base seed от refetch overwrites local state → in-progress drag/slider държи bouncebackва.

**Why:** Hit digital-archives Chunk B column drag-resize. User drag-ва col A → mutation fires + invalidate → refetch in-flight. User starts drag на col B → columnSizing[B] live state update. Refetch returns {A: newWidth} (no B yet). setQueryData → useEffect[widthsQuery.data] → setColumnSizing({A: newWidth}) → B's drag state WIPED.

**How to apply:**
- За rapid mutations: drop `onSettled: invalidateQueries`. Use:
  - `onMutate` optimistic setQueryData
  - `onError` rollback
  - `onSuccess` defensive setQueryData с server data (covers clamping)
- За standard CRUD (form submit, button click): keep invalidate — refetch е безопасен.
- Litmus test: „може ли user-ът да направи 2-ра mutation while 1-вата е in-flight?" → ако да, drop invalidate.
- Optimistic update трябва да handle empty prev cache: `const base = prev ?? new Map()` вместо `if (prev) { ... }`. Иначе първа mutation skips optimistic, seeded только през refetch.
