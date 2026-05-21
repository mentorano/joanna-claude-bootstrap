---
name: cursor-pointer-rule
description: Clickable elements ALWAYS show pointer cursor. Tailwind v4 + shadcn default to `cursor-default`. Project must compensate with (a) global CSS override in index.css AND (b) `cursor-pointer` in Button cva variant. Don't ship without both.
metadata:
  type: feedback
---

# Cursor pointer „bible" rule

**Rule:** Every clickable interactive element shows pointer cursor — без изключения. Buttons, role=button, summary, anchor[href], label[for], any custom clickable.

**Why:** Tailwind v4 default is `cursor-default` (no pointer). shadcn v4 components inherit this — Button, DropdownMenuItem, SelectItem, etc. show arrow cursor by default. Result: clickables feel like static text. Personas (especially non-IT users) struggle with discoverability — arrow cursor reads as „nothing here" while pointer reads as „I can click this".

**How to apply (canonical 2-layer pattern):**

1. **Global CSS override in `index.css`** — catches everything including non-shadcn third-party clickables, anchor tags, summary tags, label[for]:

```css
button:not(:disabled),
[role="button"]:not([aria-disabled="true"]),
a[href],
label[for],
summary {
  cursor: pointer !important;
}

button:disabled,
[role="button"][aria-disabled="true"] {
  cursor: not-allowed !important;
}
```

`!important` because Tailwind preflight + inline cva classes otherwise win the cascade.

2. **`cursor-pointer` in Button cva variant** — for IDE discoverability and CSS-specificity belt-and-braces:

```ts
const buttonVariants = cva(
  "inline-flex shrink-0 cursor-pointer items-center justify-center ...",
);
```

Without layer 1 → custom clickables (div role=button, summary) miss the pointer. Without layer 2 → IDE search for „cursor-pointer" comes up empty, future devs don't know it's intentional.

**Anti-pattern:** rely only on layer 2 (cva variant). Misses anchor tags, role=button divs, summary, label[for]. Anti-pattern #2: rely only on layer 1. Future overwrite of cva variant during shadcn upgrade loses semantic intent.

**Audit on shadcn upgrade:** when `npx shadcn add --overwrite` updates Button/DropdownMenu/Select primitives, ALWAYS grep them for `cursor-default` and re-apply `cursor-pointer` overrides. shadcn maintainers may flip defaults.

Related: [[no-screen-dim]] — same family of „persona-friendly UI defaults".
