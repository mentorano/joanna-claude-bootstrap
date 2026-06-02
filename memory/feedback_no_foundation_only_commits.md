---
name: feedback-no-foundation-only-commits
description: Commits със само backend + hooks (без user-visible feature) са anti-pattern. User се чуди „къде е?" и трябва да задава demand-questions. Винаги включвай AT LEAST един vertical slice на user-visible UI per commit.
metadata:
  type: feedback
---

При multi-layer features (backend + frontend hooks + UX), commit-ите трябва да преминават през ВСИЧКИ слоеве — backend + hooks + tiniest possible UX surface. „Само foundation, UX в следваща итерация" silently breaks user's mental model — потребителят cmd-shift-R-ва, не вижда промяна, пита „къде е?".

**Why:** Hit digital-archives Chunk C iter 1 (2026-05-22). Committed backend pref tables + endpoints + frontend hooks (5 files, 600+ insertions). Декларирах „foundation готов, UX в следваща итерация". Joanna refresh-на и попита „как се влиза в този едит режим, няма нищо". Имах да rewindam mental context + start UX writing. Cost: ~15 min context loss + user frustration.

**How to apply:**
- Litmus test за commit: „мога ли да обясня на user-а CONCRETE thing което може да направи NOW в браузъра?" Ако не → commit е incomplete.
- За large multi-layer features, ship vertical slice: backend foundation + ONE end-to-end working feature (е.g. bold toggle only) → commit. После втора feature (color) → commit. Не batchwise foundation+all-features+release.
- Acceptable exceptions: pure refactor (no user-facing change), test/infrastructure-only commits, dependency upgrades. Дocument-ирай в commit message: „infrastructure only — no visible change".
- Свързано с prototype-before-deep-build: vertical slice е MUCH по-малко strain on memory budget + по-бързо validation от user.
