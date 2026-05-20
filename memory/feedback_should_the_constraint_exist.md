---
name: should-the-constraint-exist
description: Преди да дизайнваш UX/код около ограничение, питай дали ОГРАНИЧЕНИЕТО въобще трябва да съществува. Workarounds на implementation-level ограничения често не са product requirements.
metadata:
  type: feedback
---

Когато добавиш constraint („max 1 X per Y", „не може да change-ваш kind с data") — спри и питай: **ИМА ЛИ ПРОДУКТОВО ОПРАВДАНИЕ за ограничението, или съм го enforce-нал заради текущ storage/code layout?**

**Why:** Constraint-ите се „утвърждават" чрез UI affordances (disabled buttons, hidden options, tooltip explanations). След като UX-ът се build-не около ограничението, премахването му изисква UI refactor. Joanna 2026-05-20 каза: „каква е логиката и от къде дойде това правило? няма такова изискване, не е и логично". Аз бях enforce-нал „max 1 lookup_multi per register" защото `disposition_options` table-та беше keyed per-register (storage convenience). Това не е продуктово ограничение — admin има легитимни кейсове за 2+ списъчни полета.

**How to apply:**
- Пред да напиша „raise FieldDefinitionsInvalid" / „if (other exists) hide option": **stop and ask** „има ли продуктова причина за това ограничение?".
- Ако причината е „storage не го support-ва както е сега" → flag-вай към user като trade-off: „A: добавяме constraint, или B: refactor storage за proper support". Не enforce-вай unilaterally.
- Constraint without product justification → често е скрита грешка в архитектурата. Лекуване вместо лек.
- Workarounds compound: всеки UI affordance build-нат около workaround prevents removal на самия workaround.

Свързано с [[cross-impact-reasoning]] (последици на decisions) и [[prototype-before-deep-build]] (валидиране на choice points преди deep-build).

Каноничен случай (2026-05-20 Digital Archives Q1): max-1-lookup_multi constraint → шипнат → Joanna pushback → lifted чрез proper per-field pool refactor. ~3 часа extra работа защото не питах в началото.
