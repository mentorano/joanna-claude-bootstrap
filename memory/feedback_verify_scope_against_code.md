---
name: verify-scope-against-code
description: "Before estimating chunk scope or making framing-laden recommendations based on STATUS.md / ROADMAP.md / handoff sections, read the actual code to verify the docs aren't stale. Docs drift behind reality. When owner pushes back with 'check it' — accept immediately; don't double down on doc-derived framing."
metadata:
  type: feedback
---

STATUS.md, ROADMAP.md, handoff sections, and similar planning docs can desync from reality. A chunk often ships more than its bullets describe (small adjacent polish, drive-by fixes); a deferred concern may have been addressed in a tangential change. Trusting docs as authoritative leads to overscoped recommendations and overblown framing of remaining work.

**Why:** Each chunk lands more than its bullets list. Documentation captures highlights, not full code state. Time between writing a handoff and reading it amplifies the drift. „Small adjacent polish" doesn't always make it into STATUS explicitly, but it removes the TODO that STATUS still claims is pending.

**How to apply:** Before:
- Recommending a chunk's scope to the user („option A vs B vs C")
- Estimating effort or blast radius
- Choosing next priority based on „what's deferred"
- Designing migrations or refactor plans based on doc-claimed gaps

→ READ the relevant code: actually check the components mentioned, the schema config, what's imported where. Verify the doc's „missing X, deferred Y" claims are still true.

When the owner pushes back with „check first" / „verify before recommending" / „you have $TOOL, use it" — accept immediately. Don't double down on framing derived from docs that might be stale. The owner has direct usage signal that docs are out of step.

Anti-pattern observed: handoff doc described a chunk as „options A/B/C, biggest scope adds composite grouping + sortable headers + 900-line refactor" — but the actual generic component already had composite grouping, sticky cols, viewMode, inline edit. Remaining work was a small sort-headers refactor. Owner pushed back; reading the code confirmed and changed the recommendation significantly.

Pairs with:
- [[simulate-e2e-before-done]] — pre-flight verification before declare-done. This rule is upstream pre-flight: verify scope before starting work.
- [[doc-reflex]] — keeping docs current as work progresses reduces drift in the first place.
- [[chunk-end-reflection-protocol]] — this finding tends to emerge from the reflection pass of the chunk that uncovered the stale framing.
