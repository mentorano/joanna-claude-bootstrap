# joanna-claude-bootstrap

Personal opinionated overlay за Claude Code-driven проекти. Дава generic CLAUDE.md skeleton-и + memory bootstrap файлове, които cement-ват:

- **Pre-implement gates** (procedural ritual) — Inventory / Persona value / Mental simulate, plus Strategic-question + Half-baked tests. Single highest-leverage codification — preventing iteration loops that documented rules alone can't.
- **Working mode** — driver chunks, ask only за destructive actions / forks / blockers; chunk-end persona pass + reflection pass.
- **Documentation reflex** — proactive capture на decisions/gotchas; STATUS / ROADMAP / product-notes structure; iteration log.
- **Tool discipline** — Edit not sed, native binaries not source-activate, pytest not python -c.
- **UX patterns** (frontend) — anti-layout-shift toolkit, overlay-vs-floating, portal event containment, native HTML defaults, schema-aware shared components, whole-element affordance, ConfirmDialog, read-only-from-day-1, URL-synced state, scoped clears, progressive disclosure.
- **Backend patterns** — strict-on-create / lenient-on-update, temporary specialization dispatch, JSONB seeding, response enrichment, soft-validation.
- **Library gotchas** — shadcn v4 / Base UI primitives (DropdownMenuLabel needs Group, SelectValue lazy fallback).

## Layer architecture

Този overlay работи **над** Mentorano's `auto_demo` template (FastAPI + React + Aurora stack). Three layers:

```
Layer 1: auto_demo               Stack scaffold — Mentorano owns this.
   ↓
Layer 2: joanna-claude-bootstrap Generic governance + conventions.
   ↓                               ← this repo
Layer 3: project-specific        Product context, persona, domain.
```

Layer 2 = generic. Project-specific content (persona, domain language, конкретни schema decisions) живее в Layer 3 на самия проект.

## Files

```
overlay/
├── CLAUDE.md.template                # root product context skeleton
├── backend/CLAUDE.md.template        # FastAPI + SQLAlchemy + Alembic conventions
├── frontend/CLAUDE.md.template       # Vite + React + Tailwind + TanStack conventions
├── STATUS.md.template                # project handoff doc skeleton
├── ROADMAP.md.template               # forward plan skeleton
└── product-notes.md.template         # authoritative product knowledge skeleton

memory/                               # reusable feedback rules and case-study calibrations
├── MEMORY.md                          # compact always-on memory summary
├── feedback_pre_implement_gates.md    # 3 gates + Strategic + Half-baked — single highest-leverage file
├── feedback_persona_doctrine.md        # persona-friendly defaults, affordance restraint, terminology canon
├── feedback_workflow.md                # driver mode + doc reflex + chunk-end ritual + verify-scope-vs-code
├── feedback_iteration_killers.md       # when in loop: console+network, prototype variants, strategic Q, stop half-baked
├── feedback_tooling.md                 # Edit/git -C/venv binary/pytest/curl/visible Chrome
└── feedback_*.md                       # additional focused generic lessons from real project chunks

apply.sh                               # bootstrap script
```

**Memory note:** this repo intentionally keeps both thematic summary files and focused `feedback_*.md` lessons. The always-loaded CLAUDE templates contain the procedural enforcement; memory files preserve deeper calibration and incident-derived rules.

## Usage — apply to a new project

```bash
# 1. Start from auto_demo (или съществуващ проект):
git clone <auto-demo> my-new-project
cd my-new-project

# 2. Apply overlay:
/path/to/joanna-claude-bootstrap/apply.sh --project-name "My New Project"

# 3. Edit Layer 3 specifics:
$EDITOR CLAUDE.md             # add product context, persona, principles
$EDITOR _workspace/product-notes.md  # authoritative product knowledge

# 4. Commit:
git add -A && git commit -m "Apply joanna-claude-bootstrap overlay"
```

The script copies `.template` files into their target locations (without the .template suffix), substitutes simple placeholders like `{{PROJECT_NAME}}`, и optional-но bootstrap-ва memory directory ако се изпълнява в Claude Code home folder.

## Pre-commit hook — automatic reminder

Optional but recommended. Installs a `pre-commit` git hook that detects staged changes to `CLAUDE.md` files / memory feedback files / `STATUS.md` etc. and reminds you to consider promoting cross-project patterns back to this repo.

**Install в съществуващ проект:**
```bash
~/Documents/Projects/joanna-claude-bootstrap/hooks/install.sh /path/to/project
```

Creates a symlink — future bootstrap hook updates apply automatically без reinstall.

**Behavior:**
- Runs on `git commit`.
- Scans staged files for CLAUDE.md / memory paths.
- If matches found → prints banner с list of changed files + filter test guidance.
- **Non-blocking** — commit-ът проходи без интервенция. Just a reminder.
- Suppress per-commit: `BOOTSTRAP_AUDIT_SKIP=1 git commit ...`

**Why a pre-commit hook (vs Claude-session-only reminder):**
Hook triggers at the precise moment when a change is being finalized — не depend-ва от това дали си в Claude session. Survives terminal usage, IDE commits, GitHub Desktop, etc. Standard, debug-vable, transparent.

## When to update this overlay

Когато научим нов **cross-project** convention в реален проект:

1. Извлечи pattern-а без project-specific examples.
2. Add секция в съответния template (или нов memory file).
3. Commit locally in this repo.
4. Ask owner before remote push.
5. Next нов проект → automatically получава pattern-а.

**Не add-вай project-specific lessons** — те живеят в Layer 3 (`STATUS.md` gotchas на конкретния проект). Този repo е само за generic patterns.

## Origin

Extracted from `digital-archives-claude` (Mentorano проект за Община Благоевград, 2026-05). Patterns refined over A.CRUD → A.Validation → A.FieldsRework → A.Roles+Hide → A.Search → A.Multi-register chunks. Документация на decisions: виж commit history.
