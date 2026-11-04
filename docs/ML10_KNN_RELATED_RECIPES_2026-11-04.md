# ML10 P2 — grounded related recipes via small-catalog kNN

Date: 2026-11-04
Consumer: TasteAI `main` source initially 99e93784db403c9da65c8753c6bbcc802d01180e.
Provenance: [App-Factory-Core #73](https://github.com/riccardopinato/App-Factory-Core/pull/73),
`reference_engines/lib/src/lightweight_ml_p1_p2.dart`,
Core@02f3cd94f0ee6f19bc06fc0cb329fdf5398a739b,
[Dart main CI](https://github.com/riccardopinato/App-Factory-Core/actions/runs/41838055370).

## Scope
- An optional derived `LocalRecipeNearestNeighbors.nearest` small-N kNN
  recommender over **existing canonical recipes**, <=500 candidates, <=10
  suggestions. Active entry in recipe details; no new recipe records.
- Source-grounded numeric feature distances: Jaccard ingredient overlap,
  minutes difference, category, technique overlap and difficulty. Stable ID
  ties, minimum one actual common ingredient. **No learned model**, API, runtime
  or persistent user profiling; not medical/nutrition/allergen advice.
- Eligibility before ranking: `status == ready`, exclude source ID,
  authenticated Plus entitlement passed by shell to include premium, filter
  explicit excluded allergens if supplied. Never leak Premium without Plus.
- UI read-only and user-initiated. Reuses existing route `_openRecipe` for
  Premium guard, navigates only to existing canonical detail.
- All 5 existing locales covered by `AppStrings` parity.

## QA limits
Unit test: ordering, ties, inactive/Premium/allergen exclusion, full
corpus fail-closed, no source mutation. On-device release, cross-language
recipe quality, click-through behavior, and native/store checks are
independent of this pure mathematical reference.
Consumer CI must validate actual source and full Flutter builds before merge.
Do not call this a calibrated likelihood, 90% improvement, E4 sensor or
CERTIFIED GOLDEN. Product release/certification remains governed by v1.0 RC.
