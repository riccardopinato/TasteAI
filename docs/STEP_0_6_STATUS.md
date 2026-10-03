# TasteAI Flutter v0.6 — Anti-Waste Engine V2

## Implemented

- Replaced the placeholder Anti-Waste tab with a real local engine.
- Accepts free-text fridge leftovers / ingredients.
- Reuses Smart Query parsing and Unified Recipe Retrieval.
- Searches only recipes explicitly marked as anti-waste.
- Supports partial ingredient coverage instead of requiring every input to match.
- Scores grounded candidates by coverage, retrieval relevance and explicit scrap metadata.
- Shows matched user ingredients and a short list of additional ingredients that may be needed.
- Never creates an invented fallback recipe.
- Removed fake water/CO2 calculations from the assistant flow.

## Product rule

If TasteAI cannot ground a suggestion in the local catalog, it says so. Generation is not used as a hidden fallback.

## Next

v0.7 introduces a model-agnostic Local Intelligence Runtime. The core continues to work without any model.
