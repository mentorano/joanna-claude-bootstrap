---
name: feedback-understand-pushback-before-reverse
description: При user pushback срещу твое решение, разбери WHY преди reverse. Иначе round-trip: build X → user „no" → build !X → user „yes but X was needed for Y" → build X again.
metadata:
  type: feedback
---

User feedback като „това не ми харесва", „премахни X" е симптом, не диагноза. Reverse immediately без understanding на underlying need = pendulum behavior. User vyzhda че се местим круг по круг без progress.

**Why:** Hit digital-archives Chunk C (2026-05-22). Pattern на spacer column иterations:
1. Built spacer col + table=w-full + actions sticky right (option B)
2. Joanna: „последната колона е огромна" → reversed → built table=sum-of-cols (option A)
3. Joanna: „виж дупката вдясно от стики колоната, нали беше стики" → realized she needs sticky → reverted → spacer back (option B with palette adjustments)

Round-trip cost: ~25 min на code + Joanna re-testing. Underlying need: „искам actions пинната на viewport AND чисто без визуален gap". Surfacing trade-off (sticky requires either auto-fill OR explicit gap) earlier би запазил cycles.

**How to apply:**
- При pushback: paraphrase user's complaint + own hypothesis за underlying need. „Виждам, че X те смущава. Подозирам че реалното желание е Y — правилно ли?". User confirms или corrects.
- За UX trade-offs със known options (A/B/C): explicitly enumerate options + side effects. User picks с full information.
- При oscillation pattern (2+ reverses): STOP coding, write to user „виждам че се местим напред-назад между A и B. Реалното желание изглежда Z. Опции са [...]; коя?".
- Trust user, but verify understanding. „User said X" доеса ясно what they said, not what they need.
- Свързано с iteration_killers (асking за console+network), surface-fundamental-tradeoffs.
