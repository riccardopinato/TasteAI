import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/app/app_settings_controller.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';
import 'package:taste_ai/features/recipes/recipe_controller.dart';

class MemoryStore implements AppPreferencesStore {
  Set<String> favorites = <String>{};
  bool metric = true;
  String? language;
  String? index;

  @override
  Future<Set<String>> loadFavoriteIds() async =>
      Set<String>.from(favorites);
  @override
  Future<bool> loadMetricUnits() async => metric;
  @override
  Future<String?> loadLanguageCode() async => language;
  @override
  Future<String?> loadRecipeSearchIndex() async => index;
  @override
  Future<void> saveFavoriteIds(Set<String> ids) async =>
      favorites = Set<String>.from(ids);
  @override
  Future<void> saveLanguageCode(String? languageCode) async =>
      language = languageCode;
  @override
  Future<void> saveMetricUnits(bool metricUnits) async =>
      metric = metricUnits;
  @override
  Future<void> saveRecipeSearchIndex(String encodedIndex) async =>
      index = encodedIndex;
}

Recipe _recipe(String id) => Recipe(
      id: id,
      slug: id,
      localized: <String, LocalizedRecipeText>{
        'it': LocalizedRecipeText(
          title: id,
          instructions: const <String>['Test'],
        ),
      },
      ingredients: const <RecipeIngredient>[],
      category: 'first_course',
      times: const RecipeTimes(
        prepMinutes: 1,
        cookMinutes: 1,
        restMinutes: 0,
      ),
      difficulty: 'easy',
      servings: 2,
      antiWaste: const AntiWasteInfo(enabled: false),
      premiumTier: 'free',
    );

void main() {
  test('restored favorites are filtered against the local catalog', () async {
    final MemoryStore store = MemoryStore();
    final RecipeController controller = RecipeController(
      preferencesStore: store,
      catalogLoader: () async => RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[_recipe('A'), _recipe('B')],
      ),
    );
    await controller.initialize();

    await controller.replaceFavorites(<String>{'A', 'MISSING'});

    expect(controller.favoriteIds, <String>{'A'});
    expect(store.favorites, <String>{'A'});
    controller.dispose();
  });

  test('settings backup application persists for reload', () async {
    final MemoryStore store = MemoryStore();
    final AppSettingsController settings =
        AppSettingsController(store);
    await settings.initialize();

    await settings.applyBackup(
      metricUnits: false,
      languageCode: 'fr',
    );

    expect(settings.metricUnits, isFalse);
    expect(settings.languageCode, 'fr');
    expect(store.metric, isFalse);
    expect(store.language, 'fr');
    settings.dispose();
  });
}
