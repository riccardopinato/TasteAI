import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('production catalog passes canonical quality contract', () async {
    final RecipeCatalog catalog = await RecipeCatalog.loadAsset();
    final List<Recipe> recipes = catalog.readyRecipes;
    final Set<String> ids = recipes.map((Recipe recipe) => recipe.id).toSet();

    expect(catalog.schemaVersion, greaterThanOrEqualTo(2));
    expect(recipes.length, 111);
    expect(ids.length, recipes.length);
    expect(
      recipes.every(
        (Recipe recipe) =>
            recipe.id.isNotEmpty &&
            recipe.slug.isNotEmpty &&
            recipe.textFor('it').title.isNotEmpty &&
            recipe.textFor('it').instructions.isNotEmpty &&
            recipe.ingredients.isNotEmpty &&
            recipe.source?.sourceId.isNotEmpty == true,
      ),
      isTrue,
    );
    expect(
      recipes.where((Recipe recipe) => recipe.antiWaste.enabled).length,
      90,
    );
    expect(
      recipes.where((Recipe recipe) => recipe.premiumTier == 'premium').length,
      21,
    );
  });
}
