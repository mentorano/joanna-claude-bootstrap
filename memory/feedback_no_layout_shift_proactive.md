---
name: proactively-prevent-layout-shift-not-reactively
description: "Преди всеки UI implementation (нов компонент, нова state transition, ново показване/скриване), задължително проверявам: ще ли подскочи нещо? Правилото 'Не подскачай UI-я' от frontend/CLAUDE.md е активен checkpoint, не post-hoc fix-up. Не може 4 пъти подред Joanna да ме хваща в layout shift — правилото е trigger при всеки render path."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

Имам правилото „Не подскачай UI-я при state change" в `frontend/CLAUDE.md`. Не го прилагам proactively — изграждам нещо, Joanna ме хваща в shift, фиксвам, повтаря се. Това е failure на reflexes, не на знание.

**Задължителен mental checkpoint при всеки UI implementation:**

Преди да declare-ам нещо ready (preview/commit), за всеки state transition в код-а питам:
1. **Read ↔ edit mode** — height разлика? Width разлика? Position shift?
2. **Show/hide на conditional element** (warning, banner, tooltip, badge) — push-ва ли flow? Push-ва ли siblings? Push-ва ли content под него?
3. **Loading → loaded** — skeleton има ли shape-match с loaded state?
4. **Empty → filled** — recipient elements имат ли reserved size?
5. **Toggle on/off** — option-related state mutation не премества neighbour-и?
6. **Append (list growth)** — нови items push-ват ли съседни блокове?

За **всеки** „да" — една от standard techniques:
- `min-h-[Xrem]` reserved space за elements които сменят размер
- Floating/absolute-positioned overlays (portal или absolute child) за toast/warning/dropdown
- `position: absolute` с `top: 100%` за conditional UI под anchor
- Equal-height между alternative renders (read button height = edit input height)
- Stable footer slot за counters/status (не inline-on-active)
- Sticky positioning за primary identifier columns
- `table-layout: fixed` + explicit column widths за tables

**Не deploy-вай без mental check-a passnal.** Дори за „малка" promяna (added warning, added badge, added toggle). Joanna's persona — Леля Гинче — е sensitive към movement; всяко shift отнема trust.

**Why this is failure mode не gap in knowledge:** frontend/CLAUDE.md изброява всичките техники. Когато реално implement-вам, аз не отварям файла да направя checklist — implement-вам по pattern, който се хранил от мускулна памет на default React patterns (in-flow conditional render). Need to make „шок check" reflex part of every implementation pass, не лекция.

**How to apply:**
- При implementing нов компонент: като завърша JSX, преди да commit-вам, бързо mental run през 6-те check-а.
- При adding conditional render: ПИТАЙ — „това ще се появи/изчезне в response на state. Какво се отместя?". Ако answer-ът е „нищо защото е floating/absolute" → OK. Иначе → реconsider преди да продължа.
- При implementing pattern-и в нов context (нов page/feature): провер дали съществуващите surfaces в проекта вече решават подобен problem; copy-paste техниката, не re-invent с default React patterns.
- Pair-ва се с [[feedback-extend-match-existing]] — extension работата започва от matching съществуващия pattern, не от default React pattern.
