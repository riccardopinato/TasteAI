import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../data/preferences/app_preferences_store.dart';
import '../../domain/anti_waste/anti_waste_engine.dart';
import '../../domain/local_ai/local_ai_models.dart';
import '../../domain/local_ai/local_intelligence_runtime.dart';
import '../../domain/recipe/recipe.dart';
import '../../domain/recipe/recipe_catalog.dart';
import '../../domain/search/unified_recipe_retrieval_service.dart';

class RecipeController extends ChangeNotifier {
  RecipeController({
    required AppPreferencesStore preferencesStore,
    Future<RecipeCatalog> Function()? catalogLoader,
    Random? random,
    UnifiedRecipeRetrievalService? retrievalService,
    LocalIntelligenceRuntime? localIntelligenceRuntime,
  })  : _preferencesStore = preferencesStore,
        _catalogLoader = catalogLoader ?? RecipeCatalog.loadAsset,
        _random = random ?? Random(),
        _retrievalService = retrievalService ??
            UnifiedRecipeRetrievalService(preferencesStore: preferencesStore),
        _localIntelligenceRuntime =
            localIntelligenceRuntime ?? LocalIntelligenceRuntime();

  final AppPreferencesStore _preferencesStore;
  final Future<RecipeCatalog> Function() _catalogLoader;
  final Random _random;
  final UnifiedRecipeRetrievalService _retrievalService;
  final LocalIntelligenceRuntime _localIntelligenceRuntime;

  bool _loading = true;
  Object? _error;
  List<Recipe> _recipes = const <Recipe>[];
  Set<String> _favoriteIds = <String>{};
  Recipe? _inspiredRecipe;

  bool get loading => _loading;
  Object? get error => _error;
  List<Recipe> get recipes => _recipes;
  Set<String> get favoriteIds => Set<String>.unmodifiable(_favoriteIds);
  Recipe? get inspiredRecipe => _inspiredRecipe;
  bool get searchReady => _retrievalService.ready;
  int get indexedTermCount => _retrievalService.indexedTermCount;
  LocalAiRuntimeStatus get localAiStatus => _localIntelligenceRuntime.status;
  LocalModelDescriptor get localAiDescriptor => _localIntelligenceRuntime.descriptor;
  bool get localAiAvailable => _localIntelligenceRuntime.available;

  List<Recipe> get favoriteRecipes {
    return _recipes
        .where((Recipe recipe) => _favoriteIds.contains(recipe.id))
        .toList(growable: false);
  }

  List<String> get categories {
    final List<String> values = _recipes
        .map((Recipe recipe) => recipe.category)
        .where((String value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return values;
  }

  Future<void> initialize() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final List<Object> values = await Future.wait<Object>(<Future<Object>>[
        _catalogLoader(),
        _preferencesStore.loadFavoriteIds(),
      ]);
      final RecipeCatalog catalog = values[0] as RecipeCatalog;
      _recipes = catalog.readyRecipes;
      _favoriteIds = values[1] as Set<String>;
      _favoriteIds = _favoriteIds
          .where((String id) => _recipes.any((Recipe recipe) => recipe.id == id))
          .toSet();

      await _retrievalService.initialize(
        recipes: _recipes,
        catalogVersion: catalog.catalogVersion,
      );
      await _localIntelligenceRuntime.initialize();
    } catch (error) {
      _error = error;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _localIntelligenceRuntime.dispose();
    super.dispose();
  }

  bool isFavorite(String recipeId) => _favoriteIds.contains(recipeId);

  Future<void> toggleFavorite(String recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
    await _preferencesStore.saveFavoriteIds(_favoriteIds);
  }

  List<RecipeRetrievalHit> searchRecipes({
    String query = '',
    String languageCode = 'en',
    int? maxMinutes,
    String? category,
    String? difficulty,
    bool antiWasteOnly = false,
    Set<String> requiredDiets = const <String>{},
    Set<String> excludedAllergens = const <String>{},
    Set<String> requiredTechniques = const <String>{},
    int? limit,
  }) {
    return _retrievalService.searchSmart(
      text: query,
      languageCode: languageCode,
      maxMinutes: maxMinutes,
      category: category,
      difficulty: difficulty,
      antiWasteOnly: antiWasteOnly,
      requiredDiets: requiredDiets,
      excludedAllergens: excludedAllergens,
      requiredTechniques: requiredTechniques,
      limit: limit,
    );
  }

  List<AntiWasteSuggestion> antiWasteSuggestions({
    required String input,
    String languageCode = 'it',
    int limit = 8,
  }) {
    return AntiWasteEngine(retrievalService: _retrievalService).suggest(
      input: input,
      languageCode: languageCode,
      limit: limit,
    );
  }

  Recipe? inspire({
    String? category,
    String? difficulty,
    bool antiWasteOnly = false,
  }) {
    final List<RecipeRetrievalHit> hits = searchRecipes(
      category: category,
      difficulty: difficulty,
      antiWasteOnly: antiWasteOnly,
    );
    _inspiredRecipe = hits.isEmpty
        ? null
        : hits[_random.nextInt(hits.length)].recipe;
    notifyListeners();
    return _inspiredRecipe;
  }
}
