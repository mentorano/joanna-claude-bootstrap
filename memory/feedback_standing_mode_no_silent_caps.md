---
name: standing-mode-no-silent-caps
description: Honor standing directives (e.g. ultracode) by default; reconcile built-vs-manifest before „done"; never silently cap scope — log every deferral.
metadata:
  type: feedback
---

When the owner sets a STANDING directive — an effort/mode like „ultracode", or any „from now on do X" — it is a persistent instruction, not a one-off. Honor it BY DEFAULT on every substantive task. Companion to [[workflow]] „driver mode"; this file is the harder lesson about NOT drifting and NOT hiding scope cuts.

**Originating incident (2026-06-09, Digital Archives assembly).** Owner set ultracode standing at session start. Claude drifted to sequential subagents, built only the search vertical of a planned phase, and **silently deferred** several manifest items (the documents-browsing UI, the cell-tip handwriting-review tooltip, the roles + basic admin panel) — then declared „готово" and demoed, WITHOUT reconciling against the `assembly-map` manifest or naming the deferrals. Owner caught the holes: „би ли ги пропуснал в ултракод режим? и щом го настоях от началото, защо не го пускаш?"

## 1. Honor standing directives by default — don't drift, don't re-ask
- A standing mode (ultracode = author+run workflows by default + adversarial completeness + „log what you dropped, no silent caps") persists for the whole session until revoked.
- **Don't drift back to a lighter approach by inertia** („this part is sequential, so I'll just use subagents"). Even sequential work still gets the mode's completeness/verification rigor.
- **Don't re-ask permission** („да пусна ли workflow?") for things the standing mode says to do automatically. Re-asking IS failing to honor the directive. Run it, then report.

## 2. Reconcile built-vs-manifest BEFORE „done"
- When a plan/manifest exists (assembly map, spec, task list), the completion check is not „did persona-usage exhaust" alone — it is **„does what I built cover EVERY in-scope item of the manifest?"**
- Run a completeness-critic pass: literally reconcile manifest items → present / partial / missing, with evidence. Prefer an adversarial agent over self-attestation.
- Surfacing only what you chose to build, while the manifest lists more, IS the failure.

## 3. No silent scope caps — log every deferral
- If you bound coverage (built a slice, deferred a feature, skipped a verification), say so EXPLICITLY in the milestone report: „Built X; deferred Y, Z (why); not yet verified W."
- **Silent truncation reads to the owner as „covered everything"** — and erodes trust when they later find the holes. A verified-but-PARTIAL build presented as „done" forces the owner to become the coverage QA — the exact thing the higher-rigor mode was set to avoid.

**Why:** The owner sets a higher-rigor standing mode precisely so nothing slips silently. Drifting from it + hiding scope cuts defeats the purpose and makes them do QA. Honoring the mode + reconciling + logging deferrals keeps them in control with an accurate picture.

**How to apply — at every milestone:**
1. Am I still honoring the standing mode? (workflow-by-default, adversarial verify) — if I drifted, correct course out loud.
2. Reconcile against the manifest: list present / partial / missing.
3. Report deferrals explicitly — never imply full coverage.
4. Don't re-ask permission for standing-mode defaults — act, then report.

## Cross-link
- [[workflow]] — driver mode, exhaustion pass, verify-scope-against-code.
- [[prevent-iteration-cycles]] — run own smoke before declaring done; don't make the owner your QA.
- [[retro-rank-by-impact]] — promote principle-level lessons to CLAUDE.md + bootstrap.
