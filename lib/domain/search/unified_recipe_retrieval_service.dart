import '../../data/preferences/app_preferences_store.dart';
import '../recipe/recipe.dart';
import 'full_text_recipe_index.dart';

class RecipeRetrievalHit {
  const RecipeRetrievalHit({
    required this.recipe,
    required this.score,
  });

  final Recipe recipe;
  final double score;
}

class RecipeRetrievalQuery {
  const RecipeRetrievalQuery({
    this.text = '',
    this.languageCode = 'en',
    this.maxMinutes,
    this.category,
    this.difficulty,
    this.antiWasteOnly = false,
    this.requiredDiets = const <String>{},
    this.excludedAllergens = const <String>{},
    this.requiredTechniques = const <String>{},
    this.limit,
  });

  final String text;
  final String languageCode;
  final int? maxMinutes;
  final String? category;
  final String? difficulty;
  final bool antiWasteOnly;
  final Set<String> requiredDiets;
  final Set<String> excludedAllergens;
  final Set<String> requiredTechniques;
  final int? limit;
}

class UnifiedRecipeRetrievalService {
  UnifiedRecipeRetrievalService({
    required AppPreferencesStore preferencesStore,
  }) : _preferencesStore = preferencesStore;

  final AppPreferencesStore _preferencesStore;

  List<Recipe> _recipes = const <Recipe>[];
  Map<String, Recipe> _recipesById = const <String, Recipe>{};
  FullTextRecipeIndex? _index;

  bool get ready => _index != null;
  int get indexedRecipeCount => _index?.recipeCount ?? 0;
  int get indexedTermCount => _index?.termCount ?? 0;

  Future<void> initialize({
    required List<Recipe> recipes,
    required int catalogVersion,
  }) async {
    _recipes = List<Recipe>.unmodifiable(recipes);
    _recipesById = <String, Recipe>{
      for (final Recipe recipe in recipes) recipe.id: recipe,
    };

    final String signature = recipeIndexSignature(recipes, catalogVersion);
    final String? cached = await _preferencesStore.loadRecipeSearchIndex();
    final FullTextRecipeIndex? restored = cached == null
        ? null
        : FullTextRecipeIndex.restore(
            encodedSnapshot: cached,
            recipes: recipes,
            expectedSignature: signature,
          );

    _index = restored ?? FullTextRecipeIndex.build(recipes);
    if (restored == null) {
      await _preferencesStore.saveRecipeSearchIndex(_index!.encodeSnapshot(signature));
    }
  }

  List<RecipeRetrievalHit> search(RecipeRetrievalQuery query) {
    final FullTextRecipeIndex? index = _index;
    if (index == null) return const <RecipeRetrievalHit>[];

    final List<RecipeIndexHit> indexedHits = query.text.trim().isEmpty
        ? _recipes
            .map((Recipe recipe) => RecipeIndexHit(recipeId: recipe.id, score: 0))
            .toList(growable: false)
        : index.query(query.text);

    final Set<String> requiredDiets = query.requiredDiets.map(normalizeSearchText).toSet();
    final Set<String> excludedAllergens = query.excludedAllergens.map(normalizeSearchText).toSet();
    final Set<String> requiredTechniques = query.requiredTechniques.map(normalizeSearchText).toSet();
    final String? category = query.category == null ? null : normalizeSearchText(query.category!);
    final String? difficulty = query.difficulty == null ? null : normalizeSearchText(query.difficulty!);

    final List<RecipeRetrievalHit> results = <RecipeRetrievalHit>[];
    for (final RecipeIndexHit indexedHit in indexedHits) {
      final Recipe? recipe = _recipesById[indexedHit.recipeId];
      if (recipe == null) continue;
      if (query.maxMinutes != null && recipe.times.totalMinutes > query.maxMinutes!) continue;
      if (category != null && category.isNotEmpty && normalizeSearchText(recipe.category) != category) continue;
      if (difficulty != null && difficulty.isNotEmpty && normalizeSearchText(recipe.difficulty) != difficulty) continue;
      if (query.antiWasteOnly && !recipe.antiWaste.enabled) continue;

      final Set<String> recipeDiets = recipe.diets.map(normalizeSearchText).toSet();
      if (!requiredDiets.every(recipeDiets.contains)) continue;

      final Set<String> recipeAllergens = recipe.allergens.map(normalizeSearchText).toSet();
      if (recipeAllergens.intersection(excludedAllergens).isNotEmpty) continue;

      final Set<String> recipeTechniques = recipe.techniques.map(normalizeSearchText).toSet();
      if (!requiredTechniques.every(recipeTechniques.contains)) continue;

      double score = indexedHit.score;
      final String localizedTitle = normalizeSearchText(recipe.textFor(query.languageCode).title);
      final String normalizedQuery = normalizeSearchText(query.text);
      if (normalizedQuery.isNotEmpty) {
        if (localizedTitle == normalizedQuery) {
          score += 80;
        } else if (localizedTitle.startsWith(normalizedQuery)) {
          score += 40;
        } else if (localizedTitle.contains(normalizedQuery)) {
          score += 20;
        }
      }

      results.add(RecipeRetrievalHit(recipe: recipe, score: score));
    }

    results.sort((RecipeRetrievalHit a, RecipeRetrievalHit b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final int byTime = a.recipe.times.totalMinutes.compareTo(b.recipe.times.totalMinutes);
      if (byTime != 0) return byTime;
      return a.recipe.id.compareTo(b.recipe.id);
    });

    final int? limit = query.limit;
    if (limit != null && limit >= 0 && results.length > limit) {
      return results.take(limit).toList(growable: false);
    }
    return results;
  }
}
