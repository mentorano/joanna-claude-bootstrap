---
name: smoke-test-downstream-display-not-just-mutation
description: Smoke for mutation flows must walk through every surface that reads affected data — not just the mutation surface itself
metadata:
  type: feedback
---

When smoke-testing a mutation (archive, delete, edit-name-of-shared-resource), go **outside** the self-flow:

- ❌ Only: open dialog → confirm → API 200 → done.
- ✅ Plus: navigate to entity that consumes the mutated resource → does it still display correctly? Is the relationship preserved? Are stale references resolved?

**Why:** mutations often have downstream consumers (lists, details, audit logs, exports). Smoke that tests the mutation surface validates the API contract, but the user's actual experience is "I changed X, then I went to look at Y which uses X". Display-layer bugs surface only when walking that downstream path.

**Common bug class:** soft-delete / archive operations where the archived entity is still referenced by existing data. Frontend lookup may filter out archived items by default → references resolve to raw IDs/codes instead of human labels. Records aren't broken; display is.

**How to apply:**
- For soft-delete / archive: **always walk** existing references after mutation. "Test the tombstone state".
- For edit-of-name (label, title, slug): walk consumers showing that name.
- For any mutation that emits an audit event: open the audit log, verify the event displays correctly with correct enrichment.

**Smoke template addition** for mutation flows:
```js
// 1. Pre-state snapshot (record one example consumer of resource X)
// 2. Perform mutation on X
// 3. Verify mutation surface (API response + UI feedback)
// 4. Navigate to pre-state consumer
// 5. Verify it still displays correctly (or shows expected stale-state UX)
```

Reinforces [[workflow]] chunk-end persona pass. Stronger because downstream-display bugs are not caught by mental simulation alone — they require actual data state where the relationship lives.
