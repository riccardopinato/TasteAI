import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../domain/recipe/recipe.dart';
import 'recipe_controller.dart';
import 'recipe_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.controller,
    required this.settings,
    required this.onOpenRecipe,
  });

  final RecipeController controller;
  final AppSettingsController settings;
  final ValueChanged<Recipe> onOpenRecipe;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;
    final List<Recipe> recipes = controller.favoriteRecipes;

    if (recipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.favorite_border, size: 52),
              const SizedBox(height: 12),
              Text(strings.noFavorites, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final Recipe recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          languageCode: languageCode,
          favorite: true,
          onOpen: () => onOpenRecipe(recipe),
          onToggleFavorite: () => controller.toggleFavorite(recipe.id),
        );
      },
    );
  }
}
