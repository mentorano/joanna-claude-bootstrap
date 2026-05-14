---
name: no-half-baked-visual-solutions
description: "Не предлагай 'компромисни' визуални решения, които оставят страницата half-baked (left-aligned content без mx-auto, фиксирани min-h-овете които оставят празно пространство, и т.н.). Ако трябва да жертваме нещо за consistency, направи го целенасочено — не на средата на пътя. Joanna 2026-05-14: 'каква е тази половинчата работа?'"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

В A.Multi-register-Polish session направих няколко half-baked визуални промени, които Joanna хвана:

1. **Detail page width fix attempt #1** — премахнах `mx-auto` от `max-w-4xl` wrapper-а с цел „page edges align с list page", но content беше left-aligned в wide page → wide empty space надясно изглеждаше „половинчато".

2. **Reserved heights в InlineEditPanel** — добавих per-kind `min-h-[6rem..20rem]` за preventing layout shift. Резултат: visible празно пространство при филлед-кратки полета. Joanna: „ужасно грозно е".

3. **Hidden horizontal scroll за disposition checkboxes** — Сложих h-8 + overflow-x-auto за height match с date pickers. Резултат: checkbox items „излизаха извън panel-а" вместо да wrap-ват. Joanna хвана.

## Pattern

Когато trade-off-ите между consistency vs cleanliness vs work effort са непълни, не имплементирай „компромис, който показва швайцарски сирене". Опциите:

1. **Направи реален trade-off (визуално чист, with conscious sacrifice).** E.g. „content cards full width матching list" — accept wide inputs but consistent edges.
2. **Запази текущото state.** Стои както е, не променяй до по-добро решение.
3. **Питай преди да решиш едноличин.** Pair-ва се с [[feedback-prototype-ux-variants]].

## Anti-pattern triggers

Когато реагирам с някое от:
- „Добавя min-h-[Xrem] да reserve space" → щерпам място; check ако whitespace ще е visible problem.
- „Премахна mx-auto, ще align-вам ляво" → визуално разделено на половини без причина.
- „Add overflow-x-auto за стои h-8" → скривам content, който не fit-ва.
- „Constraint width на тoсо element за match neighbour" → дали другият също трябва да се мени за clean solution?
- „Бързо fix-вам само частично проблема, ще видим за остаталоТo" → don't.

→ **Stop**. Помисли дали изборът ще изглежда полу-баков. Ако да — питай Joanna ИЛИ направи цялостно решение.

## Specific examples в проекта

- Detail page width: или full-width (1600px, sections takes all) ИЛИ centered max-w (mx-auto + max-w-4xl). НЕ left-aligned без mx-auto.
- Reserved heights: само ако whitespace е acceptable (е.g. composite editors с consistent height). Иначе accept push-надолу на siblings.
- Filter widgets с many items: wrap (height grows), не overflow-х (content hidden).

Pair-ва се с [[feedback-extend-match-existing]] (extension решения често виновни) и [[feedback-prototype-ux-variants]] (multi-option choice points).
