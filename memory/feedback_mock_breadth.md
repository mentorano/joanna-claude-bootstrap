---
name: feedback-mock-breadth
description: "Когато проектираш multi-X feature, mock-вай breadth-а визуално отрано (всички X-и в UI) докато delivery-ваш depth-а на един X. По-добри design разговори, по-малко изненади късно."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e49628df-d421-4151-964a-172e1fb6f3e0
---

При multi-X функционалности (multi-register, multi-tenant, multi-section в форма, и т.н.) — **render-вай breadth-а в UI отрано, дори преди функционалната имплементация да поддържа всички X-и**.

**Why:** Joanna 2026-05-13 каза да добавя 6 mocked register types в UI-я преди да имаме schema-aware форми за тях. Това веднага показа неща, които без визуалното проявление не биха излезли: терминологията на label-а (Регистър vs Тефтер), как заглавието на детайл-страницата трябва да носи името на регистъра, че /entries без instance е концептуално грешен, и т.н.

Дискусиите за multi-X дизайн стават хиляда пъти по-конкретни когато гледаш реален UI с 7 разни регистъра (Секция I, II, III, IV, V, VI, IX) вместо абстрактна спецификация. Грешките се виждат веднага. Иначе ги откриваш в Phase B когато е скъпо.

**How to apply:**
- Когато планираш multi-X chunk: започни с миграцията/seed-а за breadth-а (RegisterTypes, второ tenant, втора section конфигурация). Render UI shell. После добави функционалността за depth-а на един X.
- Не се извинявай в UI че X-овете са „mock". Те трябва да изглеждат истински (имена от истински source — `_workspace/ledger-samples/many 2/`, не „Test Register 2"). Иначе не получаваш истинска feedback.
- Когато спираш на depth — отбележи го **expliticно в STATUS.md**: „X breadth е visual mock; functional depth е само за primary X". За да не се обърка следващият (включително бъдещия ти Claude).
- Когато потребител (Леля Гинче) пробва second X и срещне „празно" — empty state-ът трябва да обяснява, не да изглежда счупен. „Все още няма записи в този регистър" е OK; UI грешка не е.

Конкретно в проекта: миграцията `20260513_1700_seed_more_registers.py` mock-ва 6 нови RegisterType + active_digital RegisterInstance. Имената и legal_basis са истински, от `_workspace/product-notes.md` section 7. Така ги виждаме всички 7 на Home, тестваме per-instance scoping, и научаваме по пътя че /entries без instance е грешка преди да е твърде късно.
