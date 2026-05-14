---
name: affordance-restraint-less-is-more
description: "Не добавяй nav links, helper buttons, или secondary affordances 'защото е лесно'. Persona test: ще използва ли Леля Гинче това, или е visual noise? Joanna 2026-05-14: 'тук препратка към история на промените не е нужна, излишен шум' — премахнах audit log link от detail page header."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

В A.Multi-register-Polish session добавих „История на промените →" link в EntryDetail header (timestamps row). Реално Joanna имаше го като gap в предишен handoff (GenericEntryDetail нямаше audit link при IV-та го имаше). Аз го добавих → Joanna каза „излишен шум, не е нужна".

Причина: Дневник link има own entry в Layout nav. Adding redundant link от entry detail е visual clutter, защото Леля Гинче рядко ще иска specifically „audit history на тoгава entry" от detail page. Тя ще иде до Дневник директно ако ѝ трябва.

## Правило: less is more за affordances

Преди да добавя нов interactive element (link, button, dropdown), питай:

1. **Use case clarity.** Реален persona use case? Или „theoretical" (нещо което developer-ът би искал)?
2. **Redundancy check.** Има ли alternative path до тoзи action (nav, breadcrumb, related surface)?
3. **Noise cost.** За user-ите които не ползват action-а, е ли visual clutter? Дали премahaне ще е по-чисто?
4. **Persona test.** Леля Гинче — пракматична municipal employee — би ли used това?

Default: **не добавяй** ако не minimum 2 of 4 насочват „да".

## Anti-pattern triggers

- „По-добре да добавя това, just in case."
- „Convenient да имат тук shortcut."
- „Pilot-ът има тoва, да го copy-paste и тук." (Extend-by-matching valid, but не если pilot-ът добави го безотчетно.)
- „Easy to add, no harm."

→ **Stop**. Не „no harm" — affordances costing user attention.

## Specific examples в проекта

- ✗ Audit log link в EntryDetail header — премахнат. Дневник в Layout nav е sufficient.
- ✓ „← Към записите в регистъра" — clear navigation back, persona use case.
- ✓ „Добави нов запис" в EntryDetail — primary user flow.
- ✓ Pencil icons на editable fields — discovery affordance, persona-friendly.
- ? „→" arrow в table row actions cell — debatable: row-click duplicates. Може да премahaем в бъдеще.

## How to detect преди да Joanna хване

Pre-implement question: „Какъв е minimum cost-per-second-of-user-time на add-ването на тoзи element? Persona-justified ли е?"

Pair-ва се с [[feedback-persona-defaults]] (persona priority), [[feedback-extend-match-existing]] (pilot inheritance), и Steve Krug's „Don't Make Me Think" (frontend/CLAUDE.md principle).
