---
name: feedback-min-size-overflow-blowout
description: Flex/grid дете има `min-width/height: auto` по подразбиране → не се свива под content-а. Дете с overflow-scroll (или дълъг unbreakable текст) разпъва родителя вместо да скролва. Fix — `min-w-0` / `min-h-0` на track-а/детето.
metadata:
  type: feedback
---

Flex items и grid tracks имат **`min-width: auto`** (и `min-height: auto`) по подразбиране — отказват да се свият под `min-content` size на съдържанието си.

**Симптом:** `1fr` grid track (или flex дете), което съдържа елемент с голям `min-width` (широка таблица в `overflow-x-auto`, дълъг unbreakable token, и т.н.) **разпъва целия grid/flex контейнер** до тоя min-width — вместо `overflow`-ът на детето да скролва. Резултат: page-level хоризонтален overflow, който „не би трябвало" да го има.

**Fix:** `min-w-0` на grid track-а / flex детето (и `min-h-0` за вертикалния аналог). Това позволява детето да се свие и неговият `overflow` да се engage-не.

Каноничен случай: 2026-06-02 Digital Archives AdminRegisters — `md:grid-cols-[260px_1fr]`, `1fr` панелът държеше таблица `min-w-[900px]` в `overflow-x-auto`. На 768px целият grid се разпъна до 1265px вместо таблицата да скролва. `min-w-0` на панела (root на `RegisterPanel`) оправи.

Свързано: винаги, когато слагаш `overflow-*-auto` на дете в flex/grid и очакваш то да скролва — провери дали track-ът/детето има `min-w-0`/`min-h-0`. Без него overflow-ът е „мъртъв" и parent-ът прелива.
