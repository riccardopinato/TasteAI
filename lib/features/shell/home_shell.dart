import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/design/responsive.dart';
import '../../core/l10n/app_strings.dart';
import '../../data/preferences/app_preferences_store.dart';
import '../../data/premium/premium_controller.dart';
import '../../data/sync/google_drive_backup_service.dart';
import '../../data/sync/profile_sync_controller.dart';
import '../../domain/account/google_account_controller.dart';
import '../../domain/recipe/recipe.dart';
import '../recipes/anti_waste_screen.dart';
import '../recipes/favorites_screen.dart';
import '../recipes/inspire_screen.dart';
import '../recipes/premium_screen.dart';
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
  late final PremiumController _premiumController;
  late final GoogleAccountController _accountController;
  late final GoogleDriveBackupService _driveBackupService;
  late final ProfileSyncController _profileSyncController;
  int _index = 1;

  @override
  void initState() {
    super.initState();
    _recipeController =
        RecipeController(preferencesStore: widget.preferencesStore);
    _premiumController = PremiumController();
    _accountController = GoogleAccountController();
    _driveBackupService = GoogleDriveBackupService(
      accountController: _accountController,
    );
    _profileSyncController = ProfileSyncController(
      accountController: _accountController,
      driveBackupService: _driveBackupService,
      recipeController: _recipeController,
      settingsController: widget.settingsController,
    );
    _recipeController.initialize();
    _premiumController.initialize();
    _accountController.initialize();
  }

  @override
  void dispose() {
    _premiumController.dispose();
    _profileSyncController.dispose();
    _driveBackupService.dispose();
    _accountController.dispose();
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
            return _buildScaffold(context);
          },
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final List<_NavigationItem> items = <_NavigationItem>[
      _NavigationItem(
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome,
        label: strings.inspire,
      ),
      _NavigationItem(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: strings.search,
      ),
      _NavigationItem(
        icon: Icons.eco_outlined,
        selectedIcon: Icons.eco,
        label: strings.antiWaste,
      ),
      _NavigationItem(
        icon: Icons.favorite_border,
        selectedIcon: Icons.favorite,
        label: strings.favorites,
      ),
      _NavigationItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: strings.profile,
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 900;
        final Widget content = SafeArea(
          child: TasteContentFrame(child: _body(context)),
        );

        if (wide) {
          return Scaffold(
            appBar: AppBar(title: Text(strings.appName)),
            body: Row(
              children: <Widget>[
                SafeArea(
                  child: NavigationRail(
                    selectedIndex: _index,
                    labelType: NavigationRailLabelType.all,
                    destinations: items
                        .map(
                          (_NavigationItem item) =>
                              NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selectedIcon),
                            label: Text(item.label),
                          ),
                        )
                        .toList(growable: false),
                    onDestinationSelected: (int index) {
                      setState(() => _index = index);
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(strings.appName)),
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: items
                .map(
                  (_NavigationItem item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
                )
                .toList(growable: false),
            onDestinationSelected: (int index) {
              setState(() => _index = index);
            },
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    if (_recipeController.loading) {
      return Center(
        child: Semantics(
          label: strings.loadingRecipes,
          liveRegion: true,
          child: const CircularProgressIndicator(),
        ),
      );
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
              FilledButton(
                onPressed: _recipeController.initialize,
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
      );
    }

    return IndexedStack(
      index: _index,
      children: <Widget>[
        InspireScreen(
          controller: _recipeController,
          settings: widget.settingsController,
          onOpenRecipe: _openRecipe,
        ),
        RecipeSearchScreen(
          controller: _recipeController,
          settings: widget.settingsController,
          onOpenRecipe: _openRecipe,
        ),
        AntiWasteScreen(
          controller: _recipeController,
          settings: widget.settingsController,
          onOpenRecipe: _openRecipe,
        ),
        FavoritesScreen(
          controller: _recipeController,
          settings: widget.settingsController,
          onOpenRecipe: _openRecipe,
        ),
        ProfileScreen(
          settings: widget.settingsController,
          recipeCount: _recipeController.recipes.length,
          syncController: _profileSyncController,
          premiumController: _premiumController,
          onOpenPremium: _openPremium,
        ),
      ],
    );
  }

  void _openPremium() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            PremiumScreen(controller: _premiumController),
      ),
    );
  }

  void _openRecipe(Recipe recipe) {
    if (recipe.premiumTier == 'premium' &&
        !_premiumController.isPlus) {
      _openPremium();
      return;
    }

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return AnimatedBuilder(
            animation: _recipeController,
            builder: (BuildContext context, Widget? child) {
              return RecipeDetailPage(
                recipe: recipe,
                languageCode:
                    Localizations.localeOf(context).languageCode,
                metricUnits: widget.settingsController.metricUnits,
                favorite: _recipeController.isFavorite(recipe.id),
                onToggleFavorite: () =>
                    _recipeController.toggleFavorite(recipe.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
