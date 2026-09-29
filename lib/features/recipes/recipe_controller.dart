import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../data/preferences/app_preferences_store.dart';
import '../../domain/recipe/recipe.dart';
import '../../domain/recipe/recipe_catalog.dart';

class RecipeController extends ChangeNotifier {
  RecipeController({
    required AppPreferencesStore preferencesStore,
    Future<RecipeCatalog> Function()? catalogLoader,
    Random? random,
  })  : _preferencesStore = preferencesStore,
        _catalogLoader = catalogLoader ?? RecipeCatalog.loadAsset,
        _random = random ?? Random();

  final AppPreferencesStore _preferencesStore;
  final Future<RecipeCatalog> Function() _catalogLoader;
  final Random _random;

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

  List<Recipe> get favoriteRecipes {
    return _recipes.where((Recipe recipe) => _favoriteIds.contains(recipe.id)).toList(growable: false);
  }

  List<String> get categories {
    final List<String> values = _recipes.map((Recipe recipe) => recipe.category).where((String value) => value.isNotEmpty).toSet().toList()..sort();
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
      _favoriteIds = _favoriteIds.where((String id) => _recipes.any((Recipe recipe) => recipe.id == id)).toSet();
    } catch (error) {
      _error = error;
    } finally {
      _loading = false;
      notifyListeners();
    }
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

  Recipe? inspire({
    String? category,
    String? difficulty,
    bool antiWasteOnly = false,
  }) {
    final List<Recipe> candidates = _recipes.where((Recipe recipe) {
      if (category != null && category.isNotEmpty && recipe.category != category) return false;
      if (difficulty != null && difficulty.isNotEmpty && recipe.difficulty != difficulty) return false;
      if (antiWasteOnly && !recipe.antiWaste.enabled) return false;
      return true;
    }).toList(growable: false);

    _inspiredRecipe = candidates.isEmpty ? null : candidates[_random.nextInt(candidates.length)];
    notifyListeners();
    return _inspiredRecipe;
  }
}
