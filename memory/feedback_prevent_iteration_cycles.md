---
name: prevent-iteration-cycles
description: Three prevention disciplines that stop iteration cycles before they start — ground-truth user intent преди fix, run own smoke преди declare done, re-communicate scope expansion mid-chunk. Sibling на iteration_compounding (handles когато cycles вече се случват).
metadata:
  type: feedback
---

Iteration cycles (multiple round-trips на same logical change) са най-painful. [[iteration-compounding]] covers detecting & breaking them. Тая memory — preventing them upstream.

## (1) Ground-truth user mental model преди fix

User казва „не работи X" или „не виждам Y". Преди да започнеш да фиксваш, **confirm-нати на конкретно WHAT THEY MEAN.**

Триггери за re-confirm:
- Двусмислени Bulgarian terms („сложно поле" може = lookup_multi OR custom hybrid_property OR multi_value).
- „Не виждам X" — какво ТОЧНО гледа потребителя? (screen position, dropdown item, page).
- Ambiguous fix scope („оправи това" — кое exactly?).
- Words с overloaded meanings в проекта (Сложно поле, Падащо меню, Списък — всичките могат да са различни internal kinds).

Reflex: „преди да polish-вам, питам „кликнала ли си тук" / „имаш предвид опция в dropdown-а или…?"". 30 sec confirmation спестява 20 min wrong-fix.

**Каноничен случай (2026-05-20):** Joanna каза „не виждам как да добавя сложно поле". Аз assume-нах „Падащо меню" (lookup_multi) → започнах polish на disabled-state UI. Тя имаше предвид Q2 template flow (different feature entirely). 20+ min wasted, плюс late discovery.

## (2) Run own smoke ПРЕДИ declare „готово"

User не трябва да е твоя QA loop. Преди да кажеш „fix готов" — verify сам through entire user flow.

**Verification ladder, от cheap to thorough:**
1. **TS check + backend tests** (necessary, not sufficient — passes ≠ feature works).
2. **Mental simulate user flow** — open → edit → save → refresh → re-open → navigate. Walk through ВСЯ touchpoint touched от промяната.
3. **curl + jq на actual stored data** — verify backend storage matches expectation. Catches „returns 200 but doesn't persist" silent bugs.
4. **Run existing smoke** — `node smoke-*.mjs`. Frontend integration coverage.
5. **Write new targeted smoke** за specific bug class. Locks behavior + acts as regression test.

**Default for non-trivial fix:** at minimum (2) mental simulate + (3) curl actual data. „Code review + TS clean" alone is NOT enough.

**Каноничен случай:** searchable_scopes toggle save-ваше 200 OK but stored old value (has_change early return bug). Открит САМО когато Joanna retest-на. Curl GET след PATCH щеше да го хване веднага.

## (3) Re-communicate scope mid-chunk

Initial estimate може да се окаже грешен (commonly underestimated when discovering hidden complexity). Когато открие тhat the scope е по-голяма, **pause + re-communicate** before pressing forward.

Триггери за re-estimate:
- Discovery на hardcoded references дъбоко в codebase (editor labels, validators, normalizers).
- Brand-new layer изисква touch (storage migration, additional API endpoints).
- Initial estimate х2 exceeded.
- User-specific requirement emerges („Имот не може exception" → +30 min refactor).

Reflex: „при scope expansion говоря с user — A) продължавам с по-голям scope, B) ship МVP с known limitation". User decides.

**Каноничен случай:** hybrid_property declarative refactor — estimate „30 min" → discovery на hardcoded ПИ/Площ/Място editor labels → actual scope ~80 min. Трябваше да pause и re-confirm.

## Relation map

- This memory: prevention.
- [[iteration-compounding]]: detection + recovery when cycles already happen.
- [[smoke-test-downstream]]: smoke discipline — what to verify.
- [[prototype-before-deep-build]]: sketch simplest version първо, validate, expand.
- [[pre-implement-gates]]: structural pre-check ритуал.
- [[retro-rank-by-impact]]: при retro-то — rank findings by user-experienced pain, не technical interest.

All five sit на the same axis: respect user's time, don't make tхем your QA loop, ground-truth aggressively. Single most-important meta-discipline.
