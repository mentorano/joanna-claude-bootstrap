---
name: no-screen-dim
description: No spotlight overlays, darkened backdrops, wizard tours, or any screen-darkening for onboarding hints, feature intros, or other non-critical secondary UI. Aggressive overlay treatments signal error/blockage to users, not help. Anchor-targeted soft cues only.
metadata:
  type: feedback
---

# No screen-darkening for onboarding / secondary UI

**Rule:** Никакъв spotlight overlay, dim backdrop, wizard-style sequential tour, или каквото и да е друго, което покрива/затъмнява останалата част от екрана за onboarding hints, feature introductions, или non-modal contextual help UI.

**Why:** Persona-doctrine. Screen-dimming е modal-grade interruption pattern. За non-critical secondary UI (hints, intros, soft cues) ефектът е „something is broken" / „I broke something" — потребителят се чувства disempowered, прекъснат, intimidated. Aggressive overlay treatments сигнализират грешка / блокаж, не помощ. Effect compounds with non-IT personas — те по-лесно интерпретират unusual UI като „I did something wrong".

Related observation: backdrop-blur ефекти на modal Sheet overlays също триггеирват „something broke" — subtle 10% dim (`bg-black/10`) без blur е достатъчно за legitimate modal context.

**How to apply:**

- **Onboarding hints** → anchor-targeted soft cues: pulsing dot + on-click popover, inline callout chip, badge on specific element. Не блокира нищо извън себе си. Parallel discovery — all hints visible simultaneously, user picks which to read.
- **Feature introductions** → also anchor-targeted; if there are several, parallel (all visible), NOT sequential wizard tour.
- **Banner-style top-of-screen hints** → допустимо за really important global state (server down, data loss warning), не за onboarding.
- **Modal dialog overlays (ConfirmDialog, full-page Sheet)** → запазени за критични actions (mutation confirmation, full-page form) — там subtle dim/no-blur is OK, защото потребителят сам е инициирал и очаква full-attention context.

**Acceptable backdrop treatments** (за modals където dim е legitimate):
- Subtle 10% black (`bg-black/10`), no blur
- Никакъв `backdrop-blur-*` — blur reads as „something is broken"

**Decision rule:** before suggesting UI treatment that affects anything outside its own anchor (overlay, backdrop, full-screen fade) — ask: „is this user-initiated critical action, or secondary help?". Secondary help → stay ANCHORED, не invade other screen real estate.

Related: [[persona-doctrine]], [[cursor-pointer-rule]] — same family of „persona-friendly defaults".
