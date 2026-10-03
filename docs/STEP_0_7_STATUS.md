# TasteAI Flutter v0.7 — Local Intelligence Runtime

## Implemented

- Model-agnostic local intelligence provider interface.
- Default provider is `NoModelLocalIntelligenceProvider`: zero bundled model bytes.
- Capabilities are explicit: intent understanding, reranking, grounded explanation, embeddings.
- Provider must declare local-only execution.
- Default preferred model size cap: **50 MB**.
- Oversized models are rejected unless a future integration explicitly opts in.
- Device/provider probe before initialization.
- Runtime timeout for inference.
- Grounded explanations are rejected unless recipe context is supplied.
- Core TasteAI initializes and works normally with no local model installed.

## Important

v0.7 does **not** add an LLM to the APK. It only creates the adapter/runtime boundary needed to evaluate small models safely in v0.8.

## Next

v0.8 will benchmark and integrate a small local model only if it meets size, latency, RAM and quality gates. Deterministic retrieval remains the primary path.
