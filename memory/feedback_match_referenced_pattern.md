---
name: feedback-match-referenced-pattern
description: Когато user референцира съществуващ pattern („като X edit mode", „като Y dialog"), MATCH-вай го close-ly включително spec details (draft+save+confirm flow). Не compromisaй за „прототип velocity" — user-ът explicitly asked for that UX.
metadata:
  type: feedback
---

User-references към existing patterns („като AdminRegisters edit mode") са explicit UX requirements, не loose hints. User знае точно какво иска защото вече ползва pattern-а другаде. Compromise към „по-проста версия" е нарушение на user-ите expectation.

**Why:** Hit digital-archives Chunk C (2026-05-22). Joanna explicitly референцира AdminRegisters edit mode UX (draft state + Save/Cancel + ConfirmDialog диф preview). Шипнах simpler version: auto-persist на всяка промяна, „Готово" exit, no draft, no batch save, no ConfirmDialog. Rationale: „по-просто за прототип". User-ът не push-на back (probably yet), но my implementation не match-ва referenced pattern. Тех debt + inconsistency с rest на admin surfaces.

**How to apply:**
- При user-mentioned references: open file, study pattern thoroughly (state model, UX flow, save semantics, confirm shape). Match all aspects, не само visual surface.
- Document explicit pattern reference в planning: „Following AdminRegisters edit mode contract: editMode state + draft + Save с ConfirmDialog diff + Cancel revert". Then implement to that contract.
- Compromise OK ONLY ако surface-нем trade-off на user PRE-implementation: „за прототип скиктам draft+save и правя auto-persist; добавям после; ОК?". User OK → proceed simpler. User wants full → match.
- Inconsistency cost compounds: 3 admin surfaces with draft+save + 1 surface с auto-persist → user develops mistrust („кога save се случва тук?").
- Свързано с consistent-save-model memory.
