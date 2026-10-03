# TasteAI Flutter v0.8A — Needle 3 Candidate Adapter

## Decision

Needle 3 is the primary candidate for TasteAI's optional local intelligence layer because its product focus is structured extraction, tool calling and embeddings rather than free-form chat.

TasteAI does **not** bundle the model in this step.

## Implemented

- Needle-specific bridge boundary with no native dependency in the base app.
- Needle provider mapped to TasteAI Local Intelligence Runtime.
- Candidate size declared at 35 MB for the full archive.
- Model is marked `bundled: false`.
- Telemetry opt-out is a mandatory probe condition.
- Intent output is allow-listed; unknown fields are discarded.
- Reranking can only reorder IDs already provided by deterministic retrieval.
- Needle is deliberately not used for free-form recipe generation or ungrounded explanation.
- Embedding capability is available through the bridge contract.
- TasteAI-specific benchmark harness and initial intent suite.

## Privacy requirement

A native bridge is not admissible unless it guarantees telemetry is disabled before engine initialization. The future integration must enforce the official Needle opt-out configuration.

## Certification status

**Adapter: CERTIFIED by unit/build gates once CI is green.**

**Native Needle 3 inference: NOT CERTIFIED / not integrated yet.**

v0.8B will add the actual Android/iOS native bridge and downloadable model pack only after native artifacts, license review and on-device benchmark evidence are available.

## Base APK impact

No Needle weights or native engine are added in v0.8A, so the base APK remains lightweight.
