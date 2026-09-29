# TasteAI Flutter v0.3 — Recipe Core

## Implemented

- Flutter runtime reads the canonical schema-v2 `recipes_master.json` directly.
- Only `ready` catalog records enter the user-facing runtime.
- Search/Browse shows the 111 migrated recipes and reacts on every keystroke.
- Filters are driven by recipe metadata, not Kotlin UI constants:
  - category;
  - difficulty;
  - 30/60/120 minute maximum time;
  - anti-waste only.
- Recipe detail supports:
  - localized title/instructions with fallback;
  - metric or imperial source ingredient rows;
  - prep/cook/rest timing;
  - servings;
  - anti-waste note;
  - chef tips;
  - favorite toggle.
- Favorites persist locally through `shared_preferences` and work on Android/iOS/Web.
- Inspire Me selects only from the local canonical catalog and respects category, difficulty and anti-waste constraints.
- Profile persists metric/imperial units and manual EN/IT/ES/FR/PT language override; system locale remains the default.
- Premium metadata is visible but not enforced or simulated. Real entitlement remains v0.10.
- Anti-Waste tab does not pretend to run AI. The deterministic engine remains scheduled for v0.6.
- No Gemini SDK/API key/runtime call is introduced.
- Web bootstrap files are present.

## Tests added

- schema-v2 ingredient parsing;
- metric/imperial raw-row preservation;
- multi-token live retrieval;
- combined deterministic filters;
- favorite persistence contract;
- Inspire Me metadata constraints;
- application smoke test against the bundled local catalog.

## Dependency decision

`shared_preferences: ^2.5.3` is used because that release supports the Dart 3.5 baseline and Android/iOS/Web. It is limited to small user preferences and favorite IDs; recipe data stays in the canonical catalog.

## Explicitly not implemented

- persistent FTS database: v0.4;
- semantic index: v0.5;
- deterministic zero-waste recipe engine: v0.6;
- local LLM: v0.7-v0.8;
- cloud AI/Gemini: excluded from v1.0;
- Google account/sync: v0.9;
- real Premium billing: v0.10.

## Validation status

Source/data contract checks can be performed in this environment, but Flutter/Dart is not installed here. Therefore `flutter analyze`, `flutter test`, Android release build and Flutter Web build are **OPEN GATES**, not reported as successful.
