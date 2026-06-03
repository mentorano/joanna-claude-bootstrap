---
name: feedback-responsive-input-gotchas
description: Три повтарящи се input gotcha-та на mobile — conditional padding за да не се реже placeholder-ът от reserved clear-button място; icon centering се чупи при asymmetric parent padding; input font < 16px зум-ва на iOS.
metadata:
  type: feedback
---

Дребни, но повтарящи се gotcha-та при responsive/compact input полета:

**1. Reserved clear-button padding реже placeholder-а.** Search input с `pr-9` запазва място за „×" копче, което се рендерира САМО когато има стойност. Празно поле → placeholder-ът се отрязва, а 36px вдясно стоят празни. Потребителят казва „има място, а не се събира". Fix: **conditional padding** — `${value ? "pr-9" : "pr-3"}`. Празно → placeholder ползва запазеното място; с текст → място за ×. (Не разчитай на `input.scrollWidth <= clientWidth` за „fits" — scrollWidth мери стойността, не placeholder-а; мери ширината на placeholder текста с temp span.)

**2. Icon centering vs asymmetric parent padding.** `absolute left-3 top-1/2 -translate-y-1/2` центрира спрямо **padding box-а на `relative` родителя**. Ако родителят има asymmetric padding (напр. `pb-2`), иконата сяда под центъра на input-а (50% е от по-високата кутия). Fix: обвий input-а в padding-free `relative`, а spacing-а изнеси на външен div. Същото важи за clear-× копчето.

**3. iOS зум при input font < 16px.** Input с `font-size < 16px` (text-xs/text-sm) trigger-ва iOS zoom-on-focus. Свиване на input шрифт на mobile (за да се събере дълъг placeholder) е deliberate trade-off — приемливо за desktop-first app, но знай че на реален iOS зум-ва на фокус. (Default `text-base` на mobile + `md:text-sm` е именно за това.)

Каноничен случай: 2026-06-02 Digital Archives mobile drawer — глобалната + секционната търсачка дрифтнаха (font/height/radius/bg/padding) и трябваше да се изравнят; placeholder „Търси във всички регистри…" се режеше заради `pr-9`; лупата на втората търсачка беше изместена надолу от `pb-2` на relative-а.
