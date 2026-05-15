---
name: ""
metadata: 
  node_type: memory
  originSessionId: 80f34a86-2229-4260-b8ee-98451bbf8175
---

За UI feature, **V1 baseline expectation** включва:

1. **Mixed card sizes / hierarchy** — HERO row (big metrics) + secondary cards + footer. Не „all-cards-same-size flat grid".
2. **Icons в headers** — Lucide icons next to title, оцветени с accent color (`text-[var(--chart-N)]`). Не plain text titles.
3. **Design tokens, не raw colors** — `bg-card`, `text-foreground`, `border-border`, `bg-muted`, `text-muted-foreground` (shadcn tokens), не `bg-white text-slate-900 border-slate-200`. Дори когато compiled CSS изглежда same.
4. **Chart color tokens проверени + override-нати ако default-ите са grayscale** — shadcn install default-ите са монохромни (`oklch(0.87 0 0)` → `oklch(0.269 0 0)`). За dashboards с >1 chart, override с multi-color palette (e.g. coral/teal/navy/yellow/orange) **преди да build-наш първия chart**. „После ще го override-нем" не работи — chart изглежда unfinished.
5. **Trend indicators / badges / mixed typography** — за analytics: trend chips (↑+X% / ↓-X%) с emerald/rose color coding, badge components за status tags, tabular-nums за numbers.
6. **Visual separation между сections** — `<h2>` zone headers, divider lines, subtle background contrast (`bg-muted/40`).

**Anti-pattern (caught 2026-05-15 dashboard chunk):** ship-нах functional-but-flat V1 — Card primitive used minimally, plain headers, grayscale charts, single card size. Joanna's feedback predictable: „грозно/постно, като изсипани клетки." Cost: 1 full iteration loop за visual redo.

**Why baseline shifts V1 → not V2:** Visual polish-ът е expected от persona. Joanna не е „MVP first, polish later" — UI features тя evaluate-ва на first show. Не V2-related concern.

**How to apply:** Преди да започна V1 imp на UI feature, mental checklist:
- Какви primitives имам install-нати (shadcn `src/components/ui/`)?
- Какви design tokens са configured (chart-1..5, primary, muted...)?
- Default-ите needing override? (chart palette typically does)
- Какви icons се ползват consistently? (Lucide)
- Размери на cards — кои са hero, кои са secondary?

Pair-ва се с [[extend-match-existing]] — V1 baseline е part of „inventory existing foundation first".

Caught: dashboard chunk V1 без visual hierarchy → 1 full redesign iteration. След визуален redo (mixed sizes + icons + chart palette + tokens) — Joanna одобри.
