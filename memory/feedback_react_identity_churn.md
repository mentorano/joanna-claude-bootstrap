---
name: react-identity-churn-on-mutable-keys
description: React `key={X}` на mutable value прави unmount/remount на всеки render когато X промени. Causes focus loss в inputs, lost popover state, draft wipes. Use stable client-side ID separate от storage key.
metadata:
  type: feedback
---

React identity (`key=` prop в list) трябва да е **стабилно** между render-ите за same logical row. Ако keys-ът се update-ва (примерно auto-slug-ва се от label при typing), React третира row-а като нов entity → unmount стария, mount нов → state в children (input value, popover open, focus position) се ИЗГУБВА.

**Симптоми:**
- Inputs губят focus след всеки typed character.
- Popover-ите се затварят неочаквано.
- Draft state в child components изчезва.
- „Изглежда като че всеки keystroke прави state reset."

**Канонична грешка:**
```tsx
// ❌ field.key се auto-slug-ва от label → промяна на всеки keystroke
<tr key={field.key}>
  <td><Input value={field.label} onChange={(e) => updateLabelAndKey(index, e.target.value)} /></td>
</tr>
```

**Fix patterns:**
1. **Stable client-side ID** at create time (UUID, timestamp+index, или incrementing counter). Storage key може да се изчислява лениво при save.
2. **Index as key** ако list не reorder-ва. Простата опция за static lists.
3. **Separate identity property** на entity-то: `_uid` (frontend-only, stripped at save).

**За dup/template flows:** placeholder key (e.g. `__new_<ts>_<n>`) запазва се стабилен през цяла edit session; финалният slug-key се изчислява само в `saveAll`. Не auto-rename intermediate state.

**Mental simulate checkpoint:** „Ако state-ът на тоя row се update-ва, какво се случва с React key? Same? Different?". Different → state loss bug.

Linked to React 18+ Strict Mode, useEffect dep stability, useMemo ref stability — всичките са related identity-stability concerns.

Caught 2026-05-19 Digital Archives AdminRegisters: live-typing label на нов column auto-renamed `field.key` чрез slugify; input губеше focus на всеки символ.
