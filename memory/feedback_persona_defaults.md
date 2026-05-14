---
name: persona-defaults-when-in-doubt-pick-the-more-visible-option
description: "When choosing a default among UX alternatives in this project, pick the option that's most visible / least-effort for Леля Гинче (the municipal employee persona). Don't make her hover, read keyboard hints, click-to-reveal, or learn shortcuts to do basic things."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8b8668c0-9f5f-4a3b-a905-4432d4d75040
---

When facing a UX micro-decision (default value, affordance visibility, interaction trigger), the persona's framing is **always** the tiebreaker. Concretely, in this project the consistent preference has been:

| Decision | Persona-friendly default | Wrong default I keep reaching for |
|---|---|---|
| Save/cancel affordance | Visible ✓/✕ buttons next to input | Keyboard shortcut (Enter/Esc) hint only |
| Edit affordance on filled field | Always-visible pencil icon | Show pencil on hover only |
| Empty editable field | Render input directly, ready to type | „— клик за редакция" placeholder |
| Long-form label vs abbreviation | Full term in user-facing labels | Abbreviation („АОС", „ДО") |
| Composed cells in dense table | Pencil on hover (concession to density) | Same-as-detail always-visible |
| Toggle/preference default | Whatever requires the least learning | Whatever I think is "more powerful" |
| Mode switch (toggle) | Preserve user input, transfer between modes | Wipe content on switch |

**Why:** Joanna's persona is „Леля Гинче" — pragmatic municipal employee whose primary risk is **adoption friction**, not lack of features. She doesn't know Cmd-Enter. She doesn't read keyboard hints. She doesn't hover to see what's clickable. If a UX detail requires her to do any of those things to function, she'll feel the system is hostile and the rollout fails — regardless of how good the code is. Multiple times in 2026-05-13 polish session I reached for the keyboard-only / hover-only / minimal-affordance default; Joanna pushed back every time.

**How to apply:** Before defaulting any UX micro-decision, run the mental test: "What would Леля Гинче do if she just sees this for the first time?" Pick the option where she succeeds without thinking. If saving needs to be possible — show a button labeled „Запази". If a field is editable — show a pencil. If empty fields need filling — make them already an input. If a mode toggles — preserve her work. **Less obviously: don't ask me to choose the default when the persona already tells you which one.** This pairs with [[feedback-driver-mode]]'s "extend the spec" — the default IS part of the implicit spec.
