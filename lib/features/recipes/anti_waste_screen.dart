import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../domain/anti_waste/anti_waste_engine.dart';
import '../../domain/recipe/recipe.dart';
import 'recipe_controller.dart';
import 'recipe_widgets.dart';

class AntiWasteScreen extends StatefulWidget {
  const AntiWasteScreen({
    super.key,
    required this.controller,
    required this.settings,
    required this.onOpenRecipe,
  });

  final RecipeController controller;
  final AppSettingsController settings;
  final ValueChanged<Recipe> onOpenRecipe;

  @override
  State<AntiWasteScreen> createState() => _AntiWasteScreenState();
}

class _AntiWasteScreenState extends State<AntiWasteScreen> {
  final TextEditingController _inputController = TextEditingController();
  List<AntiWasteSuggestion> _suggestions = const <AntiWasteSuggestion>[];
  bool _searched = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String languageCode =
        Localizations.localeOf(context).languageCode;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: <Widget>[
        Text(
          strings.antiWasteTitle,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(strings.antiWasteBody),
        const SizedBox(height: 18),
        TextField(
          controller: _inputController,
          minLines: 2,
          maxLines: 4,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: strings.antiWasteInputHint,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 42),
              child: Icon(Icons.kitchen_outlined),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _analyze(languageCode),
          icon: const Icon(Icons.eco_outlined),
          label: Text(strings.antiWasteAnalyze),
        ),
        if (_searched) ...<Widget>[
          const SizedBox(height: 22),
          if (_suggestions.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  strings.antiWasteNoMatch,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else ...<Widget>[
            Text(
              strings.antiWasteFound(_suggestions.length),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final AntiWasteSuggestion suggestion in _suggestions) ...<Widget>[
              _SuggestionEvidence(
                suggestion: suggestion,
                strings: strings,
              ),
              const SizedBox(height: 8),
              RecipeCard(
                recipe: suggestion.recipe,
                languageCode: languageCode,
                favorite:
                    widget.controller.isFavorite(suggestion.recipe.id),
                onOpen: () => widget.onOpenRecipe(suggestion.recipe),
                onToggleFavorite: () => widget.controller
                    .toggleFavorite(suggestion.recipe.id),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ],
    );
  }

  void _analyze(String languageCode) {
    final List<AntiWasteSuggestion> results =
        widget.controller.antiWasteSuggestions(
      input: _inputController.text,
      languageCode: languageCode,
    );
    setState(() {
      _searched = true;
      _suggestions = results;
    });
  }
}

class _SuggestionEvidence extends StatelessWidget {
  const _SuggestionEvidence({
    required this.suggestion,
    required this.strings,
  });

  final AntiWasteSuggestion suggestion;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final int percent = (suggestion.coverage * 100).round();
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.verified_outlined, size: 18),
                const SizedBox(width: 7),
                Text(
                  '${strings.antiWasteCompatibility}: $percent%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${strings.antiWasteMatched}: '
              '${suggestion.matchedTerms.join(', ')}',
            ),
            if (suggestion.additionalIngredients.isNotEmpty) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                '${strings.antiWasteAdditional}: '
                '${suggestion.additionalIngredients.join(', ')}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
