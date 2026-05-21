---
name: ui-pattern-symmetry-catch
description: When fixing a UI pattern in one place, proactively audit analogous instances in sibling sections / parallel surfaces and flag in same chunk. Don't wait for user to say „и това де".
metadata:
  type: feedback
---

# UI pattern symmetry — audit siblings, don't wait

**Rule:** При fix / improvement на UI pattern instance в едно място, **активно проучи** analogous instances в sibling sections / parallel surfaces и фиксвай ги в same chunk — не чакай потребителят да каже „и това де".

**Why:** UI patterns tend to repeat across analogous sections (e.g., admin „Columns" section + admin „Parameters" section often share same empty-state pattern; multiple list views often share same loading skeleton choice). When dev fixes ONE instance, the symmetric ones become inconsistent. User then notices one-by-one and asks for each → iteration loop.

Catching the symmetry in the original chunk:
- Saves iteration loop (3-5 messages instead of 1).
- Demonstrates dev understands the pattern не just точечно.
- Surfaces structural decisions (should they all share same pattern, or are differences intentional?).

**How to apply:**

When fixing a UI pattern (let's call it pattern X) in location A:

1. **Grep for analogous patterns.** Search component name, key className, distinctive text, function name across `src/`.
2. **Mentally categorize each hit:** „same pattern needs same fix" / „different on purpose" / „unclear — ask".
3. **Apply fix to all „same pattern" instances** в same chunk.
4. **Explicitly call out** in chunk summary: „fixed in A; same pattern also lived in B and C — fixed those too; D looked similar but differs because <reason>, left alone."

**Concrete triggers:**

- **Empty-state UX** — when fixing one empty state with a CTA, audit all empty states. Most should match.
- **Loading skeleton choice** — if switching one page from inline text to TableRowsSkeleton, audit all list pages.
- **Error display** — when wrapping one error in shared ErrorState component, audit all inline error blocks.
- **Affordance discoverability** — fixing one hover state to make affordance visible → audit все similar contexts.
- **Form field validation messaging** — fixing one error message phrasing → audit field validators.

**Anti-pattern:** fix only the reported instance; declare done; user reports next sibling; loop. Same iteration loop trap as not-walking-downstream-effects.

Related: [[smoke-test-downstream]], [[layout-invariants-polish]], [[memory-birth-audit]] — same family of „walk the surface, don't just fix the point".
