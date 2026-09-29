import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/search/unified_recipe_retrieval_service.dart';

class MemoryStore implements AppPreferencesStore {
  String? index;

  @override
  Future<Set<String>> loadFavoriteIds() async => <String>{};
  @override
  Future<bool> loadMetricUnits() async => true;
  @override
  Future<String?> loadLanguageCode() async => null;
  @override
  Future<String?> loadRecipeSearchIndex() async => index;
  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {}
  @override
  Future<void> saveLanguageCode(String? languageCode) async {}
  @override
  Future<void> saveMetricUnits(bool metricUnits) async {}
  @override
  Future<void> saveRecipeSearchIndex(String encodedIndex) async => index = encodedIndex;
}

Recipe _recipe({
  required String id,
  required String title,
  required List<String> ingredients,
  int minutes = 20,
  List<String> diets = const <String>[],
  List<String> allergens = const <String>[],
  List<String> techniques = const <String>[],
}) {
  return Recipe(
    id: id,
    slug: id,
    localized: <String, LocalizedRecipeText>{
      'it': LocalizedRecipeText(title: title, instructions: const <String>['Test']),
    },
    ingredients: ingredients
        .map(
          (String ingredient) => RecipeIngredient(
            ingredientId: ingredient.toLowerCase(),
            localizedNames: <String, String>{'it': ingredient, 'en': ingredient},
            metric: IngredientAmount(raw: ingredient),
            imperial: IngredientAmount(raw: ingredient),
          ),
        )
        .toList(growable: false),
    category: 'first_course',
    diets: diets,
    allergens: allergens,
    techniques: techniques,
    times: RecipeTimes(prepMinutes: minutes, cookMinutes: 0, restMinutes: 0),
    difficulty: 'easy',
    servings: 2,
    antiWaste: const AntiWasteInfo(enabled: false),
    premiumTier: 'free',
  );
}

void main() {
  test('natural query becomes grounded structured retrieval', () async {
    final UnifiedRecipeRetrievalService service = UnifiedRecipeRetrievalService(
      preferencesStore: MemoryStore(),
    );
    await service.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        _recipe(
          id: 'fast',
          title: 'Pasta con zucchine e ricotta',
          ingredients: <String>['Pasta', 'Zucchine', 'Ricotta', 'Uova'],
          minutes: 25,
        ),
        _recipe(
          id: 'slow',
          title: 'Pasta con zucchine al forno',
          ingredients: <String>['Pasta', 'Zucchine', 'Ricotta'],
          minutes: 70,
        ),
      ],
    );

    final List<RecipeRetrievalHit> hits = service.searchSmart(
      text: 'ho zucchine ricotta e uova, qualcosa di veloce',
      languageCode: 'it',
    );

    expect(hits.map((RecipeRetrievalHit hit) => hit.recipe.id), <String>['fast']);
  });

  test('natural allergen exclusion is combined with explicit retrieval', () async {
    final UnifiedRecipeRetrievalService service = UnifiedRecipeRetrievalService(
      preferencesStore: MemoryStore(),
    );
    await service.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        _recipe(
          id: 'gluten',
          title: 'Pasta di grano',
          ingredients: <String>['Pasta'],
          allergens: <String>['gluten'],
        ),
        _recipe(
          id: 'rice',
          title: 'Pasta di riso',
          ingredients: <String>['Pasta', 'Riso'],
        ),
      ],
    );

    final List<RecipeRetrievalHit> hits = service.searchSmart(
      text: 'pasta senza glutine',
      languageCode: 'it',
    );

    expect(hits.map((RecipeRetrievalHit hit) => hit.recipe.id), <String>['rice']);
  });
}
