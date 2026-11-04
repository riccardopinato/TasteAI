import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/search/local_recipe_nearest_neighbors.dart';

void main() {
  Recipe recipe(String id, List<String> ingredients, {
    int minutes = 20,
    String category = 'main_course',
    String difficulty = 'easy',
    String status = 'ready',
    String premiumTier = 'free',
    List<String> allergens = const [],
  }) {
    return Recipe(
      id: id,
      slug: id,
      localized: {
        'en': LocalizedRecipeText(title: id, instructions: const ['Cook']),
      },
      ingredients: [
        for (final ingredient in ingredients)
          RecipeIngredient(
            ingredientId: ingredient,
            localizedNames: {'en': ingredient},
            metric: const IngredientAmount(),
            imperial: const IngredientAmount(),
          ),
      ],
      category: category,
      times: RecipeTimes(
        prepMinutes: minutes,
        cookMinutes: 0,
        restMinutes: 0,
      ),
      difficulty: difficulty,
      servings: 2,
      antiWaste: const AntiWasteInfo(enabled: false),
      premiumTier: premiumTier,
      status: status,
    );
  }

  test('Grounded nearest neighbors rank shared ingredient/time/category', () {
    final source = recipe('source', ['tomato', 'pasta', 'oil']);
    final near = recipe('near', ['tomato', 'pasta', 'oil'], minutes: 24);
    final far = recipe('far', ['tomato', 'rice', 'meat'], minutes: 120);
    final noOverlap = recipe('nope', ['milk', 'cheese']);
    final results = LocalRecipeNearestNeighbors.nearest(
      reference: source,
      available: [far, noOverlap, source, near],
    );
    expect(results.map((x) => x.recipe.id), ['near', 'far']);
    expect(results.first.sharedIngredients, 3);
    expect(results.first.minutesDifference, 4);
    expect(results.first.distance, lessThan(results.last.distance));
  });

  test('Premium, not-ready, and forbidden allergen sources are blocked', () {
    final source = recipe('source', ['rice', 'tomato']);
    final rows = [
      recipe('free', ['rice', 'tomato']),
      recipe('premium', ['rice', 'tomato'], premiumTier: 'premium'),
      recipe('draft', ['rice', 'tomato'], status: 'draft'),
      recipe('allergen', ['rice', 'tomato'], allergens: ['nuts']),
    ];
    final free = LocalRecipeNearestNeighbors.nearest(
      reference: source, available: rows,
      excludedAllergens: {'NUTS'},
    );
    expect(free.map((x) => x.recipe.id), ['free']);
    final plus = LocalRecipeNearestNeighbors.nearest(
      reference: source, available: rows,
      includePremium: true,
      excludedAllergens: {'nuts'},
    );
    expect(plus.map((x) => x.recipe.id), ['free', 'premium']);
  });

  test('All suggestions are deterministic without editing source', () {
    final source = recipe('src', ['egg', 'onion']);
    final a = recipe('a', ['egg', 'onion']);
    final b = recipe('b', ['egg', 'onion']);
    final first = LocalRecipeNearestNeighbors.nearest(
        reference: source, available: [b, a]);
    final second = LocalRecipeNearestNeighbors.nearest(
        reference: source, available: [a, b]);
    expect(first.map((x) => x.recipe.id), ['a', 'b']);
    expect(second.map((x) => x.recipe.id), ['a', 'b']);
    expect(source.ingredients.map((x) => x.ingredientId), ['egg', 'onion']);
  });

  test('Invalid IDs, oversized corpus and empty ingredients fail closed', () {
    final source = recipe('src', ['egg']);
    expect(LocalRecipeNearestNeighbors.nearest(
      reference: source, available: [recipe('bad', ['egg']), recipe('bad', ['egg'])],
    ), isEmpty);
    expect(LocalRecipeNearestNeighbors.nearest(
      reference: source, available: [for (var i = 0; i < 501; i++) recipe('$i', ['egg'])],
    ), isEmpty);
    expect(LocalRecipeNearestNeighbors.nearest(
      reference: recipe('empty', []), available: [source],
    ), isEmpty);
    expect(LocalRecipeNearestNeighbors.nearest(
      reference: source, available: [recipe('a', ['egg'])], limit: 0,
    ), isEmpty);
  });
}
