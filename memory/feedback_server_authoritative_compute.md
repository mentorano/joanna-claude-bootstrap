---
name: server-authoritative-compute
description: When a component derives a value (max, count, suggestion, aggregation) from a dataset, compute it server-side — the client only has a paginated/visible slice, the server has the full data.
metadata:
  type: feedback
---

**Rule:** When a component computes a value (max, count, suggestion, aggregation) from a dataset, do it server-side, not client-side. The client only has a paginated / visible slice; the server has the full data.

**Why:** Frontend `Math.max(...visibleItems.map(x => x.value))` works correctly on page 1 (where, by coincidence, the highest item is loaded) and silently produces wrong answers on page 2+. The bug is hidden because the value *looks* sensible; it's just based on a subset. By the time a user notices, the wrong value has already been written to the DB (suggested defaults, prefilled fields) or used as gating logic (permission checks).

The trap: paginated lists are the dominant frontend data shape, and "compute from the loaded array" feels natural. The error surfaces only when someone navigates pagination, applies a filter, or the dataset grows past the page size.

**How to apply:**

When a frontend component needs a computed-from-list value, first ask: **do I have the full dataset, or a paginated slice?**

- Paginated → backend must compute and return the value in the response (denormalized).
- Full dataset (small total, eager-loaded) → client compute is fine; document the assumption with a comment.

**Triggers — patterns that need server-side compute:**

- **Default values / suggestions** — "next available number", "max + 1", "highest priority unused", "earliest available date".
- **Aggregations for badges/summaries** — total, average, max, count of children, count by status.
- **Domain summaries in list views** — latest activity timestamp, top-N child, last actor.
- **Permissions / availability checks** — "can I do X?" when the answer depends on the full dataset (e.g., "is there already a pending request anywhere?").
- **Validation against existing data** — uniqueness checks, conflict detection.

**Anti-pattern:**

```ts
// ❌ Wrong — works on page 1, breaks on page 2+
const suggestedNumber = Math.max(...entries.map(e => parseInt(e.number, 10))) + 1;

// ❌ Wrong — "is there a duplicate?" against paginated list
const hasDuplicate = entries.some(e => e.name === input);
```

**Correct pattern:**

Backend computes the value over the full filtered dataset and embeds it in the response of the resource that needs it:

```python
# Backend — compute over ALL active entries for this instance
class RegisterInstanceWithTypeOut(BaseModel):
    ...
    entry_count: int
    last_entry_at: datetime | None
    suggested_entry_number: str | None  # max(numeric active) + 1
```

Frontend reads `instance.suggested_entry_number` directly — no client compute.

**Case study (digital-archives, 2026-05-19):**

- Bug: suggested `entry_number` for a new entry was computed frontend-side from the displayed entries list (paginated, 100/page, sorted by `created_at desc`).
- The register had entry №333999 plus several smaller numbers (#306, #304, ...). Page 1 showed 100 newest by `created_at` — but the numeric max (333999) wasn't necessarily on that page.
- When the user navigated to a different page where #333999 wasn't loaded → `Math.max` returned 33399 → suggestion 33400. Wrong, and the user would have entered duplicate-adjacent records had they not noticed.
- Fix: backend computes `suggested_entry_number = max(numeric active entry_numbers) + 1` per instance, denormalized into the `RegisterInstanceWithTypeOut` response. Frontend reads the field; zero client math.

**Pair with:** [[cache-invalidation-cascade]] — denormalized server-computed values need invalidation on every mutation that affects the underlying dataset (see that memory's `staleTime` sub-rule for queries with computed responses).
