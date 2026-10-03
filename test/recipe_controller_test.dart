import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';
import 'package:taste_ai/features/recipes/recipe_controller.dart';

class FakePreferencesStore implements AppPreferencesStore {
  Set<String> favorites = <String>{};
  bool metric = true;
  String? language;
  String? searchIndex;

  @override
  Future<Set<String>> loadFavoriteIds() async => Set<String>.from(favorites);

  @override
  Future<bool> loadMetricUnits() async => metric;

  @override
  Future<String?> loadLanguageCode() async => language;

  @override
  Future<String?> loadRecipeSearchIndex() async => searchIndex;

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async =>
      favorites = Set<String>.from(ids);

  @override
  Future<void> saveLanguageCode(String? languageCode) async =>
      language = languageCode;

  @override
  Future<void> saveMetricUnits(bool metricUnits) async => metric = metricUnits;

  @override
  Future<void> saveRecipeSearchIndex(String encodedIndex) async =>
      searchIndex = encodedIndex;
}

Recipe _recipe(
  String id, {
  String category = 'first_course',
  bool antiWaste = false,
  List<String> ingredients = const <String>[],
}) {
  return Recipe(
    id: id,
    slug: id,
    localized: <String, LocalizedRecipeText>{
      'it': LocalizedRecipeText(
        title: id,
        instructions: const <String>['Test'],
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
    category: category,
    times: const RecipeTimes(
      prepMinutes: 10,
      cookMinutes: 10,
      restMinutes: 0,
    ),
    difficulty: 'easy',
    servings: 2,
    antiWaste: AntiWasteInfo(enabled: antiWaste),
    premiumTier: 'free',
  );
}

void main() {
  test('favorites survive controller persistence contract', () async {
    final FakePreferencesStore store = FakePreferencesStore();
    final RecipeController controller = RecipeController(
      preferencesStore: store,
      catalogLoader: () async => RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[_recipe('one')],
      ),
      random: Random(1),
    );

    await controller.initialize();
    await controller.toggleFavorite('one');

    expect(controller.isFavorite('one'), isTrue);
    expect(store.favorites, <String>{'one'});
    expect(store.searchIndex, isNotNull);
  });

  test('inspire uses unified retrieval filters', () async {
    final FakePreferencesStore store = FakePreferencesStore();
    final RecipeController controller = RecipeController(
      preferencesStore: store,
      catalogLoader: () async => RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[
          _recipe('normal'),
          _recipe('eco', antiWaste: true),
        ],
      ),
      random: Random(1),
    );

    await controller.initialize();
    final Recipe? result = controller.inspire(antiWasteOnly: true);

    expect(result?.id, 'eco');
  });

  test('controller search uses the unified full-text index', () async {
    final FakePreferencesStore store = FakePreferencesStore();
    final RecipeController controller = RecipeController(
      preferencesStore: store,
      catalogLoader: () async => RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[
          _recipe('zucchine', ingredients: <String>['Pasta', 'Zucchine']),
          _recipe('pomodoro', ingredients: <String>['Pasta', 'Pomodoro']),
        ],
      ),
    );

    await controller.initialize();
    final results = controller.searchRecipes(
      query: 'pasta zucch',
      languageCode: 'it',
    );

    expect(results.map((hit) => hit.recipe.id), <String>['zucchine']);
  });
}
