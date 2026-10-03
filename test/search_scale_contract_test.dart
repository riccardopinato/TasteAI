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
  Future<void> saveRecipeSearchIndex(String encodedIndex) async {
    index = encodedIndex;
  }
}

Recipe _recipe(int index) {
  final String uniqueIngredient = 'ingredient' + index.toString();
  return Recipe(
    id: 'R_' + index.toString(),
    slug: 'recipe-' + index.toString(),
    localized: <String, LocalizedRecipeText>{
      'en': LocalizedRecipeText(
        title: 'Recipe ' + index.toString(),
        instructions: const <String>['Cook it.'],
      ),
    },
    ingredients: <RecipeIngredient>[
      RecipeIngredient(
        ingredientId: uniqueIngredient,
        localizedNames: <String, String>{
          'en': uniqueIngredient,
        },
        metric: IngredientAmount(raw: uniqueIngredient),
        imperial: IngredientAmount(raw: uniqueIngredient),
      ),
    ],
    category: 'main_course',
    times: const RecipeTimes(
      prepMinutes: 5,
      cookMinutes: 10,
      restMinutes: 0,
    ),
    difficulty: 'easy',
    servings: 2,
    antiWaste: const AntiWasteInfo(enabled: false),
    premiumTier: 'free',
  );
}

void main() {
  test('unified retrieval remains correct with a 1500 recipe catalog', () async {
    final UnifiedRecipeRetrievalService service =
        UnifiedRecipeRetrievalService(
      preferencesStore: MemoryStore(),
    );
    final List<Recipe> recipes =
        List<Recipe>.generate(1500, _recipe);

    await service.initialize(
      recipes: recipes,
      catalogVersion: 13,
    );

    final List<RecipeRetrievalHit> hits = service.searchSmart(
      text: 'ingredient1499',
      languageCode: 'en',
      limit: 5,
    );

    expect(hits, isNotEmpty);
    expect(hits.first.recipe.id, 'R_1499');
    expect(service.indexedTermCount, greaterThan(1500));
  });
}
