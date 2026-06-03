---
name: feedback-baseui-dialog-initial-focus
description: Base UI Dialog/Sheet авто-фокусира първия focusable при отваряне (напр. search input → drawer се отваря с input на фокус / клавиатура на mobile). `initialFocus={false}` го спира. Base UI НЕ авто-фокусира на touch → такива оплаквания са desktop-only.
metadata:
  type: feedback
---

Base UI `Dialog.Popup` (= shadcn `SheetContent`/`DialogContent`) **авто-фокусира първия focusable елемент** при отваряне. Ако това е search input → drawer-ът се отваря с input на фокус (на desktop изглежда агресивно; на mobile би изкарал клавиатурата веднага).

**Спиране:** `initialFocus={false}` на Popup-а (`SheetContent`) → фокусът отива на самия popup контейнер (tabIndex -1), не на първото дете. A11y остава ок (фокусът е вътре в диалога). `SheetContent` спред-ва `...props` към Popup-а, така че се подава директно от call site-а.

**Важно — Base UI НЕ авто-фокусира на TOUCH interaction** (само keyboard/mouse). Затова „input на фокус при отваряне" е типично **desktop-only** проблем. Не over-apply-вай fix-а на mobile drawer-и „за всеки случай" — там няма да се прояви (потвърдено: Joanna каза „на десктоп" специфично, защото на телефона не се случваше).

Каноничен случай: 2026-06-02 Digital Archives — desktop rail drawer („Регистри") авто-фокусираше „Търси секция…"; `initialFocus={false}` го спря.

Фамилия с другите Base UI gotcha-та: `feedback_baseui_render_prop`, `feedback_baseui_select_value`, `feedback_shadcn_grouplabel`.
