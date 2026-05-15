---
name: ""
metadata: 
  node_type: memory
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

## ❗ Хванат повторно (X3 в SAME chunk) 2026-05-14 — top-priority reflex

Three failures в SAME chunk (A.Multi-register-Polish):
1. **EntryDetail rewrite:** generic-та detail-а с greenfield 2-col flat grid, без sections, без matched heights. Pilot IV-та имаше single-column + 3 sections + matched heights. Joanna хвана, върнах.
2. **EntriesList non-IV path:** generic-та list БЕЗ Компактен/Подробен toggle, показваше 5 колони от 9-13. Pilot IV-та имаше toggle + 11 detailed columns. Joanna хвана отново.
3. **FilterPanel disposition filter:** hardcoded към PILOT_REGISTER_TYPE_ID=1 → показваше IV-та чл. 36 опции дори в I (0933) където опциите са „Търг / Конкурс". И за II (0934) — schema няма disposition field, но filter-ът пак го рендерираше. Joanna хвана трети път same chunk.

Joanna explicit feedback: „това искам да ти е рефлекс, не да трябва да итерираме." Това е **trust mechanic** в workflow-а — extension chunks стават 2x дълги от необходимото ако всеки feature-parity gap трябва тя да хваща и да ми casa да добавя.

## ⚠ Scope clarification (2026-05-15 — dashboard chunk reflection)

