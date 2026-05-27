---
name: pr-only-workflow
description: All changes go through feature branch + PR, никога `git push origin main` директно. Prerequisite за autonomous code review agents working on `pull_request` events. No carve-outs за prototype phase — clean single signal.
metadata:
  type: feedback
---

# Workflow: PR-only, не direct push на main

**Rule:** ВСИЧКИ commits (код, docs, configs, tests) → feature branch → PR → merge. Никога не пиша директно `git push origin main`. Засяга и docs/metadata файлове (CLAUDE.md, STATUS.md, ROADMAP.md). Single workflow, no exceptions in prototype phase.

**Why this matters:**

End game = maximum automation. Autonomous code review agents work срещу GitHub `pull_request` events — те ревюират при отваряне / push на PR. Ако някои промени minават директно на main → не получават review. Скриват потенциални regressions. Подкопават trust в автоматизирания pipeline.

Чистотата на signal-а е критична за автономни агенти:
- Всеки PR = unit of review с context (title, body, diff, discussion thread).
- Direct push to main = hidden change → review agent няма какво да ревюира.
- Mixed workflow (понякога PR, понякога direct) = inconsistent automation surface.

Soft enforcement (правило в CLAUDE.md), не hard (GitHub branch protection) initially:
- Hard protection ще усложни test loop-а на самия review agent (CI permission tangles, agent-needs-bypass dance).
- Soft → ако правилото държи в практика, harden later чрез branch protection на main.

**Canonical chunk flow:**

```bash
# 1. Start fresh от main
git checkout main && git pull --rebase origin main

# 2. Branch (descriptive kebab-case, scope-specific)
git checkout -b onboarding-hints-leля-гинче
# или: git checkout -b fix-arrow-nav-cell-edit
# или: docs-pr-only-workflow

# 3. Work, commit
git add <specific files, не -A>
git commit -m "..."

# 4. Push + open PR
git push -u origin onboarding-hints-leля-гинче
gh pr create --base main \
  --title "..." \
  --body "..."

# 5. Wait for review agent + owner approve + merge
# (no auto-merge initially; owner holds final gate)

# 6. Cleanup след merge
git checkout main && git pull
git branch -d onboarding-hints-leля-гинче
# Auto-delete on merge handles remote branch (GitHub setting)
```

**Anti-patterns (не правя):**

- **`git push origin main` директно** — никога, дори за typo fixes / docs / config.
- **PR per commit** — overhead без benefit. PR per chunk (логически unit of work).
- **Long-lived branches** — chunk се отваря, merge-ва, изтрива в рамките на дни.
- **Multi-purpose PR** — един chunk = един PR. Ако работата е unrelated → отделни PRs.
- **Auto-merge при first approve** — поне initially, owner държи final merge gate, не да бъде bypass-нат от agent-only approve. (Може да relaxне след confident period.)

**Worktree edge case:** Когато имаш multiple worktrees (e.g., main checked out в worktree A, working в worktree B):
- В worktree B може да си на detached HEAD (защото main е claimed елsewhere)
- `git checkout -b <branch>` от detached HEAD работи нормално — branch се създава от current HEAD
- Push + PR оттам работят без проблем

**Hotfix carve-out:** Default none. Прототип фаза → strict no-exceptions. Production phase: project може да добави explicit carve-out (e.g., `[hotfix]` prefix → direct push), но винаги документирано.

**How to ground the rule:** When tempted да push direct (saving 30 seconds):
- Ask: „кой ще ревюира тази промяна?" — answer трябва да е „agent + owner via PR", не „никой".
- Ask: „ако ме няма за седмица и agent види това в audit trail, очаква ли PR?" — yes.

Related: [[pr-review-three-dot-diff]] — flip side; this is about CREATING PRs, that's about REVIEWING them. Both prerequisite за clean review automation.
