import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../domain/recipe/recipe.dart';
import '../../domain/search/unified_recipe_retrieval_service.dart';
import 'recipe_controller.dart';
import 'recipe_widgets.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({
    super.key,
    required this.controller,
    required this.settings,
    required this.onOpenRecipe,
  });

  final RecipeController controller;
  final AppSettingsController settings;
  final ValueChanged<Recipe> onOpenRecipe;

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';
  String? _category;
  String? _difficulty;
  int? _maxMinutes;
  bool _antiWasteOnly = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;
    final List<RecipeRetrievalHit> hits = widget.controller.searchRecipes(
      query: _query,
      languageCode: languageCode,
      category: _category,
      difficulty: _difficulty,
      maxMinutes: _maxMinutes,
      antiWasteOnly: _antiWasteOnly,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _queryController,
            onChanged: (String value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: strings.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _queryController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ChoiceChip(
                label: Text(strings.all),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              const SizedBox(width: 8),
              ...widget.controller.categories.expand(
                (String category) => <Widget>[
                  ChoiceChip(
                    label: Text(strings.categoryLabel(category)),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(strings.filters),
          leading: const Icon(Icons.tune),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(strings.difficulty),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: <Widget>[
                ChoiceChip(
                  label: Text(strings.all),
                  selected: _difficulty == null,
                  onSelected: (_) => setState(() => _difficulty = null),
                ),
                for (final String value in const <String>['easy', 'medium', 'hard'])
                  ChoiceChip(
                    label: Text(strings.difficultyLabel(value)),
                    selected: _difficulty == value,
                    onSelected: (_) => setState(() => _difficulty = value),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(strings.maxTime),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: <Widget>[
                ChoiceChip(
                  label: Text(strings.all),
                  selected: _maxMinutes == null,
                  onSelected: (_) => setState(() => _maxMinutes = null),
                ),
                for (final int value in const <int>[30, 60, 120])
                  ChoiceChip(
                    label: Text('$value ${strings.minutes}'),
                    selected: _maxMinutes == value,
                    onSelected: (_) => setState(() => _maxMinutes = value),
                  ),
              ],
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.antiWasteOnly),
              value: _antiWasteOnly,
              onChanged: (bool value) => setState(() => _antiWasteOnly = value),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _resetFilters,
                icon: const Icon(Icons.restart_alt),
                label: Text(strings.clearFilters),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              strings.resultCount(hits.length),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
        Expanded(
          child: hits.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(strings.noResults, textAlign: TextAlign.center),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  itemCount: hits.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final Recipe recipe = hits[index].recipe;
                    return RecipeCard(
                      recipe: recipe,
                      languageCode: languageCode,
                      favorite: widget.controller.isFavorite(recipe.id),
                      onOpen: () => widget.onOpenRecipe(recipe),
                      onToggleFavorite: () =>
                          widget.controller.toggleFavorite(recipe.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _category = null;
      _difficulty = null;
      _maxMinutes = null;
      _antiWasteOnly = false;
    });
  }
}
