---
name: feedback-hmr-diagnosis-curl-first
description: Когато user казва „не виждам промяна" — curl served file FIRST преди да допускаш bug в кода. Multi-port Vite (worktrees) + browser cache → често браузърът гледа стар код.
metadata:
  type: feedback
---

„Не виждам промяна" → 60% от случаите е stale state (HMR cache, browser cache, multi-port Vite, multi-worktree dev server), не code bug. Diagnosing-вай в този ред:

1. **Curl served file** — `curl -s 'http://localhost:PORT/src/components/X.tsx' | grep -E 'твой_нов_pattern'`. Ако новият pattern е там → frontend bundle е fresh; проблемът е browser-side. Ако не е там → Vite не е picked up; check dev server / file path.
2. **Confirm correct port** — `lsof -nP -iTCP -sTCP:LISTEN | grep node`. Multi-worktree setups имат multiple Vite (5173, 5174…). Питай user-а кой port вижда.
3. **Confirm correct worktree** — `ps aux | grep vite` показва пътя на bin-а. „digital-archives-main/frontend/node_modules/.bin/vite" vs „digital-archives-claude/frontend/node_modules/.bin/vite". Ако user е на different worktree-а от моите edits → промяната липсва.
4. **Hard refresh** (Cmd+Shift+R) — finally. Често е първото което се пита user-а, но често не помага защото проблемът е по-нагоре.

**Why:** Hit многократно в digital-archives. Едно сесия user наблюдаваше „променено" поведение на :5174 (main worktree) докато моите edits бяха на :5173 (claude worktree). Изгубени 15+ min докато се диагностицира.

**How to apply:**
- При „не виждам промяна" claim: FIRST curl served file. Това валидира че кодът е там.
- Документирай multi-port setup в STATUS.md или CLAUDE.md ако проектът има worktrees.
- За user-driven testing: ясно посочи кой URL/port да тества (избягвай ambiguity).
- Свързано: ако имаш main + feature worktrees, dev server може да върви само на main (за shared DB state). Промените на feature branch не са visible until merge OR until user switches dev server.
