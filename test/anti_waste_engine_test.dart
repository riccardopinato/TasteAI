import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/anti_waste/anti_waste_engine.dart';
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
  required bool antiWaste,
  List<String> scraps = const <String>[],
}) {
  return Recipe(
    id: id,
    slug: id,
    localized: <String, LocalizedRecipeText>{
      'it': LocalizedRecipeText(title: title, instructions: const <String>['Test']),
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
    times: const RecipeTimes(prepMinutes: 10, cookMinutes: 10, restMinutes: 0),
    difficulty: 'easy',
    servings: 2,
    antiWaste: AntiWasteInfo(enabled: antiWaste, usesScraps: scraps),
    premiumTier: 'free',
  );
}

void main() {
  test('ranks grounded anti-waste recipes by ingredient coverage', () async {
    final MemoryStore store = MemoryStore();
    final UnifiedRecipeRetrievalService retrieval =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await retrieval.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        _recipe(
          id: 'both',
          title: 'Pappa di recupero',
          ingredients: <String>['Pane', 'Pomodoro', 'Olio'],
          antiWaste: true,
          scraps: <String>['Pane raffermo'],
        ),
        _recipe(
          id: 'bread',
          title: 'Crostini di recupero',
          ingredients: <String>['Pane', 'Olio'],
          antiWaste: true,
          scraps: <String>['Pane raffermo'],
        ),
        _recipe(
          id: 'not-eco',
          title: 'Pane e pomodoro',
          ingredients: <String>['Pane', 'Pomodoro'],
          antiWaste: false,
        ),
      ],
    );

    final AntiWasteEngine engine = AntiWasteEngine(retrievalService: retrieval);
    final List<AntiWasteSuggestion> results = engine.suggest(
      input: 'pane raffermo, pomodoro',
      languageCode: 'it',
    );

    expect(results, isNotEmpty);
    expect(results.first.recipe.id, 'both');
    expect(results.first.coverage, greaterThan(results[1].coverage));
    expect(results.every((AntiWasteSuggestion item) => item.recipe.antiWaste.enabled), isTrue);
  });

  test('returns no invented fallback when catalog has no grounded match', () async {
    final MemoryStore store = MemoryStore();
    final UnifiedRecipeRetrievalService retrieval =
        UnifiedRecipeRetrievalService(preferencesStore: store);
    await retrieval.initialize(
      catalogVersion: 2,
      recipes: <Recipe>[
        _recipe(
          id: 'bread',
          title: 'Pane di recupero',
          ingredients: <String>['Pane'],
          antiWaste: true,
        ),
      ],
    );

    final AntiWasteEngine engine = AntiWasteEngine(retrievalService: retrieval);
    final List<AntiWasteSuggestion> results = engine.suggest(
      input: 'ananas',
      languageCode: 'it',
    );

    expect(results, isEmpty);
  });
}
