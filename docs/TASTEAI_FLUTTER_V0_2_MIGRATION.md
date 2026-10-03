# TasteAI Flutter v0.2 — Canonical Recipe Catalog Migration

Baseline Kotlin: `aa5e3890c420e1eb2007aaa942524385aa0c399f` on `main`.

## Result

- Migrated recipes: **111**
- Unique recipe IDs: **111**
- Ingredient rows: **650** metric + **650** imperial, aligned row-by-row
- Premium recipes: **21**
- Anti-waste recipes: **90**
- Dedupe candidates >= 0.72: **0**
- Old RecipeTranslations records: **35**
- RecipeTranslations records matching current catalog: **0**
- Orphan RecipeTranslations records excluded: **35**

## Canonical schema

Catalog schema is bumped to **v2** so no source data is lost during migration.

Each ingredient stores:
- stable `ingredientId`;
- Italian and English normalized display names;
- metric quantity/unit/raw source row;
- imperial quantity/unit/raw source row;
- optional flag;
- normalization confidence.

Recipe content keeps complete Italian and English instructions. Spanish, French, German, Chinese and Japanese legacy titles are retained as title-only localized metadata where present. Portuguese remains explicitly marked as missing and will be completed in the localization step.

## Ingredient normalization audit

- High confidence: **370**
- Medium confidence: **68**
- Low confidence: **212**

Low-confidence rows are **not discarded or rewritten destructively**: their original metric and imperial source strings remain in the catalog for later review.

## Duplicate policy

The v0.1 weighted duplicate policy was run across all migrated recipes.

No pair crossed the 0.72 probable-variant threshold.

## Legacy translations

The old `RecipeTranslations.kt` dataset is not merged because **none of its 35 IDs matches the current 111-recipe catalog**. It is treated as an obsolete parallel catalog rather than silently attached to unrelated recipes.

Orphan IDs:
- `SALMONE_CBT`
- `CHIPS_BUCCE`
- `PAPPA_POMODORO`
- `RISOTTO_MIDOLLO`
- `MOUSSE_CIOCCOLATO`
- `ACQUA_DI_POMODORO`
- `VELLUTATA_ASPARAGI`
- `PESTO_FOGLIE_RAVANELLO`
- `DADO_VEGETALE_SCARTI`
- `GUANCE_BRASATE_BAROLO`
- `FOCACCIA_LIEVITO_MADRE`
- `MAIONESE_AQUAFABA`
- `FRITTATA_PASTA`
- `BUCCE_MELA_TATIN`
- `ELISIR_AGRUMI`
- `CARBONARA_CBT`
- `LASAGNA_REGGIANA`
- `CACCIUCCO_LIVORNESE`
- `RISOTTO_NERO`
- `PARMIGIANA_SCOMPOSTA`
- `PASSATELLI_BRODO`
- `ARANCINI_AVANZATO`
- `PANZANELLA_ESTIVA`
- `POLPETTE_PANE`
- `BRODO_PARMIGIANO`
- `GNOCCHI_PANE`
- `SOUPE_OIGNONS`
- `VELLUTATA_CAVOLO_NERO`
- `LEMON_CURD_SCARTE`
- `INFUSO_CACAO_ARANCIA`
- `CHIPS_ZUCCA`
- `CARCIOFI_ROMANA`
- `TORTA_PANE_AMARETTI`
- `DASHI_SOSTENIBILE`
- `HUMMUS_BUCCE_CECI`

## Gate

Data migration gate: **PASS**.
Runtime Flutter build gate remains separate and requires the Flutter toolchain.
