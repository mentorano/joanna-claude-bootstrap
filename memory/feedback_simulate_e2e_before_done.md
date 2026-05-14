---
name: simulate-end-to-end-before-declaring-done
description: "Преди да declare-вам UX promяна 'ready', mental simulate end-to-end paths през state transitions, click targets, parent-child event flow, и conditional renders. Joanna's iteration loop ('тя хваща → аз поправям') е expensive. Pre-flight simulation е cost-effective."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

A.Multi-register-Polish session (2026-05-14) демонстрира high-cost iteration pattern: имплементирам нещо → Joanna хваща UX/consistency issue → аз поправям → повтаряме 2-3 пъти за edge cases. Each iteration ~5-10 минути, multiple iterations × multiple changes = огромен burn.

Конкретни incidents в same chunk:
- Row-click добавях → forgot че EditPopover toggle button-ите propagate-ват в React tree → Joanna хвана („Към общо свободно поле" navigates).
- „Към редакция" в blocking warning направих да setOpen(false) → затваря целия popover вместо да маха banner-а → Joanna хвана.
- Half-baked left-align на detail page → wide empty space надясно → Joanna: „каква е тази половинчата работа?".
- Conditional „Изчисти филтрите" button → push-ваше filter grid когато се появявa → Joanna хвана.

## Правило: pre-flight simulation

Преди да declare-вам UX change „ready":

**1. State transition simulation.** За всеки toggleable state (read↔edit, open↔closed, loading↔loaded), mental render:
- Какво се променя визуално?
- Какво се мести (push-ва flow)?
- Какво се появява/изчезва?
- Изпълнените задачи на „Не подскачай UI-я при state change" valid ли остават?

**2. Click target traversal.** За всеки interactive element в screen:
- Click → какво се случва?
- Има parent с onClick? React events propagate-ват ли?
- Очаквам нещо да stop propagation?

**3. Parent-child event flow.** Когато добавям event handler на parent (row click → navigate), всички children:
- Имат техни handlers? Сame event-type?
- Trябва ли stop propagation на boundary?
- Portalled content propagates чрез React tree (виж [[feedback-portal-event-containment]]).

**4. Conditional render audit.** За всеки `{condition && <X />}`:
- Какво stays in place когато condition flips?
- Какво се появява новo? Push-ва ли сurround?
- Може ли вместо conditional render — always-rendered с visibility/opacity?
- Container slot stable ли е (виж frontend/CLAUDE.md „Conditional render като anti-pattern" rule)?

**5. End-to-end happy path replay.** Симулирай: user opens page → clicks pencil → edits value → click save → sees result. Без interruptions? Без surprise jumps? Cmd-Enter shortcut работи? Esc cancel-ва без data loss?

**6. End-to-end edge cases:**
- Empty state: какво се показва ако field е празно?
- Read-only mode: какво се крие?
- Validation error: warning panel pushe ли content под?
- Network failure: error state graceful ли е?

## Кога важи

При **всяка** UX change. Дори „малка" promяна може да има неочаквани side effects (e.g. добавям row click → counter-intuitive за all cell editors).

## Кога е приемливо да пропусна

При pure backend changes без UX surface. При config-only changes (e.g. add schema knob, no consumer change yet).

## Cost-benefit

5 минути pre-flight simulation. Vs 30+ минути iteration loop ако Joanna хваща post-implement.

Pair-ва се с:
- [[feedback-no-layout-shift-proactive]] (mental checkpoint #1, #4)
- [[feedback-extend-match-existing]] (pre-implement inventory)
- [[feedback-driver-mode]] (chunk-end persona pass — е last-resort catch; pre-flight е first line)
