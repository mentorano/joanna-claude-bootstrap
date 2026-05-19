---
name: theme-aware-visual-feedback
description: Visual feedback cues (gradients, fades, shadows, scroll indicators) must be tested against the ACTUAL theme palette, not abstract token names. „from-card to-transparent" is invisible on a card-bg surface.
metadata:
  type: feedback
---

**Rule:** Any visual cue that conveys state (scroll edge fade, overlay, shadow, highlight) must be verified against the actual project palette — not just by token names. Tokens like `from-card to-transparent` may evaluate to "same color → transparent" on a card-bg surface = invisible.

**Why:** Theme colors aren't all equally distinct. On a warm/parchment-toned UI, the `card` token might be very close to `background` — so a `from-card` gradient on a card-colored surface is visually flat. On a high-contrast dark theme, the same gradient might be too strong. Theme-token-only thinking misses this entirely.

Hit in this project: horizontal scroll fade gradient (`from-card to-transparent`) was invisible on warm-rust palette because the table sat on `bg-card` and the gradient blended into itself. User reported "I see no change" — fixed with `inset shadow rgba(0,0,0,0.22)` which is theme-independent.

**How to apply:**

When adding a visual indicator:

1. **Identify the surface beneath your indicator.** Is it `card`, `background`, `muted`, primary-colored? Match against that, not generic "neutral fade".
2. **Prefer theme-independent indicators for edge/state cues:**
   - Inset shadow with `rgba(0,0,0,0.X)` — works on light AND dark themes.
   - Border with `border-foreground/N` — adapts to theme.
   - Forced visible scrollbar via `::-webkit-scrollbar` — universal.
3. **For semantic colors** (warning amber, success green) — use Tailwind palette colors directly, not theme tokens. Themes shouldn't change "warning" semantics.
4. **Test visually after applying** — refresh the actual page, don't trust the token name.

**Specific recipes that work cross-theme:**

- **Edge scroll fade:** `inset Npx 0 Mpx -10px rgba(0,0,0,0.2)` — inset shadow cast inward. Works on any background.
- **Drop shadow for elevation:** `shadow-[0_2px_6px_0_rgba(0,0,0,0.1)]` — dark shadow regardless of theme bg.
- **Always-visible scrollbar:**
  ```css
  [&::-webkit-scrollbar]:h-2
  [&::-webkit-scrollbar-thumb]:bg-foreground/25
  [&::-webkit-scrollbar-track]:bg-muted/40
  ```
  Uses `foreground` token (contrast-aware) but in opacity-mode → consistent visibility.
- **Highlight selection:** `bg-primary/10` — primary token but soft enough for any palette.

**Anti-patterns:**

- `from-card to-transparent` on a card surface — invisible.
- `bg-amber-100` for highlight in a warm-yellow theme — same hue family, may blend.
- White overlays on white-ish surface — same problem.
- Trusting token names without visual verification.

**Smoke step:**

For any new visual cue, take a screenshot after first integration. If it's hard to spot, the recipe is wrong — switch approach (shadow/border/scrollbar) before declaring done.

**Pair with:** [[pre-implement-gates]] Gate 1 — Inventory the design tokens AND the visual baseline of the current theme before designing new affordances.
