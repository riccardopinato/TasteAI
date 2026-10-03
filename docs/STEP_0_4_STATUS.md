# TasteAI Flutter v0.4 — Unified Recipe Search

## Implemented

- One `UnifiedRecipeRetrievalService` shared by Search and Ispirami.
- Derived full-text inverted index with weighted postings.
- Prefix matching for live typing.
- AND semantics across multiple query tokens.
- Ranking: titles > ingredients > aliases > tags > techniques > metadata > body.
- Deterministic metadata filters after candidate retrieval.
- Persisted derived index cache with catalog signature.
- Automatic rebuild when catalog content/version changes or cache is invalid.
- Canonical recipe JSON remains the source of truth.
- No Gemini, cloud AI, API keys, or network dependency.

## Architecture

`recipes_master.json` → `FullTextRecipeIndex` → `UnifiedRecipeRetrievalService` → Search / Ispirami / future Anti-Waste / future Local AI.

The persisted search index is disposable. Deleting or corrupting it cannot destroy recipe data: it is rebuilt from the canonical catalog.

## Gate

Run GitHub CI and require:
- flutter analyze
- flutter test
- Android ARM64 release build
- Web release build
