# TasteAI Flutter roadmap

## Product constraints

- Flutter/Dart shared codebase.
- Local-first/offline-first core.
- No Gemini or mandatory cloud AI in v1.0.
- REUSE-FIRST: search/retrieval architecture follows Notes-Ecosistema.
- Device locale by default, English fallback, manual language selection in Profile.
- Android + stable Web Preview are release outputs.
- Local AI is optional and layered above deterministic retrieval.
- No simulated production features: Kotlin mock Premium does not migrate.
- Canonical recipe data is versioned JSON; indexes are derived and rebuildable.

## v0.1 — Flutter Foundation + Catalog Contract

- modular Flutter source tree;
- TasteAI design system and system dark mode;
- EN/IT/ES/FR/PT localization foundation;
- canonical recipe schema and import contract;
- deterministic search proof-of-concept.

## v0.2 — Kotlin Catalog Migration — DONE

- 111 Kotlin recipes migrated to schema v2;
- 111 unique IDs;
- 650 aligned metric/imperial ingredient rows;
- legacy orphan translations excluded from canonical data;
- dedupe audit persisted.

## v0.3 — Recipe Core — IMPLEMENTED, BUILD GATE OPEN

- schema-v2 catalog wired to Flutter runtime;
- live Browse/Search screen;
- recipe detail with ingredients, instructions, times and chef tips;
- favorites persistence;
- Inspire Me with metadata filters;
- catalog-driven category/difficulty/time/anti-waste filters;
- metric/imperial preference persistence;
- manual language override plus system language default;
- local-only Anti-Waste placeholder, with no fake AI behavior;
- Web scaffold.

## v0.4 — Unified Recipe Search

- persistent FTS index;
- title/ingredient/tag/technique/category weighted ranking;
- shared `UnifiedRecipeRetrievalService` for Search, Inspire Me and later AI;
- ranking benchmarks and regression tests.

## v0.5 — Smart Food Retrieval

- natural constraints such as time, diet and available ingredients;
- semantic index separated from canonical data and fully rebuildable;
- ingredient synonym/alias graph.

## v0.6 — Anti-Waste Engine V2

- deterministic ingredient parser;
- leftover/scrap knowledge rules;
- catalog-first recommendations;
- no unsupported ecological precision claims.

## v0.7 — Local Intelligence Runtime

- `LocalModelEngine` abstraction;
- capability/device checks;
- cancellation, timeout, memory and fallback policy;
- no required model yet.

## v0.8 — TasteAI Local AI

- compact local model selected by measured quality/size/latency/licence;
- intent extraction, reranking and grounded explanations;
- deterministic core remains available when the model is absent.

## v0.9 — Profile & Sync

- optional Google Sign-In;
- local guest mode preserved;
- optional backup/sync.

## v0.10 — Premium

- real entitlement and purchase restore;
- no developer unlock or simulated store dialog;
- feature-based monetization without token/API costs.

## v0.11 — Release Hardening

- accessibility, privacy, migration, performance and size audits;
- full unit/widget/integration tests;
- trusted runtime/AppLab checks where available.

## v1.0 — Production

- Android ARM64 release APK;
- AAB store artifact;
- stable Web deployment;
- iOS-ready shared codebase;
- release evidence bundle.
