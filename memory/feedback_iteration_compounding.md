---
name: iteration-compounding
description: Two failure modes are highest-pain в сесии — (1) refactor-on-refactor compounding without clean checkpoint, (2) declaring „fixed" преди да си verify-нал ВСЯ user-facing path. User pain compounds if both hit same session.
metadata:
  type: feedback
---

Two related session-level antipatterns that compound user pain. Recognize и stop early.

## (1) Refactor-on-refactor compounding

Когато 2-3 refactor-а се правят последователно в same area without clean checkpoints, mental coherence се губи — fix-овете на edge cases в refactor #3 могат да re-introduce bugs от refactor #1. User-ът усеща „мазало".

**Симптоми:**
- Joanna casually споменава „това е рефактор на рефактора на рефактора".
- Catches на cosmetics в row → step back, structure-та грешна.
- Multiple TODO-ове за „audit X места". Без clean checkpoint между refactor-те.
- Self-reverted edits (като feedback_should_the_constraint_exist scenario).

**Fix:**
- **Commit clean checkpoint между refactor-ите** — дори ако работата „still going". Stable rollback point.
- **Pause + state summary** след всеки refactor: „Status: X works, Y next." Mental re-load.
- При 3+ refactor-а в same area → step back, ask „is the foundation right or am I patching over a wrong abstraction?".
- Не започвай нов refactor preди да си mentally simulate-нал че предишният е coherent end-to-end.

## (2) „Fix" без user-path verification

Declaring „готово" преди да си verify-нал ВСИЧКИ user-facing paths touched by the change. User-ът retест-ва, открива че fix-а е partial, push-ва back. Round 2 fix → retest → still broken → round 3.

**Симптоми:**
- User казва „пак не работи" / „не сработи" → cycles.
- „Fix" на submit path, но read path не → видимо празно. Or vice versa.
- Backend test pass-ва but live verification reveals different shape/state.
- Multi-step bugs (Имот inline-add): write nested + read top-level → cycle.

**Fix:**
- **Walk through entire user flow** в mental simulate след всеки claimed fix. Цикъл: open → edit → save → reload → re-open. ВСЯ стъпка.
- **Curl + jq actual data** след backend changes, не само response codes. Storage-level verification.
- **Smoke through detail page** след инline-add fix, не само submit.
- **Mental simulate test за ВСЕКИ path**: read, write, refresh, navigate-away-back. Each user touchpoint.
- Само след тая walk-through declare „готово".

## Compounding effect

Two patterns заедно = worst session UX:
- Each refactor compounds incoherence.
- Each „fix" е partial и not fully verified.
- User retест-ва, retест-ва, retест-ва. 4-5 rounds for one logical change.

**Pre-flight checkpoint:** „Имам ли > 1 refactor в same area без checkpoint? Имам ли > 1 round на same bug fix?". Yes → pause, summarize, commit, step back.

## (3) Натрупани режими → лекът е ИЗВАЖДАНЕ, не още един режим

Специфичен случай на refactor-compounding в UX повърхности: всяка итерация добавя нов режим / toggle / клон („слепена vs отделни колони", „един избор vs два", разгъване, conditional редове). Всеки добавен режим **умножава състоянията**, които и ти, и потребителят трябва да държите наум. В един момент повърхността става „каша".

**Сигнали:**
- Потребителят казва „каша", „мазало", „побъркано", „какво е това сега?".
- Сам броиш 3+ режима/toggle-а на едно поле/контрола.
- Всяка нова итерация *добавя* опция, вместо да изясни.

**Реакция:**
- Когато потребителят нарече повърхността „каша" — това Е STOP сигналът. Не лепи още един режим/обяснение.
- Лекът почти винаги е **изваждане**: върни се до най-простия коректен дизайн (често по-малко код, отколкото си натрупал) и зачеркни спекулативните режими.
- Питай: „Коя от тези опции реално трябва СЕГА?" (YAGNI). Спекулативните клонове („ами ако файлът е в две колони") добавяй само при реална нужда, с реални данни пред очи — не на сляпо.

**Каноничен случай (digital-archives):** напасването на композитни колони в импорта мина през ~5 итерации (combined target → expander → отделни редове → два избора в ред) → потребителят: „тотална каша". Решено с **изтриване на ~100 реда** обратно до един ред/един избор. Спекулативният „две отделни колони" режим (без реален файл, който да го изисква, и концептуално грешен за multi-value полета) беше точно излишният товар.

## Retro implication

Тия meta-patterns ОБИЧАЙНО ще са най-painful от сесия за user-а, но НЕ най-обвидни от моя ъгъл (because they're process failures, not specific bug classes). Retro-ите трябва да water-mark UserPain explicitly: „Какво причини най-много retest cycles?". Виж [[retro-rank-by-impact]].

Caught 2026-05-20 Digital Archives Q1+Q2: 8+ iterations за Имот flow + searchable_scopes toggle, multiple back-to-back refactors без clean checkpoint.
