---
name: chunk-end-reflection-protocol
description: "След chunk-end persona pass и преди final commit/push, run explicit reflection pass: analyze conversation за recurring patterns / catches / iterations / surprises, extract findings, categorize project-specific vs cross-project generic, route към proper artifacts (project CLAUDE.md, project memory, bootstrap memory, bootstrap overlay templates), commit + push в двата repos. Hook reminder is safety net, не trigger."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

Chunk-end ritual в driver mode има два successive passes:

1. **Persona pass** (existing in [[feedback-driver-mode]]). Walk user-facing flows; product behavior sane?
2. **Reflection pass** (new — described here). Walk MY behavior през сесията; learnings worth durable rule?

## Reflection pass — analytic questions

For всяка значителна iteration в session:

1. **Catches by owner.** Какво Joanna хвана? За всяка catch:
   - Беше ли pre-existing rule, която не applied? → reinforce rule.
   - Нов pattern неcaptured? → нова rule.
   - Recurring catch в same chunk? → top-priority reflex (виж X3 incident в [[feedback-extend-match-existing]]).

2. **Iteration loops.** Кои tasks отнеха >2 iterations за convergence?
   - Each extra iteration likely indicates missing pre-implement check.
   - Pre-flight rule extension? (виж [[feedback-simulate-e2e-before-done]])

3. **Recurring patterns.** Кои issues се появиха в multiple unrelated tasks?
   - Cross-cutting issue = high-leverage rule candidate.

4. **Single-incident curiosities.** Кои issues бяха one-off?
   - Likely project-specific gotcha — into project CLAUDE.md gotchas section, not durable rule.

5. **Successful approaches.** Кои pre-empt-нати pitfalls? Кои pattern decisions се validate-наха by lack of catches?
   - Worth capturing positive lessons too (виж feedback type description: capture from success AND failure).

## Categorize each finding

| Tipo finding | Examples | Route |
|---|---|---|
| **Project-specific** | Persona name, brand strings, конкретен schema design, domain entities | Project CLAUDE.md (gotchas/conventions) + project memory (illustrative) |
| **Cross-project generic** | UI pattern (overlay-not-floating), code convention (declarative schema knobs), workflow (prototype before implement) | Project CLAUDE.md + project memory + bootstrap memory + bootstrap overlay template |
| **Pure process / collaboration** | Communication style, decision-making protocol, chunk-end ritual itself | Project memory + bootstrap memory (no CLAUDE.md mirror — meta-rule, не codebase rule) |

**Test for cross-project:** „Ще се прилага ли тoзи pattern в hypothetical нов проект без modifications на same domain?" Yes → cross-project. No → project-specific.

## Route → write → commit

Per finding:

**A. Project-specific:**
1. Add section към съответен CLAUDE.md в проекта (root, frontend, backend).
2. Optional: memory file ako е personal-mode operating instruction.
3. Commit в project repo. Hook reminder fires (informational).

**B. Cross-project generic:**
1. Add section към съответен CLAUDE.md в проекта.
2. Add memory file в project's memory.
3. Mirror memory file в bootstrap (`~/Documents/Projects/joanna-claude-bootstrap/memory/`).
4. Add equivalent section в bootstrap overlay template (`overlay/CLAUDE.md.template` или `overlay/frontend/CLAUDE.md.template` или `overlay/backend/CLAUDE.md.template`).
5. Update bootstrap MEMORY.md index.
6. Commit в project repo. Commit в bootstrap repo. Push двата.

**C. Pure process / collaboration:**
1. Add memory file в project's memory.
2. Mirror в bootstrap memory.
3. Update bootstrap MEMORY.md.
4. Commit + push.

## Hook responsibility

Bootstrap audit hook (post-commit reminder) е **safety net**, не trigger. Той fires-ва когато CLAUDE.md/memory са staged за commit, печата „consider promoting to bootstrap" reminder. Той НЕ trigger-ва automatic LLM analysis (cost-prohibitive, output routing неясен).

Реалният trigger е тoзи reflection pass — manual / agent-initiated, не automatic.

## Frequency

End of every chunk (= unit of work owner declared „done"). Не на всеки commit (commits в chunk middle са partial work). Не на всяка iteration (overkill).

## Implementation timing

В chunk-end sequence:

```
1. Implementation tasks complete
2. Persona pass: walk user flows, smoke test
3. ⭐ Reflection pass: walk MY behavior, extract findings
4. Categorize + route + write findings
5. Update STATUS.md (existing chunk-end step)
6. Commit + push project repo
7. Commit + push bootstrap repo (if cross-project findings)
8. (hook fires reminder if missed — safety net)
9. Declare chunk done
```

## Anti-patterns

- **Skip reflection pass** because „не ми се занимава". Loss compounds — next chunk се start-ва с same gaps.
- **Promote everything без filter test.** Bootstrap ще се пълни с project-specific noise.
- **Promote nothing.** Bootstrap stays stale; нов проект започва без extracted learnings.
- **Update only memory но не CLAUDE.md.** Other agents/team members reading codebase docs пропускат rule.

## Pair-ва се с

- [[feedback-driver-mode]] (chunk-end ritual extension)
- [[feedback-doc-reflex]] (real-time documentation reflex; this protocol е end-of-chunk batch version)
- [[feedback-extend-match-existing]] (one of the most common findings — extend violations)
- Bootstrap hook script (`hooks/pre-commit-bootstrap-audit.sh`) — reminder backstop
