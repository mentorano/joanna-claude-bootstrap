---
name: prototype-ux-variants-before-implement
description: "При UX choice points (multiple defensible варианти на едно и също surface), направи working prototype-и на ВСИЧКИТЕ варианти преди да избирам. Описание в текст не стига — Joanna трябва да види реалното UI поведение, да цъкне, да усети, и тогава да избере."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

Когато достигам UX избор, в който >1 опция е defensible (e.g. как warning panel да не push-ва content под себе си — floating popover / reserved slot / toast+border), стандартното ми поведение трябва да е:

1. **Имплементирай прототипи на 2-3 варианта.** Не описание в markdown, а реален code. Може minimal/stubbed, но работещ — Joanna трябва да click-не, да въведе, да види.
2. **Направи ги switchable.** Dev toggle (`?warning_variant=A`), feature flag, или dev preview page показваща и трите варианта на една страница ред до ред. Joanna да може да сравни директно.
3. **Кажи й какво да тества.** „Опитай в Detail page: edit АОС поле, въведи дублиран № — виж как се държат трите варианта при появата на warning + при scroll."
4. **Тя избира; ТОГАВА залагам full implementation.** Не започвай с favourite-а ми — изчакай вердикта.

**Защо:** Joanna explicit feedback (2026-05-14, A.Multi-register-Polish chunk-ut): „при такива ситуации да ми имплементираш прототип на всички варианти, да избирам и тогава да имплементираш". Преди това бях ѝ дал 3 варианта като текст-описание; тя избра един „на сляпо" — но процесът беше под-оптимален защото не видя реалното UI поведение.

**Кога важи:**
- ✅ Multi-variant UX questions („как да покажем X", „кой layout за Y").
- ✅ Visual decisions с trade-offs, които се усещат само в реално UI (animation, layout shift, focus management, scroll behaviour).
- ✅ Pattern decisions, които ще se reuse-нat системно (warning surface, modal style, button affordance).

**Кога НЕ важи (продължавай по обичайния driver-mode подход):**
- ❌ Чисто tech decisions (e.g. кой validator pattern в backend) — те нямат visual character.
- ❌ Single-best-answer UX, където персоналните rules от [[feedback-persona-defaults]] вече посочват ясния избор.
- ❌ Trivial cosmetics (точно тоя padding vs другия) — не worth-овим я.

**How to deliver:**
- Дай й 2-3 опции (не повече — decision fatigue). Включи и моята препоръка с reasoning.
- Имплементация на прототипите е **временна** — единият (избраният) ще остане; останалите се изтриват. Бъди clean при cleanup.
- Запази branch/git tag за изоставените варианти ако те имат стойност за бъдещ reference.

**How to apply вместо да предложиш text-описание:** като забележиш че пишеш „Three варианти, с trade-offs:..." с булети — спри, имплементирай ги, после ѝ покажи. Pair-ва се с [[feedback-driver-mode]]: chunk-end persona pass може да индицира за такива choice points; тогава прототипирай вместо да обясняваш.