Правилото беше framed като „extension on existing pattern" — multi-register style. Това е твърде тесен trigger. Реалността: **почти всичко е extension** на foundation, която вече съществува (shadcn primitives, design tokens, audit patterns, navigation conventions). Когато feature „feels new" (e.g. dashboard беше „поведенческа нова") — това НЕ е сигнал да skip-ваш inventory. Wrong signal. В dashboard-а: shadcn primitives just-installed + grayscale chart tokens + Card variants — inventory преди V1 щеше да предотврати „грозно/постно" iteration.

**Правилото се прилага винаги когато добавям UI feature**, дори ако feature feels-greenfield или foundation е just-installed.

## ЗАДЪЛЖИТЕЛЕН pre-implement checkpoint (преди да напиша JSX/код)

Когато започвам ANY new UI feature (extension OR feels-greenfield):

**1. Намери pilot/existing analogue ИЛИ foundation.** Един или повече източници на pattern. Може да е:
- **Pilot component** (за extension): pilot IV-та EntryDetail / EntriesList → нов register variant.
- **Foundation library** (за feels-new): shadcn primitives в `src/components/ui/` + design tokens в `index.css` + chart-color tokens + Lucide icons. „Foundation" не е „pilot" но е inventory-able set от строителни блокове.
- **Adjacent pages** (за нов page): existing Home / EntryDetail / AuditLog layout patterns.

**2. Inventory всичките features / tools на източника** преди да започна. List ги в head или в plan. Конкретно за UI:
   - Layout (single/multi column? sections? grid?)
   - Sortable/filterable elements
   - View modes (compact/detailed? toggles?)
   - Affordances (pencil icons? always-visible buttons? hover-only?)
   - State transitions (read↔edit без шок?)
   - URL state sync
   - Loading/empty/error states
   - Keyboard shortcuts
   - Pagination/lazy load
   - Search highlighting
   - Bulk actions
   - Audit links

   За foundation inventory (feels-new feature): какви primitives + tools са налични:
   - shadcn primitives в `src/components/ui/` — кои са install-нати? (Card, Badge, Tabs, Select, Skeleton, etc.)
   - Design tokens в `index.css` — `--background`, `--card`, `--primary`, `--muted`, `--accent`, `--chart-1..5`
   - Chart palette — grayscale ли е, или multi-color? Override ли трябва?
   - Icon library — Lucide
   - Chart library — Recharts
   - Common patterns в analogous pages — кои са, кои се reusable

**3. Match всеки feature в новия implementation.** Не за всяко „greenfield версията не го нуждае" — pilot-ът има these features защото Joanna ги е validate-нала. Default-ът е: матч-вай. Само ако ESCAPe (конфликт/невъзможност) → питай.

**4. Pre-flight check (за extension implementations):** преди да declare-вам ready, mental run:
   - „Дали новата surface визуално изглежда от identical-у на pilot-а?"
   - „Дали всички pilot affordances съществуват тук?"
   - „Дали една persona може да swap-не между регистри и да каже 'същият UI'?"

## Anti-pattern triggers (когато реагирай със заmisла-преди-implement)

Lazy reflex-и, които води до тоя failure mode:
- „Greenfield design за нов component" → ❌ pilot-ът е shape-а
- „Modern look" → ❌ pilot-ът е shape-а
- „Default за нови components" → ❌ pilot-ът е default
- „Тоя feature не е strictly needed за minimum viable" → ❌ feature parity е minimum viable за extension
- „Schema-driven означава generic = по-flat" → ❌ schema-driven значи declarative, не shape-loss

Всичките са rationalizations за adapting old to new, instead of new to old.

## Detailed pattern на conflict resolution

Конфликт ситуации с pilot-я pattern:

**A. Pilot има feature, новият use case в principle не го нуждае.**
- Right move: добавя feature anyway (на dormant state ако applies). Reasoning: persona consistency важи повече от лек overhead на dead code.
- Example: новият register тип няма conceptual disposition. Все пак field-ът съществува (празен), за да поддържа UI symmetry. (Или: schema declare-ва кои нямат полето.)

**B. Pilot има feature, но требва различни declarative knobs за да scales.**
- Right move: extract pilot's hardcoded logic в declarative property на schema, default-вам го така че pilot-а работи както преди, новите регистри декларират техните stoynosти.
- Example: pilot COMPACT_COLUMN_IDS hardcoded. Добавя `compact: True` на FieldDefinition. Pilot default — primary fields пом маркирани compact. Нов register — sub-set defined декларативно.

**C. Pilot feature е реално non-applicable на новия use case.**
- Right move: ПИТАЙ. Show pilot's feature, обясни защо не пасва тук, опции за trade-off. Joanna decides.
- Example: pilot е „registry of contracts с buyer info". Нов entity е „lookup table" без buyer. Pilot's buyer-related affordances не applies. Питай как да го третираме.

## Pair-ва се с

- [[feedback-prototype-ux-variants]] — extension variants заслужават prototypes when conflict
- [[feedback-no-layout-shift-proactive]] — pilot's anti-shift техники се inheritват automatically при matching
- [[feedback-driver-mode]] — extending е driver chunk; matching pilot е част от „extend the spec"

## Original analysis

**Правилото:** новото трябва да изглежда и да се държи **като старото**, не обратното. Това включва:

| Aspect | Wrong | Right |
|---|---|---|
| Layout | Greenfield design на новия компонент | Copy structure от съществуващото (sections, column count, spacing) |
| Visual styling | Default Tailwind grid + my taste | Same classes като existing surfaces |
| Field behavior | Generic „flat dl" | Match existing field-group treatment |
| State transitions | Default React patterns | Same patterns като existing (e.g. min-h reservedfor stable height) |
| Section/group structure | Strip ако schema не го explicit-но изисква | Преserve, дори ако трябва да добавя „section" property |
| Spacing/typography | My default | Same като existing |

**Когато conflict с новото:** ако съществуващия pattern не позволява новата функционалност (e.g. multi-register изисква 7 регистъра, всеки с собствена schema — pilot's hardcoded sections не scales) → **спри**, опиши конфликта, предложи варианти, ПИТАЙ. Не еднолично рестрyктурирай.

**Example на правилно прилагане (2026-05-14 А.Multi-register-Polish chunk):**
- ✅ Schema-driven detail: copy pilot's single-column + 3-section layout. Add `section` property to FieldDefinition за declarative grouping. Section labels „Идентификация / Цени / Договор" inherit-ват се от pilot.
- ✗ Schema-driven detail: greenfield 2-column flat dl grid с „modern" look, защото schema-driven е по принцип flat. **Това беше моя грешка.** Joanna хвана точно това и попита защо.

**Anti-pattern triggers (когато реагирай със заmisла-преди-implement):**
- „По-чисто би било да [restructure-вам съществуващото]"
- „Default за нови components"
- „Generic заслужава прост design"  
- „Тоя pattern не е нужен в новия context"

И четирите са rationalizations за adapting old to new, instead of new to old.

**How to apply:**
1. Преди да започна implementation на нов компонент: open съществуващите analogues (тук pilot IV detail / list). Не само като reference — като template.
2. Default mental model: „Този нов component ще outwardly изглежда identically с existing. Само schema-driven внутре е разликата." Ако reality differs — почему? Обясни себе си или питай.
3. При conflict, present варианти и попитай. „Pilot има 3 sections hardcoded; non-IV могат да имат различни sections. Опции: A) добавя `section` property на schema. B) hardcode-вам frontend mapping по register code. C) ..."
4. Pair-ва се с [[feedback-prototype-ux-variants]] — variantite на extension решения често merit-ват prototype-и.
5. Pair-ва се с [[feedback-no-layout-shift-proactive]] — extension по съществуващ pattern наследява anti-shift техники automatically; greenfield ги губи.
