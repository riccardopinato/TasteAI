# TasteAI

TasteAI is a Flutter, local-first recipe companion rebuilt from the original Kotlin prototype.

## Current product core

- 111 canonical offline recipes migrated from the Kotlin catalog.
- Live weighted full-text search with a disposable/rebuildable local index.
- Natural-language food retrieval without cloud AI.
- Grounded Anti-Waste Engine that only recommends recipes actually present in the catalog.
- Favorites, Ispirami, recipe detail, metric/imperial units and dark mode.
- UI localization: English, Italian, Spanish, French and Portuguese.
- Optional Google Sign-In and private Google Drive app-data backup.
- RevenueCat-ready TasteAI Plus with real entitlement gating.
- Optional Local Intelligence Runtime; no LLM weights are bundled in the base app.
- Android and Web builds in CI.

## AI policy

TasteAI v1.0 does not depend on Gemini or another cloud LLM.

Deterministic retrieval remains the primary path:

`canonical catalog -> local full-text index -> structured query parser -> grounded results`

Needle 3 is currently an optional candidate for local intent/reranking/embeddings. The native model pack is not bundled until the native bridge and on-device benchmark pass certification.

## Configuration

Development builds work fully as guests without these values.

Google Sign-In:

- `TASTEAI_GOOGLE_CLIENT_ID`
- `TASTEAI_GOOGLE_SERVER_CLIENT_ID`

RevenueCat:

- `TASTEAI_REVENUECAT_API_KEY`
- `TASTEAI_REVENUECAT_ENTITLEMENT` (defaults to `plus`)

Supply values using `--dart-define` at build time. Do not commit private credentials.

## Build

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release --target-platform android-arm64
flutter build appbundle --release
flutter build web --release
```

CI also verifies that Gemini runtime code, cloud-AI API-key references and model-weight files are absent from the Flutter base app.

## Canonical data

`assets/data/recipes_master.json` is the source of truth.

Search indexes, embeddings and other retrieval artifacts are derived data and must always be rebuildable.

New PDF cookbooks should enter through the Recipe Import Pipeline: extract -> normalize -> deduplicate -> review -> merge into the canonical catalog.

## Pending production-only certification

The remaining external configuration gates are documented in `docs/RELEASE_CHECKLIST.md`:

- Needle 3 native bridge/model on real devices;
- Google OAuth client IDs and signing fingerprints;
- RevenueCat products/entitlement/store sandbox;
- production Android signing and store metadata.
