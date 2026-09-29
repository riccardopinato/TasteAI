import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../data/preferences/app_preferences_store.dart';
import '../../domain/recipe/recipe.dart';
import '../recipes/anti_waste_screen.dart';
import '../recipes/favorites_screen.dart';
import '../recipes/inspire_screen.dart';
import '../recipes/profile_screen.dart';
import '../recipes/recipe_controller.dart';
import '../recipes/recipe_widgets.dart';
import '../recipes/search_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.preferencesStore,
    required this.settingsController,
  });

  final AppPreferencesStore preferencesStore;
  final AppSettingsController settingsController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final RecipeController _recipeController;
  int _index = 1;

  @override
  void initState() {
    super.initState();
    _recipeController = RecipeController(preferencesStore: widget.preferencesStore);
    _recipeController.initialize();
  }

  @override
  void dispose() {
    _recipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _recipeController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedBuilder(
          animation: widget.settingsController,
          builder: (BuildContext context, Widget? child) {
            return _buildScaffold(context);          },
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final List<NavigationDestination> destinations = <NavigationDestination>[
      NavigationDestination(icon: const Icon(Icons.auto_awesome_outlined), selectedIcon: const Icon(Icons.auto_awesome), label: strings.inspire),
      NavigationDestination(icon: const Icon(Icons.search_outlined), selectedIcon: const Icon(Icons.search), label: strings.search),
      NavigationDestination(icon: const Icon(Icons.eco_outlined), selectedIcon: const Icon(Icons.eco), label: strings.antiWaste),
      NavigationDestination(icon: const Icon(Icons.favorite_border), selectedIcon: const Icon(Icons.favorite), label: strings.favorites),
      NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: strings.profile),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(strings.appName)),
      body: SafeArea(child: _body(context)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: destinations,
        onDestinationSelected: (int index) => setState(() => _index = index),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    if (_recipeController.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_recipeController.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(strings.catalogError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _recipeController.initialize, child: Text(strings.retry)),
            ],
          ),
        ),
      );
    }

    return IndexedStack(
      index: _index,
      children: <Widget>[
        InspireScreen(controller: _recipeController, settings: widget.settingsController, onOpenRecipe: _openRecipe),
        RecipeSearchScreen(controller: _recipeController, settings: widget.settingsController, onOpenRecipe: _openRecipe),
        AntiWasteScreen(controller: _recipeController, settings: widget.settingsController, onOpenRecipe: _openRecipe),
        FavoritesScreen(controller: _recipeController, settings: widget.settingsController, onOpenRecipe: _openRecipe),
        ProfileScreen(settings: widget.settingsController, recipeCount: _recipeController.recipes.length),
      ],
    );
  }

  void _openRecipe(Recipe recipe) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AnimatedBuilder(
            animation: _recipeController,
            builder: (BuildContext context, Widget? child) {
              return RecipeDetailPage(
                recipe: recipe,
                languageCode: Localizations.localeOf(context).languageCode,
                metricUnits: widget.settingsController.metricUnits,
                favorite: _recipeController.isFavorite(recipe.id),
                onToggleFavorite: () => _recipeController.toggleFavorite(recipe.id),
              );
            },
          );
        },
      ),
    );
  }
}
