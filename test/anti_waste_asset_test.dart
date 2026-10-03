import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/anti_waste/anti_waste_engine.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';
import 'package:taste_ai/domain/search/unified_recipe_retrieval_service.dart';

class AssetStore implements AppPreferencesStore {
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('real catalog grounds potato-peel anti-waste suggestions', () async {
    final RecipeCatalog catalog = await RecipeCatalog.loadAsset();
    final UnifiedRecipeRetrievalService retrieval =
        UnifiedRecipeRetrievalService(preferencesStore: AssetStore());
    await retrieval.initialize(
      recipes: catalog.readyRecipes,
      catalogVersion: catalog.catalogVersion,
    );

    final List<AntiWasteSuggestion> results =
        AntiWasteEngine(retrievalService: retrieval).suggest(
      input: 'bucce di patate',
      languageCode: 'it',
      limit: 12,
    );

    expect(results, isNotEmpty);
    expect(
      results.any(
        (AntiWasteSuggestion item) =>
            item.recipe.id == 'FRITTE_BUCCE_PATATE',
      ),
      isTrue,
    );
  });
}
