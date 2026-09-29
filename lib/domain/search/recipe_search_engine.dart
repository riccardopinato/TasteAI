import '../recipe/recipe.dart';

class RecipeSearchHit {
  const RecipeSearchHit({required this.recipe, required this.score});

  final Recipe recipe;
  final double score;
}

class RecipeSearchEngine {
  const RecipeSearchEngine();

  List<RecipeSearchHit> search({
    required Iterable<Recipe> recipes,
    required String query,
    required String languageCode,
    int? maxMinutes,
    String? category,
    String? difficulty,
    bool antiWasteOnly = false,
    Set<String> requiredDiets = const <String>{},
  }) {
    final String normalizedQuery = normalize(query);
    final List<String> tokens = normalizedQuery.split(' ').where((String token) => token.isNotEmpty).toList(growable: false);
    final List<RecipeSearchHit> hits = <RecipeSearchHit>[];

    for (final Recipe recipe in recipes) {
      if (maxMinutes != null && recipe.times.totalMinutes > maxMinutes) continue;
      if (category != null && category.isNotEmpty && normalize(recipe.category) != normalize(category)) continue;
      if (difficulty != null && difficulty.isNotEmpty && normalize(recipe.difficulty) != normalize(difficulty)) continue;
      if (antiWasteOnly && !recipe.antiWaste.enabled) continue;
      final Set<String> normalizedDiets = recipe.diets.map(normalize).toSet();
      if (!requiredDiets.map(normalize).every(normalizedDiets.contains)) continue;

      if (tokens.isEmpty) {
        hits.add(RecipeSearchHit(recipe: recipe, score: 0));
        continue;
      }

      final LocalizedRecipeText text = recipe.textFor(languageCode);
      final String title = normalize(text.title);
      final String aliases = normalize(recipe.searchAliases.join(' '));
      final String ingredients = normalize(
        recipe.ingredients
            .expand((RecipeIngredient item) => <String>[
                  item.ingredientId,
                  item.nameFor(languageCode),
                  item.nameFor('it'),
                  item.nameFor('en'),
                ])
            .join(' '),
      );
      final String tags = normalize(recipe.tags.join(' '));
      final String techniques = normalize(recipe.techniques.join(' '));
      final String metadata = normalize(<String>[
        recipe.category,
        recipe.difficulty,
        ...recipe.subcategories,
        ...recipe.diets,
        ...recipe.allergens,
      ].join(' '));
      final String body = normalize(<String>[
        text.summary,
        text.chefTips,
        ...text.instructions,
      ].join(' '));

      double score = 0;
      bool everyTokenMatched = true;
      for (final String token in tokens) {
        double tokenScore = 0;
        if (title == normalizedQuery) tokenScore = 120;
        if (title.startsWith(token)) tokenScore = tokenScore < 70 ? 70 : tokenScore;
        if (title.contains(token)) tokenScore = tokenScore < 55 ? 55 : tokenScore;
        if (ingredients.contains(token)) tokenScore = tokenScore < 45 ? 45 : tokenScore;
        if (aliases.contains(token)) tokenScore = tokenScore < 40 ? 40 : tokenScore;
        if (tags.contains(token)) tokenScore = tokenScore < 32 ? 32 : tokenScore;
        if (techniques.contains(token)) tokenScore = tokenScore < 28 ? 28 : tokenScore;
        if (metadata.contains(token)) tokenScore = tokenScore < 22 ? 22 : tokenScore;
        if (body.contains(token)) tokenScore = tokenScore < 10 ? 10 : tokenScore;
        if (tokenScore == 0) {
          everyTokenMatched = false;
          break;
        }
        score += tokenScore;
      }
      if (!everyTokenMatched) continue;
      if (title.contains(normalizedQuery)) score += 30;
      if (ingredients.contains(normalizedQuery)) score += 15;
      hits.add(RecipeSearchHit(recipe: recipe, score: score));
    }

    hits.sort((RecipeSearchHit a, RecipeSearchHit b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.recipe.id.compareTo(b.recipe.id);
    });
    return hits;
  }

  static String normalize(String input) {
    const Map<String, String> replacements = <String, String>{
      'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n',
    };
    String value = input.toLowerCase().trim();
    replacements.forEach((String source, String target) {
      value = value.replaceAll(source, target);
    });
    return value.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
