/// ML10 P2: deterministic, offline small-catalog nearest-neighbor matching.
/// First-party recipe adapter to App-Factory-Core's bounded numeric kNN
/// reference (02f3cd94f0ee6f19bc06fc0cb329fdf5398a739b).
/// No model weights, network, history, profiling or writes to recipe data.
library;

import 'dart:math' as math;

import '../recipe/recipe.dart';

final class RelatedRecipeHit {
  const RelatedRecipeHit({
    required this.recipe,
    required this.distance,
    required this.sharedIngredients,
    required this.minutesDifference,
  });
  final Recipe recipe;
  /// Euclidean distance over five bounded features, NOT a probability.
  final double distance;
  final int sharedIngredients;
  final int minutesDifference;
}

abstract final class LocalRecipeNearestNeighbors {
  static String _norm(String value) => value.trim().toLowerCase();

  static Set<String> _ingredientIds(Recipe recipe) => {
    for (final ingredient in recipe.ingredients)
      if (_norm(ingredient.ingredientId).isNotEmpty)
        _norm(ingredient.ingredientId),
  };

  static Set<String> _techniqueIds(Recipe recipe) =>
      recipe.techniques.map(_norm).where((e) => e.isNotEmpty).toSet();

  static double _jaccard(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final same = a.intersection(b).length;
    return same / (a.length + b.length - same);
  }

  static double _difficulty(String value) => switch (_norm(value)) {
    'easy' => 0.0,
    'medium' => 0.5,
    'hard' => 1.0,
    _ => 0.5,
  };

  /// Calls must supply the actual eligible, canonical recipe snapshot.
  /// Premium recipes are excluded unless the shell has a verified entitlement.
  /// Allergens, if supplied, are an exclusion gate rather than a score.
  /// No recommendation is a medical/allergen safety certification.
  static List<RelatedRecipeHit> nearest({
    required Recipe reference,
    required Iterable<Recipe> available,
    Set<String> excludedAllergens = const {},
    bool includePremium = false,
    int maxCandidates = 500,
    int limit = 3,
  }) {
    if (maxCandidates < 1 || maxCandidates > 500 ||
        limit < 1 || limit > 10 || reference.id.isEmpty ||
        reference.times.totalMinutes < 0) {
      return const [];
    }
    final baseIngredients = _ingredientIds(reference);
    if (baseIngredients.isEmpty) return const [];
    final baseTechniques = _techniqueIds(reference);
    final rejected = excludedAllergens.map(_norm).toSet();
    final found = <RelatedRecipeHit>[];
    final ids = <String>{};
    var scanned = 0;
    for (final recipe in available) {
      if (++scanned > maxCandidates) return const [];
      if (recipe.id.isEmpty || !ids.add(recipe.id)) return const [];
      if (recipe.id == reference.id || recipe.status != 'ready' ||
          recipe.times.totalMinutes < 0 ||
          (!includePremium && recipe.premiumTier == 'premium') ||
          recipe.allergens.map(_norm).toSet().intersection(rejected).isNotEmpty) {
        continue;
      }
      final ingredients = _ingredientIds(recipe);
      final shared = ingredients.intersection(baseIngredients).length;
      if (shared == 0) continue; // Avoid unrelated nearest suggestions.
      final minutes = (recipe.times.totalMinutes - reference.times.totalMinutes).abs();
      final features = <double>[
        1 - _jaccard(baseIngredients, ingredients),
        math.min(1, minutes / 120),
        _norm(recipe.category) == _norm(reference.category) ? 0 : 1,
        1 - _jaccard(baseTechniques, _techniqueIds(recipe)),
        (_difficulty(recipe.difficulty) - _difficulty(reference.difficulty)).abs(),
      ];
      const weights = <double>[2.0, 0.6, 0.7, 0.2, 0.3];
      var squared = 0.0;
      for (var i = 0; i < features.length; i++) {
        squared += features[i] * features[i] * weights[i];
      }
      found.add(RelatedRecipeHit(
        recipe: recipe,
        distance: math.sqrt(squared),
        sharedIngredients: shared,
        minutesDifference: minutes,
      ));
    }
    found.sort((a, b) {
      final delta = a.distance.compareTo(b.distance);
      return delta != 0 ? delta : a.recipe.id.compareTo(b.recipe.id);
    });
    return List.unmodifiable(found.take(limit));
  }
}
