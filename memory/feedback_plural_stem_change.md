---
name: plural-stem-change
description: БГ singular/plural често имат stem change (ё→е), не само suffix. „промяна" → „промени" (NOT „промяни"). Use full-word ternary вместо stem-suffix concat.
metadata:
  type: feedback
---

Канонична грешка в БГ pluralization:
```ts
// ❌ Wrong — stem-suffix concat, produces "промяни" (не съществува)
`${count} промян${count === 1 ? "а" : "и"}`
// 1 → „промяна" ✓
// 2 → „промяни" ✗ (правилно е „промени")

// ✓ Right — full-word ternary, language-aware
`${count} ${count === 1 ? "промяна" : "промени"}`
```

БГ има **ё→е sound change** между singular и plural на някои nouns:
- промЯна → промЕни
- млЯко → млЕка  
- сЯнка → сЕнки
- хлЯб → хлЕбове
- врЯме → времЕна

Stem-suffix concat предполага че stem-ът остава същ. За тия nouns не работи.

**Pluralization patterns в код:**

| Сценарий | Pattern |
|---|---|
| Прости nouns без stem change | stem-suffix OK: ``${n} мач${n===1?"":"а"}`` |
| Stem change (ё→е, или различни корени) | Full-word ternary: ``${n===1 ? "промяна" : "промени"}`` |
| Genitive/case-aware | Helper function: `pluralizeBG(n, "промяна", "промени", "промен")` |
| Multi-language | i18n библиотека (i18next-icu / Intl.PluralRules) |

**Default за БГ когато добавяш plural string:** full-word ternary. Stem-suffix трик-ове са fragile + не обхващат всички cases.

**Audit existing БГ strings когато се прави i18n review** — search for `${... === 1 ? "" : "и"}` patterns; всеки е potential stem-change bug.

Caught многократно — last 2026-05-20 Digital Archives (AdminRegisters save button + ConfirmDialog).

Linked: [[bg-strings-in-jsx]] (същия БГ-language nature) — БГ строежи изискват специален care в JS string templates.
