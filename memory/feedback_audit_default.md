---
name: Default to persistence — anything DB-worthy should be persisted, not ephemeral
description: Joanna's standing stance that anything which can reasonably be persisted to the DB should be persisted. Audit-every-mutation is the strictest application; the broader rule shapes how business logic is implemented.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
When implementing business logic on this project, **default to persisting state**, decisions, and contextual metadata. Do not keep forensically meaningful state ephemeral. This is broader than audit — it is the value that shapes the whole system.

**Hierarchy of the rule:**

1. **Every business mutation creates an `audit_events` row** — field-level diff, actor, timestamp, target. Already a principle in root `CLAUDE.md` (#5).
2. **User decisions and overrides persist** — warning overrides, manual continuation marks, hide-reason text. Stored on `audit_events.event_metadata` JSON; optionally promoted to a typed column if read often.
3. **Contextual metadata persists** — what warnings were shown to the user, what fields were prefilled, what import batch a record came from. If it could matter forensically in 6 months, persist it.
4. **System mutations also audit** — migrations, backfills, scheduled jobs emit audit with `actor_user_id=NULL` and `event_metadata.source=system`.
5. **Failed mutations audit too** when they had explicit actor intent (e.g. failed PATCH after user attempt) — `status=failed`, `metadata.error=<reason>`. Distinguishes "user tried and was blocked" from "user never tried."

**When NOT to audit (anti-noise):**
- No-op PATCH (values identical to current) — already enforced in `register_service.py`, has a test.
- Read operations (GET) — request logs cover this; audit is for state change.
- Validation warning shown but user fixed value before save — ephemeral by design (user never committed to the suspicious value).

**Audit event shape (lock in this convention):**
- `target_type` + `target_id` — what this is about
- `action` — short verb namespace (`entry.created`, `entry.field_updated`, `entry.hidden`, `warning.overridden`, `import.row_accepted`)
- `actor_user_id` — null = system
- `event_metadata` JSON — action-specific:
  - Field updates: `{"changes": {"field_name": {"prev": ..., "next": ...}}}`
  - Overrides: `{"overridden_warnings": [<warning_code>, ...]}` (A.Validation pattern)
  - Imports: `{"source_batch_id": ..., "source_row_index": ...}`

**Backend implementation pattern:**
- Emit audit in the **same DB transaction** as the mutation. If the tx rolls back, the audit must roll back with it. Otherwise we get phantom audit entries for mutations that didn't happen.
- Centralize via a helper in `app/services/audit_service.py` (create when first cross-resource need arises — currently the logic lives in `register_service.py` and that's fine while it's the only writer).
- Services emit audit. API layer never calls audit helpers directly.

**Why:** This is municipal record-keeping. The audit log is the trust mechanism between the digital system and the paper journals it replaces — it is not a developer convenience. If the system can't explain who changed what and why six months from now, the municipality stops trusting it and adoption fails. Joanna has named this as non-negotiable multiple times.

**How to apply:** Before writing code for any feature, ask: "What state changes here, and is each one persisted enough that we could reconstruct who did what six months from now?" If anything forensically meaningful is ephemeral — add the persistence. Bias toward over-persistence; the cost of an extra row is low, the cost of missing forensic state is high.

**Open: when to move this into committed docs.** Root `CLAUDE.md` principle #5 covers the strictest application (audit every mutation). The broader stance should land in root `CLAUDE.md` as a principle, and a concrete "Audit" section should be added to `backend/CLAUDE.md` with examples. Deferred while a parallel session is mid-chunk on A.Validation; do at next quiet moment.
