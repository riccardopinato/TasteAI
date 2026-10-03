import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';
import 'package:taste_ai/domain/search/unified_recipe_retrieval_service.dart';

class AssetSearchStore implements AppPreferencesStore {
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

  test('real catalog understands a natural zucchini egg time query', () async {
    final RecipeCatalog catalog = await RecipeCatalog.loadAsset();
    final UnifiedRecipeRetrievalService service = UnifiedRecipeRetrievalService(
      preferencesStore: AssetSearchStore(),
    );
    await service.initialize(
      recipes: catalog.readyRecipes,
      catalogVersion: catalog.catalogVersion,
    );

    final List<RecipeRetrievalHit> hits = service.searchSmart(
      text: 'qualcosa con zucchine e uova in meno di 30 minuti',
      languageCode: 'it',
    );

    expect(hits, isNotEmpty);
    expect(
      hits.any((RecipeRetrievalHit hit) => hit.recipe.id == 'CARBONARA_ZUCCHINE'),
      isTrue,
    );
    expect(
      hits.every((RecipeRetrievalHit hit) => hit.recipe.times.totalMinutes <= 30),
      isTrue,
    );
  });
}
