import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../domain/recipe/recipe.dart';
import 'recipe_controller.dart';
import 'recipe_widgets.dart';

class InspireScreen extends StatefulWidget {
  const InspireScreen({
    super.key,
    required this.controller,
    required this.settings,
    required this.onOpenRecipe,
  });

  final RecipeController controller;
  final AppSettingsController settings;
  final ValueChanged<Recipe> onOpenRecipe;

  @override
  State<InspireScreen> createState() => _InspireScreenState();
}

class _InspireScreenState extends State<InspireScreen> {
  String? _category;
  String? _difficulty;
  bool _antiWasteOnly = false;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;
    final Recipe? selected = widget.controller.inspiredRecipe;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: <Widget>[
        Text(strings.inspireTitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(strings.inspireBody, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(strings.category, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    ChoiceChip(label: Text(strings.all), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
                    for (final String category in widget.controller.categories)
                      ChoiceChip(
                        label: Text(strings.categoryLabel(category)),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(strings.difficulty, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    ChoiceChip(label: Text(strings.all), selected: _difficulty == null, onSelected: (_) => setState(() => _difficulty = null)),
                    for (final String value in const <String>['easy', 'medium', 'hard'])
                      ChoiceChip(
                        label: Text(strings.difficultyLabel(value)),
                        selected: _difficulty == value,
                        onSelected: (_) => setState(() => _difficulty = value),
                      ),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(strings.antiWasteOnly),
                  value: _antiWasteOnly,
                  onChanged: (bool value) => setState(() => _antiWasteOnly = value),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {
                    widget.controller.inspire(category: _category, difficulty: _difficulty, antiWasteOnly: _antiWasteOnly);
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(strings.inspireAction),
                ),
              ],
            ),
          ),
        ),
        if (selected != null) ...<Widget>[
          const SizedBox(height: 20),
          RecipeCard(
            recipe: selected,
            languageCode: languageCode,
            favorite: widget.controller.isFavorite(selected.id),
            onOpen: () => widget.onOpenRecipe(selected),
            onToggleFavorite: () => widget.controller.toggleFavorite(selected.id),
          ),
        ],
      ],
    );
  }
}
