import 'package:flutter/material.dart';

import '../../core/design/responsive.dart';
import '../../core/l10n/app_strings.dart';
import '../../domain/recipe/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.languageCode,
    required this.favorite,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final String languageCode;
  final bool favorite;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final LocalizedRecipeText text = recipe.textFor(languageCode);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      text.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    color: favorite ? scheme.error : null,
                    tooltip: favorite
                        ? strings.removeFavoriteAction
                        : strings.addFavoriteAction,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _MetaPill(
                    icon: Icons.restaurant_menu,
                    label: strings.categoryLabel(recipe.category),
                  ),
                  _MetaPill(
                    icon: Icons.timer_outlined,
                    label:
                        '${recipe.times.totalMinutes} ${strings.minutes}',
                  ),
                  _MetaPill(
                    icon: Icons.signal_cellular_alt,
                    label:
                        strings.difficultyLabel(recipe.difficulty),
                  ),
                  if (recipe.antiWaste.enabled)
                    _MetaPill(
                      icon: Icons.eco_outlined,
                      label: strings.antiWaste,
                    ),
                  if (recipe.premiumTier == 'premium')
                    _MetaPill(
                      icon: Icons.workspace_premium_outlined,
                      label: strings.premium,
                    ),
                ],
              ),
              if (text.summary.isNotEmpty) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  text.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.languageCode,
    required this.metricUnits,
    required this.favorite,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final String languageCode;
  final bool metricUnits;
  final bool favorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final LocalizedRecipeText text = recipe.textFor(languageCode);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          text.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: favorite ? scheme.error : null,
            tooltip: favorite
                ? strings.removeFavoriteAction
                : strings.addFavoriteAction,
          ),
        ],
      ),
      body: TasteContentFrame(
        maxWidth: 840,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: <Widget>[
            Text(
              text.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _MetaPill(
                  icon: Icons.restaurant_menu,
                  label: strings.categoryLabel(recipe.category),
                ),
                _MetaPill(
                  icon: Icons.signal_cellular_alt,
                  label:
                      strings.difficultyLabel(recipe.difficulty),
                ),
                _MetaPill(
                  icon: Icons.people_outline,
                  label:
                      '${recipe.servings} ${strings.servings.toLowerCase()}',
                ),
                if (recipe.antiWaste.enabled)
                  _MetaPill(
                    icon: Icons.eco_outlined,
                    label: strings.antiWaste,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            _TimePanel(recipe: recipe),
            if (recipe.antiWaste.enabled &&
                recipe.antiWaste.note.isNotEmpty) ...<Widget>[
              const SizedBox(height: 18),
              _SectionCard(
                icon: Icons.eco_outlined,
                title: strings.antiWaste,
                child: Text(recipe.antiWaste.note),
              ),
            ],
            const SizedBox(height: 18),
            _SectionCard(
              icon: Icons.shopping_basket_outlined,
              title: strings.ingredients,
              child: Column(
                children: recipe.ingredients
                    .map(
                      (RecipeIngredient ingredient) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 7),
                              child: Icon(Icons.circle, size: 6),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ingredient.amountText(
                                  metricUnits: metricUnits,
                                  languageCode: languageCode,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              icon: Icons.format_list_numbered,
              title: strings.preparation,
              child: Column(
                children: text.instructions.asMap().entries
                    .map(
                      (MapEntry<int, String> entry) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  scheme.primaryContainer,
                              child: Text(
                                '${entry.key + 1}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            if (text.chefTips.isNotEmpty) ...<Widget>[
              const SizedBox(height: 18),
              _SectionCard(
                icon: Icons.lightbulb_outline,
                title: strings.chefTips,
                child: Text(text.chefTips),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimePanel extends StatelessWidget {
  const _TimePanel({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            SizedBox(
              width: 120,
              child: _TimeValue(
                label: strings.prep,
                value: recipe.times.prepMinutes,
              ),
            ),
            SizedBox(
              width: 120,
              child: _TimeValue(
                label: strings.cook,
                value: recipe.times.cookMinutes,
              ),
            ),
            SizedBox(
              width: 120,
              child: _TimeValue(
                label: strings.rest,
                value: recipe.times.restMinutes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeValue extends StatelessWidget {
  const _TimeValue({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Column(
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '$value ${strings.minutes}',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
