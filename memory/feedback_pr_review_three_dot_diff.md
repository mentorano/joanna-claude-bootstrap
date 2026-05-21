---
name: pr-review-three-dot-diff
description: For PR reviews ALWAYS use three-dot diff (`main...branch`) or `gh pr diff`, never two-dot (`main..branch`). Two-dot includes main's post-split additions as fake "deletions on branch side" → phantom regression alarms. Universal git lesson.
metadata:
  type: feedback
---

# PR review: three-dot diff, not two-dot

**Rule:** When reviewing a PR/branch for what it changes, use one of:
- `git diff main...origin/branch --stat` (three-dot — what the branch ADDED relative to common ancestor)
- `gh pr diff <PR#>` (GitHub's authoritative PR diff — source of truth for what gets merged)
- `git merge-tree origin/main origin/branch` (what an actual merge would touch — empty output means clean merge)

**Never use** `git diff main..origin/branch` (two-dot — literal tip-vs-tip difference) for PR review purposes.

**Why:** Two-dot diff includes everything `main` added AFTER the branch split as if it were "deletions on the branch side". On a branch that's a few commits stale, this produces a hugely inflated file list and phantom "regressions" that don't actually exist in the PR. A standard three-way merge will keep main's versions for any file the branch didn't touch — so the apparent reverts never reach main.

**How to apply:**
- Start every PR review with `git diff main...origin/branch --stat` to scope the file list.
- If `git merge-tree origin/main origin/branch` returns empty output, there are no conflicts — branch can be cleanly merged. Any "differences" outside the three-dot diff are illusions.
- If unsure, verify with `git diff $(git merge-base main branch) origin/branch -- <file>` — empty output means the branch hasn't touched that file vs the ancestor.
- For GitHub PRs specifically, `gh pr diff <PR#>` is the source of truth.

**Anti-pattern:** approve/reject PR based on `git diff main..branch` output. Trust the wrong file list, hallucinate regressions, damage credibility with author.

**First command on every PR review:** `gh pr diff <#>` или `git diff main...branch`. Then read.

Related: [[memory-birth-audit]] — same family of "verify-the-premise" gates for PR review.
