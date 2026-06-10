---
name: feedback-simplicity-over-completeness
description: When a more 'complete'/honest/granular design risks confusing users (extra signals, finer breakdowns), prefer the simpler model they actually understand. The test is "does the CURRENT model confuse real users?", not "is it theoretically lossless?". Gate richness behind real evidence of need via progressive disclosure. Know when to STOP refining.
metadata:
  type: feedback
---

The engineer's pull is toward completeness/correctness: more signals, finer granularity, no information loss, full honesty. On user-facing surfaces that same pull produces clutter and cognitive load that confuses MORE than the imperfection it fixes — especially for a low-tech persona.

**The rule:** When refining a representation, ask **"does the CURRENT model actually confuse real users?"** — not "is the current model theoretically lossless/honest?". If there's no real confusion, do NOT add complexity. A defensible-simple model beats a complete-but-busy one. A *theoretical* imperfection is not a *user* problem.

**Why:** digital-archives, 2026-06-10. Search relevance tags (Точно / Близко / Възможно). With multiple stacked criteria, the single tag aggregates TWO orthogonal axes — coverage (how many criteria satisfied) × per-criterion quality (how well each matched) — and loses info (2 exact + 1 possible → shows just "Възможно", undersells it). Reasoning escalated: 1 tag → 2 tags (coverage + quality) → per-criterion breakdown (theoretically the only lossless representation, since both axes are per-criterion). Each step more "honest" but more to parse. Joanna's instinct stopped it: *"опасявам се да не направим мазало и по-голямо объркване отколкото сега."* Correct call — the current `AND` + weakest-wins tag is defensible and simple; the breakdown's clutter risk outweighed the edge-case imperfection it would fix. Decided: keep simple, defer richness with rationale; revisit only if real users report confusion.

**How to apply:**
- **Imperfection ≠ problem.** Require evidence of real user confusion before adding signals/granularity/breakdowns.
- **Progressive disclosure is the escape hatch.** Keep the simple surface (one tag / one summary); tuck the richer detail (per-criterion breakdown, secondary signals) behind hover/expand — and only build it if confusion actually shows up.
- **"More honest" can mean "more to parse."** On persona-facing surfaces, faithfulness to the underlying model is not the goal; the user understanding the result is.
- **Know when to STOP refining.** Recognize the moment when chasing the theoretical-best starts costing the simple-and-understood. The product-owner instinct that says "this is getting messy" should win over the engineer's instinct toward lossless models.
- **Record the stop as a decision, not a TODO.** "Considered X, kept simple Y because the clutter risk > the imperfection; revisit on real confusion." Keeps the thinking without accruing complexity on spec.

Related: [[feedback_should_the_constraint_exist]] (question the premise before designing around it), [[feedback_persona_doctrine]] (persona-first tiebreaker), [[feedback_prototype_before_deep_build]] (validate uncertain UX small before replicating), [[feedback_ui_state_hygiene]] (progressive disclosure for unhelpful affordances).
