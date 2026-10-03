import '../recipe/recipe.dart';
import '../search/full_text_recipe_index.dart';
import '../search/smart_recipe_query.dart';
import '../search/unified_recipe_retrieval_service.dart';

class AntiWasteSuggestion {
  const AntiWasteSuggestion({
    required this.recipe,
    required this.score,
    required this.coverage,
    required this.matchedTerms,
    required this.additionalIngredients,
    required this.scrapMatches,
  });

  final Recipe recipe;
  final double score;
  final double coverage;
  final List<String> matchedTerms;
  final List<String> additionalIngredients;
  final int scrapMatches;
}

class AntiWasteEngine {
  const AntiWasteEngine({
    required UnifiedRecipeRetrievalService retrievalService,
    SmartRecipeQueryParser queryParser = const SmartRecipeQueryParser(),
  })  : _retrievalService = retrievalService,
        _queryParser = queryParser;

  final UnifiedRecipeRetrievalService _retrievalService;
  final SmartRecipeQueryParser _queryParser;

  List<AntiWasteSuggestion> suggest({
    required String input,
    String languageCode = 'it',
    int limit = 8,
  }) {
    final SmartRecipeIntent intent = _queryParser.parse(
      input,
      languageCode: languageCode,
    );
    final List<String> terms = intent.foodTerms;
    if (terms.isEmpty || !_retrievalService.ready) {
      return const <AntiWasteSuggestion>[];
    }

    final Map<String, _SuggestionAccumulator> accumulators =
        <String, _SuggestionAccumulator>{};

    for (final String term in terms) {
      final Map<String, RecipeRetrievalHit> bestForTerm =
          <String, RecipeRetrievalHit>{};
      for (final String variant in _variants(term)) {
        final List<RecipeRetrievalHit> hits = _retrievalService.search(
          RecipeRetrievalQuery(
            text: variant,
            languageCode: languageCode,
            antiWasteOnly: true,
            limit: 80,
          ),
        );
        for (final RecipeRetrievalHit hit in hits) {
          final RecipeRetrievalHit? current = bestForTerm[hit.recipe.id];
          if (current == null || hit.score > current.score) {
            bestForTerm[hit.recipe.id] = hit;
          }
        }
      }

      for (final RecipeRetrievalHit hit in bestForTerm.values) {
        final _SuggestionAccumulator accumulator =
            accumulators.putIfAbsent(
          hit.recipe.id,
          () => _SuggestionAccumulator(hit.recipe),
        );
        accumulator.matchedTerms.add(term);
        accumulator.retrievalScore += hit.score;
      }
    }

    final List<AntiWasteSuggestion> suggestions = <AntiWasteSuggestion>[];
    for (final _SuggestionAccumulator accumulator in accumulators.values) {
      final Recipe recipe = accumulator.recipe;
      if (!recipe.antiWaste.enabled || accumulator.matchedTerms.isEmpty) {
        continue;
      }

      int scrapMatches = 0;
      final String scrapText = normalizeSearchText(
        <String>[
          ...recipe.antiWaste.usesScraps,
          recipe.antiWaste.note,
        ].join(' '),
      );
      for (final String term in accumulator.matchedTerms) {
        if (_variants(term).any(scrapText.contains)) {
          scrapMatches += 1;
        }
      }

      final double coverage =
          accumulator.matchedTerms.length / terms.length;
      final List<String> additional = _additionalIngredients(
        recipe,
        terms,
        languageCode,
      );
      final double score =
          (coverage * 1000) +
          (scrapMatches * 120) +
          (accumulator.retrievalScore.clamp(0, 600) / 6) -
          (additional.length * 2);

      suggestions.add(
        AntiWasteSuggestion(
          recipe: recipe,
          score: score,
          coverage: coverage,
          matchedTerms: accumulator.matchedTerms.toList(growable: false)
            ..sort(),
          additionalIngredients: additional,
          scrapMatches: scrapMatches,
        ),
      );
    }

    suggestions.sort((AntiWasteSuggestion a, AntiWasteSuggestion b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final int byTime =
          a.recipe.times.totalMinutes.compareTo(b.recipe.times.totalMinutes);
      if (byTime != 0) return byTime;
      return a.recipe.id.compareTo(b.recipe.id);
    });

    if (limit >= 0 && suggestions.length > limit) {
      return suggestions.take(limit).toList(growable: false);
    }
    return suggestions;
  }

  static List<String> _variants(String term) {
    final List<String> values = <String>[term];
    if (term.length >= 5 &&
        const <String>['a', 'e', 'i', 'o'].contains(term[term.length - 1])) {
      values.add(term.substring(0, term.length - 1));
    }
    return values;
  }

  static List<String> _additionalIngredients(
    Recipe recipe,
    List<String> availableTerms,
    String languageCode,
  ) {
    final List<String> values = <String>[];
    for (final RecipeIngredient ingredient in recipe.ingredients) {
      final String name = ingredient.nameFor(languageCode);
      final String normalized = normalizeSearchText(
        <String>[
          ingredient.ingredientId,
          name,
          ingredient.nameFor('it'),
          ingredient.nameFor('en'),
        ].join(' '),
      );
      final bool matched = availableTerms.any(
        (String term) => _variants(term).any(
          (String variant) =>
              normalized.contains(variant) || variant.contains(normalized),
        ),
      );
      if (matched) continue;
      if (name.isEmpty || values.contains(name)) continue;
      values.add(name);
      if (values.length >= 4) break;
    }
    return values;
  }
}

class _SuggestionAccumulator {
  _SuggestionAccumulator(this.recipe);

  final Recipe recipe;
  final Set<String> matchedTerms = <String>{};
  double retrievalScore = 0;
}
