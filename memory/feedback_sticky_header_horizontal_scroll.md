---
name: feedback-sticky-header-horizontal-scroll
description: Sticky table header в хоризонтално-скролваща таблица е coupled clutch от browser gotcha-та — border-collapse чупи sticky th, overflow-x контейнерът „хваща" вертикалния sticky, и трябва own bounded scroll zone. Плюс verification trap (мери th, не thead).
metadata:
  type: feedback
---

Искаш `<thead>` да се „залепя" горе докато редовете скролват. В таблица с хоризонтален скрол това е **сноп от gotcha-та**, не една CSS промяна.

**1. Tailwind preflight = `border-collapse: collapse`, който ЧУПИ sticky `<th>`.**
`position: sticky` на `<th>` не работи при `border-collapse: collapse` (browser limitation). Класовете може да са перфектни (`sticky top-0 z-…`, computed `top: 0px`) и пак да не лепне. Fix: **`border-separate border-spacing-0`** на `<table>` (spacing-0 пази визуала). Слагай фон на sticky клетките (`bg-…`), иначе съдържанието прозира.

**2. `overflow-x` ancestor-ът „хваща" вертикалния sticky → window-sticky е невъзможен.**
Контейнерът за хоризонтален скрол (`overflow-x: auto/scroll`) става scroll container и за двете оси (когато едната ос е non-visible, другата компютва до `auto`). Затова `sticky top-0` на th реферира ТОЗИ контейнер, не прозореца. Ако контейнерът е с auto височина (страницата скролва) → няма вертикален scroll range вътре → хедърът просто се отскролва със страницата. **„Истински" sticky към върха на екрана при page scroll НЕ става чисто с CSS, докато има overflow-x контейнер.**
Решение: дай на таблицата **собствена вертикална scroll зона** — `max-h-[Ndvh] overflow-y-auto` на контейнера + `sticky top-0` на th. Хедърът лепне в зоната на таблицата.

**3. Trade-off (surface го на user-а):** с вътрешна scroll зона browser scroll-chaining скролва ВЪТРЕШНИЯ елемент пръв, после страницата → „таблицата скролва първа, после страницата", не обратното. „Page-first, после sticky хедър на върха на екрана" иска JS floating header ИЛИ `overflow-x: clip` + transform-based horizontal scroll (по-сложно, риск за resize логиката). Кажи опциите, не gues-вай.

**4. Verification trap — мери елемента, който НОСИ свойството.** Проверяваш дали sticky работи: мери `<th>` (то има `position: sticky`), НЕ `<thead>`. Thead е `static` → неговият `getBoundingClientRect()` връща flow/скролната позиция → мислиш, че sticky пропадна, а всъщност th е залепено коректно. Общо правило: при verify на CSS поведение мери елемента с property-то, не статичния родител.

Каноничен случай: 2026-06-02 Digital Archives — `GenericEntriesList`/`ScrollableTable`. Минах през всичките 4 (вкл. фалшивия „sticky не работи" заради мерене на thead).
