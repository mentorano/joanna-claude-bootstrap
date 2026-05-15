---
name: ""
metadata: 
  node_type: memory
  originSessionId: 80f34a86-2229-4260-b8ee-98451bbf8175
---

Когато feature има **>1 defensible architectural path**, ask owner choice **BEFORE deep implementation** — не след.

Examples:
- Multi-register dashboard: two-zone layout (generic + per-register) vs single-dropdown switcher vs primary-with-swap → 3+ defensible options.
- IA shift: Home = dashboard vs Home = registers list with dashboard above vs separate /dashboard route.
- Data scope: cross-register aggregates vs register-specific only vs both.

**Anti-pattern (caught 2026-05-15 dashboard chunk):** строях Option C (two-zone) по разговор с owner; после построих, owner reverted: „direckt-ноо реверти, искам по-друг подход" (single dropdown). Cost: full revert + rebuild loop. Could've avoided ако бях питал „преди да започна build, кой от 3-те architectural paths?" дори след initial Option C choice.

**Why pivots са expensive:** mid-implementation revert изисква:
- Discard partially-built code
- Mental context switch
- Re-design new approach (often with same blind spots)
- Re-build
- ≥2x time на initial estimate

**How to apply:**

1. **Step back periodically.** Когато 3+ catches in a row на „cosmetics" → stop. Спирай и питай: „is the overall structure right? Should I step back before more polish?"

2. **Strategic question prompt template:** „Има N defensible architectural paths за <feature>: [A], [B], [C]. Кой path преди да тръгна с deep build?"
   - List 2-4 paths with one-line trade-off each.
   - Owner picks; you commit.
   - Don't deep-build without this answer.

3. **Recognize signals за нужда от strategic question:**
   - >1 way to organize / layout / scope data
   - Long-term implications (multi-tenant, scaling, future features)
   - User mental model varies (one persona vs another)
   - Architectural — touches data shape OR navigation OR primary surface

4. **Counter-signal:** Don't ask за tactical decisions (font size, exact wording, single-cell layout). Those are own-judgement.

Pair-ва се с [[prototype-ux-variants]] — за UX choice points с >1 defensible option, build switchable prototypes if cheap. За architectural, asking е по-евтино.

Pair-ва се с [[driver-mode]] — driver mode означава „execute chunk без интеррапции", не „не питай преди да тръгнеш". Architectural questions преди build are part of „align with scope".

Caught: dashboard multi-register chunk had 2 pivots (Option C build → revert to single-dropdown; и преди това: cards composition променяна 2 пъти). Both predictable ako I'd asked strategic „кой path" upfront.
