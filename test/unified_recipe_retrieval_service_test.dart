import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/search/unified_recipe_retrieval_service.dart';

class MemoryPreferencesStore implements AppPreferencesStore {
  String? searchIndex;

  @override
  Future<Set<String>> loadFavoriteIds() async => <String>{};

  @override
  Future<bool> loadMetricUnits() async => true;

  @override
  Future<String?> loadLanguageCode() async => null;

  @override
  Future<String?> loadRecipeSearchIndex() async => searchIndex;

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {}

  @override
  Future<void> saveLanguageCode(String? languageCode) async {}

  @override
  Future<void> saveMetricUnits(bool metricUnits) async {}

  @override
  Future<void> saveRecipeSearchIndex(String encodedIndex) async {
    searchIndex = encodedIndex;
  }
}

Recipe recipe({
  required String id,
  required String title,
  required List<String> ingredients,
  List<String> tags = const <String>[],
  List<String> techniques = const <String>[],
  List<String> diets = const <String>[],
  List<String> allergens = const <String>[],
  int minutes = 20,
}) {
  return Recipe(
    id: id,
    slug: id,
    localized: <String, LocalizedRecipeText>{
      'it': LocalizedRecipeText(
        title: title,
        summary: 'Ricetta di test',
        instructions: const <String>['Cuoci e servi.'],
      ),
    },
    ingredients: ingredients
        .map(
          (String value) => RecipeIngredient(
            ingredientId: value.toLowerCase(),
            localizedNames: <String, String>{'it': value, 'en': value},
            metric: IngredientAmount(raw: value),
            imperial: IngredientAmount(raw: value),
          ),
        )
        .toList(growable: false),
    category: 'first_course',
    tags: tags,
    techniques: techniques,
    diets: diets,
    allergens: allergens,
    times: RecipeTimes(
      prepMinutes: minutes,
      cookMinutes: 0,
      restMinutes: 0,
    ),
    difficulty: 'easy',
    servings: 2,
    antiWaste: const AntiWasteInfo(enabled: false),
    premiumTier: 'free',
  );
}

void main() {
  test('persistent full-text index supports prefix multi-token retrieval', () async {
    final MemoryPreferencesStore store = MemoryPreferencesStore();
    final List<Recipe> recipes = <Recipe>[
      recipe(
        id: 'zucchine',
        title: 'Pasta cremosa alle zucchine',
        ingredients: <String>['Pasta', 'Zucchine', 'Ricotta'],
      ),
      recipe(
        id: 'pomodoro',
        title: 'Pasta al pomodoro',
        ingredients: <String>['Pasta', 'Pomodoro'],
      ),
    ];

    final UnifiedRecipeRetrievalService first =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await first.initialize(recipes: recipes, catalogVersion: 2);

    final List<RecipeRetrievalHit> hits = first.search(
      const RecipeRetrievalQuery(
        text: 'pasta zucch',
        languageCode: 'it',
      ),
    );

    expect(hits.map((RecipeRetrievalHit hit) => hit.recipe.id), <String>['zucchine']);
    expect(store.searchIndex, isNotNull);
    expect(store.searchIndex, isNotEmpty);

    final String persisted = store.searchIndex!;
    final UnifiedRecipeRetrievalService second =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await second.initialize(recipes: recipes, catalogVersion: 2);

    expect(store.searchIndex, persisted);
    expect(
      second
          .search(const RecipeRetrievalQuery(text: 'ricot', languageCode: 'it'))
          .single
          .recipe
          .id,
      'zucchine',
    );
  });

  test('filters are applied after full-text candidate retrieval', () async {
    final MemoryPreferencesStore store = MemoryPreferencesStore();
    final UnifiedRecipeRetrievalService service =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await service.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        recipe(
          id: 'fast',
          title: 'Pasta rapida',
          ingredients: <String>['Pasta'],
          diets: <String>['vegetarian'],
          minutes: 20,
        ),
        recipe(
          id: 'slow',
          title: 'Pasta lenta',
          ingredients: <String>['Pasta'],
          diets: <String>['vegetarian'],
          minutes: 80,
        ),
      ],
    );

    final List<RecipeRetrievalHit> hits = service.search(
      const RecipeRetrievalQuery(
        text: 'pasta',
        maxMinutes: 30,
        requiredDiets: <String>{'vegetarian'},
      ),
    );

    expect(hits.map((RecipeRetrievalHit hit) => hit.recipe.id), <String>['fast']);
  });

  test('title matches rank before ingredient-only matches', () async {
    final MemoryPreferencesStore store = MemoryPreferencesStore();
    final UnifiedRecipeRetrievalService service =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await service.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        recipe(
          id: 'title',
          title: 'Risotto ai funghi',
          ingredients: <String>['Riso'],
        ),
        recipe(
          id: 'ingredient',
          title: 'Crema autunnale',
          ingredients: <String>['Funghi'],
        ),
      ],
    );

    final List<RecipeRetrievalHit> hits = service.search(
      const RecipeRetrievalQuery(text: 'funghi', languageCode: 'it'),
    );

    expect(hits.first.recipe.id, 'title');
  });
}
