---
name: feedback-schema-driven-not-hardcoded
description: Behavior that operates on schema/config-defined data must DERIVE from the schema (field kind/renderer/definitions), never hardcode the canonical/pilot instance's keys. Hardcoded keys break instantly for admin-added / second-tenant / renamed fields — and the pilot tests never catch it.
metadata:
  type: feedback
---

**Rule:** Any code path that reads, writes, validates, displays, imports, or exports schema-defined data must determine its behavior from the **schema** (field `kind` / `renderer` / `field_definitions`), not from a hardcoded set of canonical keys belonging to the first/pilot instance.

**Why:** In config-driven systems (per-type schemas, admin-extensible fields, multi-tenant), the canonical/pilot keys are just ONE instance of the config. Any hardcoded `{"buyers", "disposition_codes", "contract"}`-style set goes stale the moment an admin adds a field with a different key, renames a slug, or a second register/tenant uses a different schema. The path silently mis-handles the value — usually storing it in the wrong shape (string where a list was expected) so a downstream renderer shows blank, not an error.

**The killer property:** pilot/canonical tests PASS while the feature is broken for everyone else. The hardcoded keys match the pilot fixture, so the test corpus never exercises the failure. You only find it when a real admin-added field (different key) flows through.

**Triggers — audit these paths for hardcoding:**
- Validators / soft-validation rules
- Import / export field flattening + un-flattening (mapping, splitting, code-list handling)
- Display composers / cell renderers / audit-log value formatting
- Search SQL (which fields are searchable)
- Normalizers, lifted/denormalized child-table sync
- Anywhere you see a literal set/list of field keys

**How to apply:**
- Derive from the field's `kind` / `renderer`, not its key:
  ```python
  # ❌ breaks for admin-added lookup field with key "vid_razporezhdane"
  if token in {"disposition_codes"}: split_into_codes()
  # ✅ schema-driven — works for any lookup_multi field
  if field_kind(token) == "lookup_multi": split_into_codes()
  ```
- Mirror sibling surfaces from the schema too: if the list/detail view filters out `kind == "currency"` (currency rides with prices, not its own column), the import/export mapping must filter it the same way — read the rule from the schema, don't re-hardcode it per surface.
- Keep canonical pilot keys ONLY as a backward-compat fallback (so unit tests that call the function directly without schema still pass), with the schema-derived set unioned on top.

**Case studies (digital-archives):**
- `apply_mapping` hardcoded `disposition_codes`/`buyers` → an admin-created `lookup_multi` field (key `test`) was stored as a raw string instead of a code list → the list cell showed "—" (data present, wrong shape). Fix: `resolve_lookup_and_buyer_specs` reads `kind`/`renderer` from `field_definitions`.
- Same anti-pattern previously caught in validators (`_price_is_numeric` reading price keys from `field_definitions`) and in audit/search paths. **Recurring class** — when you fix one, grep for the others (see [[memory-birth-audit]]).

**Pair with:** [[memory-birth-audit]] — formalizing this rule means immediately grepping for the other hardcoded instances. [[cross-impact-reasoning]] — schema-driven is one axis of cross-impact. [[should-the-constraint-exist]] — sometimes the hardcoded value is a real product constraint, not just laziness; confirm before generalizing.
