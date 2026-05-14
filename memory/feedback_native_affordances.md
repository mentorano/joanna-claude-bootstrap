---
name: native-affordances-no-duplicate
description: Native HTML elements имат built-in affordances; не дублирай — провер преди да добавяш custom UI.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a4702782-1653-464a-9ac3-826de7e005b1
---

Преди да добавиш custom UI element до native input, провер дали браузърът вече има own affordance. Дублиращите се елементи изглеждат clutter-no и confusing.

**Why:** Caught конкретно в Digital Archives polish session — добавих own `×` clear button до `<input type="search">`, който вече има native `::-webkit-search-cancel-button`. Резултат: два × до един search input. Joanna забеляза, не аз.

**How to apply:**

- **`<input type="search">`** има native ×. Ако правиш own clear → скрий native-а:
  ```tsx
  className="... [&::-webkit-search-cancel-button]:appearance-none"
  ```
- **`<input type="date">`** има native calendar icon. Запазвай го по default; opt out само ако имаш конкретна нужда от branded picker.
- **`<select>`** има native dropdown arrow. Не add-вай own.
- **`<input type="number">`** има native spinners (browser-dependent).
- **`<input type="password">`** има native show/hide eye (Edge/Chrome).

**Decision flow когато добавяш custom UI:**
1. Провер браузърския default behavior на native element-а.
2. Ако native има equivalent affordance — или go-with-native, или скрий го с CSS pseudo-element.
3. Никога не оставяй двата едновременно.

**Related:** [[feedback-persona-defaults]] — Леля Гинче не hover-ва, така че native affordances (които винаги са visible) често са по-добри от custom hover-only варианти.
