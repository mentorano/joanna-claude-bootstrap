---
name: persona-value-pre-build
description: "За analytics / dashboards / reporting features — преди да build-нам cards, brainstorm-вам какво иска да види персонажът (boss, operator, decision-maker). Този list драйв-ва backend queries, не наоборот. Schema-down мышление за behavioral features е anti-pattern."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 80f34a86-2229-4260-b8ee-98451bbf8175
---

За analytics, dashboards, reporting и подобни **behavioral features**: преди да започна implementation, list:

- „Какво иска да види шефът/decision-maker?" — какви статегически insights? Какво е политически значимо?
- „Какво иска да види оператора (Леля Гинче / equivalent)?" — какво помага в дневен workflow?
- „Какво е невъзможно на хартия / в existing tooling?" — там е real value-add.

**Този list драйв-ва backend queries**, не обратното (schema → cards).

**Anti-pattern (caught 2026-05-15 dashboard):** аз построих cards на базата на „какво данни schema-та позволява да agregirsm" → result беше generic („Top buyers", „По години") + missing boss-friendly metrics. Joanna трябваше да push-не: „помисли на база какво виждаш в тези регистри, каква би била полезна информация за Леля Гинче и най-вече за нейните шпефове, от какво биха се вълнували те?" Cost: 1 full iteration redesigning cards с right framing.

**How to apply:**
1. Спирай преди implement. List minimum 5-8 candidate insights per persona (operator + decision-maker).
2. Score всеки candidate: „colective demand?", „невъзможно на хартия?", „data наличен?" → pick 3-5 strongest.
3. Validate с owner (питай) ако list-ът има >3 plausible variants.
4. Then build.

За data-rich domains (transactions, deadlines, distributions): обичайни боссрелевантни axes са:
- Aggregate value (total turnover)
- Concentration (top N) — concentration signal може да е anti-corruption-adjacent
- Distribution (по price brackets, по категории, по време) — pattern visibility
- Trend (vs previous period) — accelerating/slowing
- Comparison (market vs contract) — discount signals
- Compliance (% missing data, % overdue) — data quality

Pair-ва се с [[mock-breadth]] — once value-list defined, mock the breadth (всички cards visible early); deliver depth incrementally.

Pair-ва се с [[extend-match-existing]] — persona value comes FROM thinking, foundation inventory comes FROM existing. И двете предхождат implementation.
