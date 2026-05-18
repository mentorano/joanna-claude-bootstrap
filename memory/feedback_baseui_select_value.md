---
name: baseui-select-value-children-as-function
description: Base UI Select.Value falls back to raw value (not label) when SelectContent items not yet mounted — use children-as-function to map value to label
metadata:
  type: feedback
---

Base UI's `Select.Value` (used via `<SelectValue />` in shadcn Select) needs a children-as-function pattern to display the label of the currently-selected option. Default behavior: it shows the matched `<SelectItem>`'s text content — but only if items are mounted. Since `<SelectContent>` is rendered in a Portal and lazy-mounts, on initial render the trigger shows the raw value (e.g. `"all"`) instead of the label (e.g. `"All fields"`).

**Why:** Base UI optimizes for lazy portal rendering — items only mount when the dropdown opens. Without explicit value→label mapping, `Select.Value` has no rendered Item to read text from.

**How to apply:** Always pass `children` as a function to `<SelectValue>` when the underlying value is a code/key (not a display string):

```tsx
<SelectValue>
  {(value) => OPTIONS.find((o) => o.value === value)?.label ?? ""}
</SelectValue>
```

Visible only via browser smoke — TypeScript checks clean, manual unit tests would miss it. See [[workflow]] chunk-end persona pass — the raw-value flash on first load is the kind of bug that requires real-browser smoke to catch.

Related: same pattern likely needed for any other Base UI primitive that resolves child content from a `value` prop (Combobox?). Verify when migrating those.
