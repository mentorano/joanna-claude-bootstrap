---
name: has-change-early-return-blindspot
description: Update endpoint-и с „if not has_change: return" early-return блейкват silently mutations на properties които не се detect-ват в diff calculator. Когато добавяш нов mutable field — добавя го в diff + has_change.
metadata:
  type: feedback
---

Common pattern в update services:
```python
# Compute diff
label_changes = [...]
compact_changes = [...]
# ... etc

has_change = bool(added or label_changes or compact_changes or ...)
if not has_change:
    return rt  # ← НИЩО не се персистира
rt.field_definitions = new_field_definitions
```

Когато добавиш **нов mutable property** в schema (admin може да го toggle-ва), MUSTS:
1. Add detection logic за тоя property в diff calculator.
2. Add detected changes в `has_change` boolean.
3. Add audit metadata entry (за tracking).
4. Optional: dedicated canonical action label.

**Иначе:** API returns 200 OK (success), backend silently keeps old value. Frontend гледа success → invalidates cache → refetches → същата стара стойност. „Не се сейва, но не дава грешка" — най-difficult-to-debug class бъг.

**Diagnostic checklist при „save returns 200 but doesn't persist":**
- Има ли early-return based on detected changes?
- Включен ли е тоя property в detection logic?
- Filter ли е нещо downstream-а (Pydantic schema, protected list, normalizer)?
- Audit log emits ли event за тая mutation?

**Pre-implement gate (Gate 3 mental simulate extension):** When adding mutable property X to update endpoint, grep service-а за `if not has_change` / `if not changed_fields` / early-returns. Audit ALL of them включват ли X.

Caught 2026-05-20 Digital Archives `searchable_scopes` toggle: backend returned 200 success but frontend show-ваше стара стойност after refresh. Cause: has_change list не включваше searchable_scopes.

Related: [[smoke-test-downstream]] (verify trough actual DB state, не само response code) + [[cross-impact-reasoning]] (всеки нов mutable property touches multiple layers).
