---
name: feedback-defensive-data-shape
description: Reads that assume a data shape (JSON array/object, type, presence) must tolerate violations — because older/buggier versions of your own code, schema drift, and partial migrations leave nonconforming rows. Guard before unnesting/iterating, or one bad row 500s the whole endpoint.
metadata:
  type: feedback
---

**Rule:** Any query or parser that assumes the shape of stored data (this JSON field is an array, this column is a number, this key exists) must **guard against violations**. Production data is not as clean as your current code writes it: earlier code versions, a since-fixed bug, a half-finished migration, or another write path may have left rows in a different shape.

**Why:** A single malformed row crashes the whole read for everyone. Postgres `jsonb_array_elements_text(col)` raises `cannot extract elements from a scalar` if `col` is a string instead of an array — and the entire list/aggregation endpoint returns 500, not just that row. The bad data is often invisible until an unrelated feature queries across it.

**Case study (digital-archives):** an earlier import bug stored a `lookup_multi` field as a plain string (should have been a JSON array of codes). Later, the disposition-options usage-count query did `jsonb_array_elements_text(e.fields->:key)` across all entries → 500 the moment it hit one of those string rows → broke the options dropdown for the whole register. Fix: guard the unnest with a type check —
```sql
CROSS JOIN LATERAL jsonb_array_elements_text(e.fields->:key) AS code
WHERE jsonb_typeof(e.fields->:key) = 'array'
```
Rows that aren't arrays are skipped instead of crashing. (The SQLite test path already did the equivalent `if not isinstance(codes, list): continue` — the two dialects must have parity on defensiveness.)

**How to apply:**
- Before unnesting / iterating / casting a stored value, check its shape: `jsonb_typeof(...) = 'array'`, `isinstance(x, list)`, `key in obj`, `NULLIF(...)`, regex-guarded numeric cast.
- Assume "data written by a previous version of this code is in the corpus." Fixing the WRITE path forward does not fix rows already written — guard the READ too.
- A guarded read also contains the blast radius of any future write bug: one bad row degrades to "skipped/blank", not "endpoint 500".
- When you fix the write-shape bug, remember the legacy rows persist; either backfill them or rely on the read guard.

**Litmus:** "If one row in this table had the wrong type/shape in this field, would this query crash or just skip it?" If crash → add a guard.

**Pair with:** [[schema-driven-not-hardcoded]] — shape bugs often come from a hardcoded path writing the wrong shape. [[cross-impact-reasoning]] — a write-path fix leaves legacy rows behind; the read path is the forgotten cross-impact.
