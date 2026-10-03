import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';
import 'package:taste_ai/domain/local_ai/local_ai_models.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_provider.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_runtime.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/domain/recipe/recipe_catalog.dart';
import 'package:taste_ai/features/recipes/recipe_controller.dart';

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

class ReadyFakeProvider implements LocalIntelligenceProvider {
  @override
  LocalModelDescriptor get descriptor => const LocalModelDescriptor(
        id: 'tiny-test',
        displayName: 'Tiny Test',
        version: '1',
        modelBytes: 1024,
        capabilities: <LocalAiCapability>{
          LocalAiCapability.reranking,
        },
      );

  @override
  bool get isLocalOnly => true;
  @override
  Future<bool> probe() async => true;
  @override
  Future<void> initialize() async {}
  @override
  Future<LocalAiResult> run(LocalAiRequest request) async =>
      const LocalAiResult(status: LocalAiRunStatus.success);
  @override
  void dispose() {}
}

void main() {
  test('recipe core initializes even when local AI is absent', () async {
    final RecipeController controller = RecipeController(
      preferencesStore: MemoryStore(),
      catalogLoader: () async => RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[
          const Recipe(
            id: 'one',
            slug: 'one',
            localized: <String, LocalizedRecipeText>{
              'it': LocalizedRecipeText(
                title: 'One',
                instructions: <String>['Test'],
              ),
            },
            ingredients: <RecipeIngredient>[],
            category: 'first_course',
            times: RecipeTimes(
              prepMinutes: 1,
              cookMinutes: 1,
              restMinutes: 0,
            ),
            difficulty: 'easy',
            servings: 2,
            antiWaste: AntiWasteInfo(enabled: false),
            premiumTier: 'free',
          ),
        ],
      ),
    );

    await controller.initialize();

    expect(controller.error, isNull);
    expect(controller.recipes.length, 1);
    expect(controller.localAiAvailable, isFalse);
    controller.dispose();
  });

  test('controller exposes a ready local runtime without changing core data', () async {
    final RecipeController controller = RecipeController(
      preferencesStore: MemoryStore(),
      localIntelligenceRuntime: LocalIntelligenceRuntime(
        provider: ReadyFakeProvider(),
      ),
      catalogLoader: () async => const RecipeCatalog(
        schemaVersion: 2,
        catalogVersion: 2,
        recipes: <Recipe>[],
      ),
    );

    await controller.initialize();

    expect(controller.localAiAvailable, isTrue);
    expect(controller.localAiDescriptor.id, 'tiny-test');
    controller.dispose();
  });
}
