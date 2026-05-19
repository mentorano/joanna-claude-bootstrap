---
name: cache-invalidation-cascade
description: When data is denormalized or embedded in another resource's response, mutations must invalidate ALL affected queryKeys, not just the primary one. Hidden cascade is a common source of stale UI bugs.
metadata:
  type: feedback
---

**Rule:** When a mutation changes resource X, invalidate every queryKey that returns X-derived data — including embedded copies in other resources' responses, lifted/denormalized tables, computed summaries, and search indexes.

**Why:** APIs often embed denormalized data for read performance (e.g., `RegisterInstanceWithType` includes embedded `register_type.field_definitions`). A mutation on the primary resource (`PATCH /register-types/{id}/field-definitions`) invalidates `["register-types"]` but leaves `["register-instances"]` stale — frontend renderers reading from the embedded copy show old schema. User sees mismatch: admin changed kind from text to date, but EntryField still renders text input.

The bug manifests as "X is updated but Y still shows old data" — confusing, requires reload, breaks trust. Avoidable with a discipline of cache cascade audit.

**How to apply:**

When writing a mutation hook:

1. **Identify what data the mutation changes** — the canonical resource (e.g., `register_type.field_definitions`).
2. **Enumerate all queryKeys that return data derived from it:**
   - Direct queries (`["register-types"]`)
   - Wrapping queries with embedded copies (`["register-instances"]` with `register_type.X` embedded)
   - Computed aggregates (counters, summaries)
   - Cross-resource joins (audit log with target enrichment)
   - Search indexes that include the field
3. **Invalidate all of them in `onSuccess`:**
   ```ts
   onSuccess: () => {
     qc.invalidateQueries({ queryKey: ["register-types"] });
     qc.invalidateQueries({ queryKey: ["register-instances"] });  // embeds register_type
     qc.invalidateQueries({ queryKey: ["audit-events"] });        // new event
     qc.invalidateQueries({ queryKey: ["search"] });              // indexed labels
   }
   ```

**The trap with embedded data:**

When a list endpoint enriches with related data (for performance), the consumers don't know it's denormalized. They consume `RegisterInstance.register_type.field_definitions` like any other property. When the primary resource changes, the consumers don't refetch unless the WRAPPING query is invalidated too.

**Pre-implement audit checklist for mutations:**

Before declaring a mutation hook done, answer:
1. What queryKey does this mutation primarily affect?
2. Does any other listing/wrapper endpoint embed this data? (grep server responses for the field)
3. Are there cross-resource enrichments (audit log, search) that include this data?
4. Are there computed/aggregated views (counters, last-activity, dashboards)?
5. Add invalidation for each → ship.

**Cost of not doing this:**

User-reported "X is updated but Y still shows old"  → "kind changed but date picker doesn't appear" — minutes of confused testing per occurrence. The fix is one line per missed key, but discovery cost was already paid by the user.

**Sub-rule — partial-key invalidation:**

React Query supports partial-key matching: invalidating `["register-types"]` matches `["register-types", { includeArchived: true }]` too. Useful for parametric queries. But it does NOT cascade to wrapping queries with different prefixes. Always enumerate.

**Pair with:** [[cross-impact-reasoning]] — cache cascade is one specific form of cross-impact. [[pre-implement-gates]] Gate 3 — mental simulation of "what queries depend on this data".
