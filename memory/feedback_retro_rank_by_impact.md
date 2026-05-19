---
name: retro-rank-by-impact
description: When analyzing a session for reinforcement learning items, RANK BY IMPACT — lead with principle-level rules that shape ALL future work. Don't bury them in a flat chronological list of gotchas.
metadata:
  type: feedback
---

**Rule:** When doing session-end RL/retrospective analysis, distinguish two classes of takeaway and order them deliberately:

1. **Principle-level rules** — shape ALL future work; should land in project root CLAUDE.md + bootstrap. Examples: "every async mutation needs user-visible feedback", "cross-impact scan before shipping a behavior change", "confirm dialog for impactful saves".

2. **Pattern/gotcha case studies** — specific reminders for specific situations. Examples: "shadcn `*Label` needs `*Group` ancestor", "Base UI uses `render={}` not `asChild`". Land in memory files.

Lead with #1. Don't bury principle-level rules in a flat chronological list of gotchas — the user has to pull them out for you, which is exactly the failure mode the retro should prevent.

**Why:** Caught explicitly: I produced a 14-item flat list ordered by discovery in the session. User had to ask "what number is rule X" three times to surface the most important rules. They were *in* the list, just not *prioritized* — buried.

The cost: principles that should reshape work are read once and forgotten. Patterns are easier to recall (one specific situation). Principles need promotion to be reinforced.

**How to apply:**

When asked for RL analysis or retro:

1. **First pass — collect everything** (what was learned, what was caught, what was friction).
2. **Classify each item:**
   - Does it apply to most future work? → principle-level.
   - Is it about a specific library/situation? → case-study/gotcha.
3. **Rank principle-level items by impact:**
   - How often will this apply? (Daily, weekly, rarely?)
   - What's the cost of missing it? (Hours of debugging, lost user trust, data corruption?)
   - Top 3-5 → promote to CLAUDE.md + bootstrap, NOT just memory.
4. **Present in order:**
   - Lead: "Top N principle-level rules (going to CLAUDE.md / bootstrap)"
   - Then: "Case studies (going to memory files)"
5. **Recommend explicit promotion:** "These 3 should be principles #N+1, #N+2, #N+3 in CLAUDE.md. The remaining 8 are case studies."

**Anti-pattern:**

Dumping the full list flat. The user has to do the ranking work themselves. Defeats the purpose of asking for retro analysis.

**Pair with:** [[workflow]] — chunk-end persona+reflection passes. The reflection pass should produce ranked findings, not flat ones.
