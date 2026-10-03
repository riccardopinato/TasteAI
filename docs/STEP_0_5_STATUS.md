# TasteAI Flutter v0.5 — Smart Food Retrieval

## Implemented

- Natural-language query parser running fully on-device.
- Extracts explicit or implicit maximum cooking time.
- Understands category and diet constraints.
- Understands common allergen exclusions.
- Understands cooking techniques such as oven, air fryer and sous-vide.
- Understands anti-waste intent.
- Removes conversational filler and quantities from retrieval text.
- Canonicalizes common ingredient synonyms across Italian/English vocabulary.
- Merges inferred constraints with UI filters.
- Uses the same persisted v0.4 full-text index: no second search engine.

Examples now supported deterministically:

- `zucchine ricotta e uova, qualcosa di veloce`
- `pasta senza glutine entro 30 minuti`
- `avanzi di patate in friggitrice ad aria`
- `dessert vegetariano entro 45 minuti`

No LLM or cloud request is involved. The parser is deterministic and inspectable.

## Next

v0.6 adds the grounded Anti-Waste Engine V2 on top of the same retrieval service.
