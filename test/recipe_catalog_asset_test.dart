import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled canonical catalog loads all ready recipes', () async {
    final RecipeCatalog catalog = await RecipeCatalog.loadAsset();

    expect(catalog.schemaVersion, greaterThanOrEqualTo(2));
    expect(catalog.readyRecipes.length, 111);
    expect(
      catalog.readyRecipes.every((recipe) => recipe.id.isNotEmpty && recipe.ingredients.isNotEmpty),
      isTrue,
    );
  });
}
