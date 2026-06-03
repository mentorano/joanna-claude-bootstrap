---
name: feedback-surface-fundamental-tradeoffs
description: При user requests с internally contradictory constraints (X AND Y AND Z, but geometrically/logically impossible together) — SURFACE the trade-off explicitly. Не опитвай serial workarounds, не „guess" коя страна да приоритизираш.
metadata:
  type: feedback
---

User-driven UX iterations често developat contradictory requirements които не можеш да satisfy едновременно. Пример: „chevron close to title AND chevron close to separator AND left-aligned title AND column wider than content" — геometрично невъзможно. Trying serial workarounds (justify-between → gap-0.5 → flex-1 → text-right) изгубва време + frustrates user.

**Why:** Hit 2026-05-22 digital-archives Chunk C font/chevron layout iteration. Cost: 6+ messages на iteration преди да surface-нем „не може и трите едновременно — кое искаш?". User reaction: „не можеш ли да го опрвиш? кажи." — едва тогава осъзнах I should have said earlier.

**How to apply:**
- При request 3+ опитa без подобрение → STOP. Hypothesize дали constraints са fundamentally incompatible. Geometric / CSS layout / sticky positioning особено податливи на това.
- Enumerate the trade-off explicitly: „имаш 3 опции, две вече ги отхвърли" + remaining option + cost. User picks.
- Don't be afraid to say „не мога" — често е по-добре от 5-та неуспешна итерация. „Не мога освен по този начин" е valid answer.
- При CSS layout trade-offs: визуализирай aproks с ASCII diagram или explicit „option A | option B | option C" с side effects.
- Сродно: prototype-before-deep-build намалява случаите където скрит trade-off изpъква late. Но някои trade-offs surface-ват само при real user feedback (не предвидими в plan).

**Sub-pattern — contested PLACEMENT → питай „трябва ли изобщо".** Когато потребителят итерира КЪДЕ да стои един контрол (не как изглежда) и го местиш 3+ пъти — реалният въпрос често е „трябва ли тоя контрол да съществува тук изобщо". Преместване на семантично неудобен елемент само мести неудобството. Каноничен случай 2026-06-02 Digital Archives: глобален „sort" контрол местен 5× (page-header → 1-ви регистър-heading → ред на „Търси" → обратно → **изтрит**). Беше неудобен НАВСЯКЪДЕ — глобален контрол, закачен за per-instance heading, изглежда че действа на тоя instance И пренарежда самите instances под себе си. Surface „или да го махнем" като explicit опция РАНО. Cross-ref [[should-the-constraint-exist]].
