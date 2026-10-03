import 'dart:convert';

import 'package:flutter/services.dart';

import 'recipe.dart';

class RecipeCatalog {
  const RecipeCatalog({
    required this.schemaVersion,
    required this.catalogVersion,
    required this.recipes,
  });

  final int schemaVersion;
  final int catalogVersion;
  final List<Recipe> recipes;

  List<Recipe> get readyRecipes => recipes.where((Recipe recipe) => recipe.status == 'ready').toList(growable: false);

  factory RecipeCatalog.fromJson(Map<String, Object?> json) {
    return RecipeCatalog(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      catalogVersion: (json['catalogVersion'] as num?)?.toInt() ?? 1,
      recipes: (json['recipes'] as List<Object?>? ?? const <Object?>[])
          .whereType<Map<Object?, Object?>>()
          .map(
            (Map<Object?, Object?> item) => Recipe.fromJson(
              item.map((Object? key, Object? value) => MapEntry<String, Object?>(key.toString(), value)),
            ),
          )
          .toList(growable: false),
    );
  }

  static Future<RecipeCatalog> loadAsset({String path = 'assets/data/recipes_master.json'}) async {
    final String raw = await rootBundle.loadString(path);
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Recipe catalog root must be a JSON object.');
    }
    final RecipeCatalog catalog = RecipeCatalog.fromJson(decoded);
    if (catalog.schemaVersion < 2) {
      throw FormatException('TasteAI v0.3 requires recipe catalog schema v2+, found ${catalog.schemaVersion}.');
    }
    return catalog;
  }
}
