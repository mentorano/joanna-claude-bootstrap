---
name: archived-status-semantics
description: Soft-delete pattern — archived ≠ deleted. Releases identifiers (frees „taken" slots for new entries), preserves data for audit/restore, skipped from default UI, re-validates on unhide/unarchive. Universal soft-delete semantic — apply project-wide on first soft-deletable resource.
metadata:
  type: feedback
---

# Archived status semantics — soft-delete done right

**Rule:** When a resource supports soft-delete (status="hidden" / "archived"), it MUST satisfy 5 invariants:

1. **Archived ≠ deleted.** Record persists in DB; row never DELETE-d.
2. **Releases identifiers.** Unique keys / counters (e.g., entry_number, slug, code) are freed on archive — a new entry can reuse the same identifier without conflict.
3. **Preserves data for audit + restore.** All field values, foreign keys, relationships preserved as-is. Re-activate restores the full record.
4. **Skipped from default UI / API.** Default queries `WHERE status != 'archived'`; default listings hide archived. Explicit „include archived" flag/filter required to see them.
5. **Re-validates on unhide.** When unarchiving, validators run again — because state in „archived limbo" may have created conflicts (e.g., new entry reused the freed identifier; на restore → duplicate).

**Why:** Soft-delete is universally needed for audit/regulatory/recoverability reasons. But „archived" semantics often ambiguous — does identifier stay reserved? does it appear in default listings? what happens on unhide? Without canonical answers, ad-hoc patches accumulate inconsistencies.

**How to apply on new soft-deletable resource:**

1. **Database:** add `status enum('active', 'archived')` column. Don't add `deleted_at timestamp` — use status enum. Index it for filter queries.
2. **List queries:** default scope `WHERE status = 'active'`. Add optional `include_archived` / `status_filter` parameter.
3. **Unique constraints:** make them partial — `UNIQUE WHERE status = 'active'`. Postgres supports this; SQLite simulates с trigger. Released identifier safely reusable.
4. **Archive endpoint:** explicit POST/PATCH `/<resource>/<id>/archive` (or PATCH with `status: 'archived'`). Validate that resource is currently active. Optional `reason` field for audit. Emit `<resource>.archived` audit event.
5. **Unarchive endpoint:** explicit POST/PATCH. Re-run validators — duplicate keys, dangling FKs, validation rules — because state in „archived limbo" may have changed.
6. **Audit log:** include archived rows in audit display unless user explicitly filters. Audit log itself is „never delete".

**Anti-pattern A:** add `deleted_at timestamp` instead of status enum. Filter logic becomes `WHERE deleted_at IS NULL` — easy to forget on new queries; harder to filter by status in URL params.

**Anti-pattern B:** keep unique constraint absolute (not partial). Archive + recreate same identifier → constraint violation. User confused: „why can't I create entry N if the old N is hidden?"

**Anti-pattern C:** soft-delete chain — archive parent, but child resources not cascaded. Default queries hide parent but child shows up as „orphan" with stale parent_id reference.

**Anti-pattern D:** no re-validation on unhide. Archived record contains FK to a parent that was later deleted; restore → broken reference. Or unique key reused for new active record; restore → duplicate.

Related: [[audit-default]] — archived data MUST be reachable via audit log; что-то forensically meaningful never disappears. [[cross-impact-reasoning]] — touching status transition logic requires enumerating archive/unhide/restore paths in same chunk.
