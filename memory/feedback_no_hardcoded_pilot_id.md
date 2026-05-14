---
name: shared-components-never-hardcode-pilot-register-id
description: "Shared компоненти (FilterPanel, AuditLog filters, dashboards и т.н.) НИКОГА не hardcode-ват PILOT_REGISTER_TYPE_ID=1 за loading per-register data (disposition_options, lookup-ите, etc.). Винаги приема registerType / register_instance_id като prop и dispatch-ва. Hardcoded pilot id е skip-class extend-by-matching violation."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: de5e7c6a-fe04-4f8b-b485-0ada71ad4529
---

В A.Multi-register-Polish session (2026-05-14) hardcoded-нах `PILOT_REGISTER_TYPE_ID = 1` в FilterPanel за useDispositionOptions call. Резултат: при отваряне на filter panel-а на регистър I, disposition opции показваше IV-та чл. 36 опции, не I-та „Търг/Конкурс". Joanna хвана.

## Правило

Shared компоненти, които зареждат per-register data (lookup options, disposition codes, validator metadata, dispositional-aware UI), **НИКОГА** не hardcode pilot register id. Винаги:

1. Приемат `registerType` или `register_instance_id` като prop.
2. Conditionally render базирано на schema (`field_definitions`) — не на assumed pilot schema.
3. Skip loading ako schema няма съответния field (e.g. disposition filter не се рендерира за II/III/IX-кратки регистри без disposition_codes).

## Specific applicable surfaces в проекта

- **FilterPanel** — disposition options + price_initial_auction range conditional on schema.
- **AuditLog filters** — register selector работи cross-register; per-register fields трябва да са schema-aware.
- **NewEntry form** — вече schema-driven (config-driven за всички 7).
- **GenericEntryDetail / GenericEntriesList** — schema-driven.
- **Dashboard cards** (бъдеще) — per-register-type config, не assumed-IV.

## Anti-pattern trigger

Когато пиша line като:
```ts
const { data } = useXxx(PILOT_REGISTER_TYPE_ID);
```
в shared компонент — **stop**. Това е extend-by-matching violation. Pilot хардкоднатостта работи в IV-only files (e.g. legacy pilot-IV-only EntriesList JSX), не в shared/generic surfaces.

## How to detect преди да Joanna хване

Pre-implement checkpoint за нов shared компонент:
- „Какви данни load-ва тоя компонент? Per-register ли са?" → ако да, приема register context като prop.
- „Какво ще се покаже за регистър без поле X?" → conditional render.
- „Pilot ще ли изпадне в same code path като non-pilot?" → задължително.

Pair-ва се с [[feedback-extend-match-existing]].
