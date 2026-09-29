import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/search/recipe_search_engine.dart';

void main() {
  const RecipeSearchEngine engine = RecipeSearchEngine();

  Recipe recipe({
    required String id,
    required String title,
    required List<String> ingredients,
    String category = 'first_course',
    String difficulty = 'easy',
    bool antiWaste = false,
    int totalMinutes = 20,
  }) {
    return Recipe(
      id: id,
      slug: id,
      localized: <String, LocalizedRecipeText>{
        'it': LocalizedRecipeText(title: title, instructions: const <String>['Cuoci e servi.']),
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
      times: RecipeTimes(prepMinutes: totalMinutes, cookMinutes: 0, restMinutes: 0),
      difficulty: difficulty,
      servings: 2,
      antiWaste: AntiWasteInfo(enabled: antiWaste),
      premiumTier: 'free',
    );
  }

  test('live multi-token search narrows by ingredient', () {
    final List<RecipeSearchHit> hits = engine.search(
      recipes: <Recipe>[
        recipe(id: 'zucchine', title: 'Pasta cremosa', ingredients: <String>['Pasta', 'Zucchine']),
        recipe(id: 'pomodoro', title: 'Pasta al pomodoro', ingredients: <String>['Pasta', 'Pomodoro']),
      ],
      query: 'pasta zucchine',
      languageCode: 'it',
    );

    expect(hits.map((RecipeSearchHit hit) => hit.recipe.id), <String>['zucchine']);
  });

  test('metadata filters combine deterministically', () {
    final List<RecipeSearchHit> hits = engine.search(
      recipes: <Recipe>[
        recipe(id: 'fast-eco', title: 'Veloce', ingredients: <String>['Pane'], antiWaste: true, totalMinutes: 20),
        recipe(id: 'slow-eco', title: 'Lenta', ingredients: <String>['Pane'], antiWaste: true, totalMinutes: 80),
        recipe(id: 'fast-normal', title: 'Normale', ingredients: <String>['Pane'], totalMinutes: 20),
      ],
      query: 'pane',
      languageCode: 'it',
      maxMinutes: 30,
      antiWasteOnly: true,
    );

    expect(hits.map((RecipeSearchHit hit) => hit.recipe.id), <String>['fast-eco']);
  });
}
