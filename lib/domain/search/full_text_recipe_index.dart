import 'dart:convert';

import '../recipe/recipe.dart';

class RecipeIndexHit {
  const RecipeIndexHit({
    required this.recipeId,
    required this.score,
  });

  final String recipeId;
  final double score;
}

class FullTextRecipeIndex {
  FullTextRecipeIndex._({
    required Map<String, Recipe> recipesById,
    required Map<String, Map<String, double>> postings,
    required Map<String, _IndexedRecipeDocument> documents,
  })  : _recipesById = recipesById,
        _postings = postings,
        _documents = documents;

  final Map<String, Recipe> _recipesById;
  final Map<String, Map<String, double>> _postings;
  final Map<String, _IndexedRecipeDocument> _documents;

  int get recipeCount => _recipesById.length;
  int get termCount => _postings.length;

  static FullTextRecipeIndex build(Iterable<Recipe> recipes) {
    final Map<String, Recipe> recipesById = <String, Recipe>{
      for (final Recipe recipe in recipes) recipe.id: recipe,
    };
    final Map<String, Map<String, double>> postings = <String, Map<String, double>>{};
    final Map<String, _IndexedRecipeDocument> documents = <String, _IndexedRecipeDocument>{};

    for (final Recipe recipe in recipesById.values) {
      final List<String> titles = recipe.localized.values
          .map((LocalizedRecipeText value) => value.title)
          .where((String value) => value.isNotEmpty)
          .toList(growable: false);
      final List<String> ingredientNames = recipe.ingredients
          .expand(
            (RecipeIngredient ingredient) => <String>[
              ingredient.ingredientId,
              ...ingredient.localizedNames.values,
            ],
          )
          .where((String value) => value.isNotEmpty)
          .toList(growable: false);
      final List<String> body = recipe.localized.values
          .expand(
            (LocalizedRecipeText value) => <String>[
              value.summary,
              value.chefTips,
              ...value.instructions,
            ],
          )
          .where((String value) => value.isNotEmpty)
          .toList(growable: false);

      final _IndexedRecipeDocument document = _IndexedRecipeDocument(
        title: normalizeSearchText(titles.join(' ')),
        ingredients: normalizeSearchText(ingredientNames.join(' ')),
      );
      documents[recipe.id] = document;

      _indexField(postings, recipe.id, titles, 60);
      _indexField(postings, recipe.id, ingredientNames, 44);
      _indexField(postings, recipe.id, recipe.searchAliases, 38);
      _indexField(postings, recipe.id, recipe.tags, 30);
      _indexField(postings, recipe.id, recipe.techniques, 26);
      _indexField(
        postings,
        recipe.id,
        <String>[
          recipe.category,
          recipe.difficulty,
          ...recipe.subcategories,
          ...recipe.diets,
          ...recipe.allergens,
        ],
        20,
      );
      _indexField(postings, recipe.id, body, 8);
    }

    return FullTextRecipeIndex._(
      recipesById: recipesById,
      postings: postings,
      documents: documents,
    );
  }

  static FullTextRecipeIndex? restore({
    required String encodedSnapshot,
    required Iterable<Recipe> recipes,
    required String expectedSignature,
  }) {
    try {
      final Object? decoded = jsonDecode(encodedSnapshot);
      if (decoded is! Map<Object?, Object?>) return null;
      final Map<String, Object?> root = _stringObjectMap(decoded);
      if (root['v'] != 1 || root['s'] != expectedSignature) return null;

      final Map<String, Recipe> recipesById = <String, Recipe>{
        for (final Recipe recipe in recipes) recipe.id: recipe,
      };
      final Map<String, Object?> rawPostings = _stringObjectMap(root['p']);
      final Map<String, Map<String, double>> postings = <String, Map<String, double>>{};
      for (final MapEntry<String, Object?> entry in rawPostings.entries) {
        final List<Object?> rows = entry.value as List<Object?>? ?? const <Object?>[];
        final Map<String, double> termPostings = <String, double>{};
        for (final Object? row in rows) {
          if (row is! List<Object?> || row.length < 2) continue;
          final String id = row[0]?.toString() ?? '';
          final double? weight = (row[1] as num?)?.toDouble();
          if (id.isNotEmpty && weight != null && recipesById.containsKey(id)) {
            termPostings[id] = weight;
          }
        }
        if (termPostings.isNotEmpty) postings[entry.key] = termPostings;
      }

      final Map<String, Object?> rawDocuments = _stringObjectMap(root['d']);
      final Map<String, _IndexedRecipeDocument> documents = <String, _IndexedRecipeDocument>{};
      for (final MapEntry<String, Object?> entry in rawDocuments.entries) {
        if (!recipesById.containsKey(entry.key)) continue;
        final List<Object?> row = entry.value as List<Object?>? ?? const <Object?>[];
        documents[entry.key] = _IndexedRecipeDocument(
          title: row.isNotEmpty ? row[0]?.toString() ?? '' : '',
          ingredients: row.length > 1 ? row[1]?.toString() ?? '' : '',
        );
      }

      if (documents.length != recipesById.length) return null;
      return FullTextRecipeIndex._(
        recipesById: recipesById,
        postings: postings,
        documents: documents,
      );
    } catch (_) {
      return null;
    }
  }

  String encodeSnapshot(String signature) {
    final Map<String, Object?> root = <String, Object?>{
      'v': 1,
      's': signature,
      'p': <String, Object?>{
        for (final MapEntry<String, Map<String, double>> term in _postings.entries)
          term.key: <Object?>[
            for (final MapEntry<String, double> posting in term.value.entries)
              <Object?>[posting.key, posting.value],
          ],
      },
      'd': <String, Object?>{
        for (final MapEntry<String, _IndexedRecipeDocument> entry in _documents.entries)
          entry.key: <Object?>[entry.value.title, entry.value.ingredients],
      },
    };
    return jsonEncode(root);
  }

  List<RecipeIndexHit> query(String rawQuery) {
    final String normalizedQuery = normalizeSearchText(rawQuery);
    final List<String> tokens = tokenizeSearchText(normalizedQuery);
    if (tokens.isEmpty) {
      return _recipesById.keys
          .map((String id) => RecipeIndexHit(recipeId: id, score: 0))
          .toList(growable: false);
    }

    Map<String, double>? aggregate;
    for (final String token in tokens) {
      final Map<String, double> matches = _postingsForToken(token);
      if (matches.isEmpty) return const <RecipeIndexHit>[];

      if (aggregate == null) {
        aggregate = Map<String, double>.from(matches);
      } else {
        final List<String> ids = aggregate.keys.toList(growable: false);
        for (final String id in ids) {
          final double? score = matches[id];
          if (score == null) {
            aggregate.remove(id);
          } else {
            aggregate[id] = aggregate[id]! + score;
          }
        }
      }
      if (aggregate.isEmpty) return const <RecipeIndexHit>[];
    }

    final List<RecipeIndexHit> hits = <RecipeIndexHit>[];
    for (final MapEntry<String, double> entry in aggregate!.entries) {
      final _IndexedRecipeDocument? document = _documents[entry.key];
      if (document == null) continue;
      double score = entry.value;
      if (document.title == normalizedQuery) {
        score += 120;
      } else if (document.title.startsWith(normalizedQuery)) {
        score += 70;
      } else if (document.title.contains(normalizedQuery)) {
        score += 35;
      }
      if (document.ingredients.contains(normalizedQuery)) score += 18;
      hits.add(RecipeIndexHit(recipeId: entry.key, score: score));
    }

    hits.sort((RecipeIndexHit a, RecipeIndexHit b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.recipeId.compareTo(b.recipeId);
    });
    return hits;
  }

  Map<String, double> _postingsForToken(String token) {
    final Map<String, double> matches = <String, double>{};
    final Map<String, double>? exact = _postings[token];
    if (exact != null) {
      for (final MapEntry<String, double> entry in exact.entries) {
        matches[entry.key] = (matches[entry.key] ?? 0) + entry.value;
      }
    }

    if (token.length < 2) return matches;
    int prefixTerms = 0;
    for (final MapEntry<String, Map<String, double>> term in _postings.entries) {
      if (term.key == token || !term.key.startsWith(token)) continue;
      prefixTerms += 1;
      if (prefixTerms > 160) break;
      for (final MapEntry<String, double> entry in term.value.entries) {
        final double prefixWeight = entry.value * 0.82;
        final double current = matches[entry.key] ?? 0;
        if (prefixWeight > current) matches[entry.key] = prefixWeight;
      }
    }
    return matches;
  }

  static void _indexField(
    Map<String, Map<String, double>> postings,
    String recipeId,
    Iterable<String> values,
    double weight,
  ) {
    final Set<String> tokens = <String>{};
    for (final String value in values) {
      tokens.addAll(tokenizeSearchText(value));
    }
    for (final String token in tokens) {
      final Map<String, double> termPostings = postings.putIfAbsent(token, () => <String, double>{});
      final double current = termPostings[recipeId] ?? 0;
      if (weight > current) termPostings[recipeId] = weight;
    }
  }
}

class _IndexedRecipeDocument {
  const _IndexedRecipeDocument({
    required this.title,
    required this.ingredients,
  });

  final String title;
  final String ingredients;
}

String recipeIndexSignature(Iterable<Recipe> recipes, int catalogVersion) {
  final List<Recipe> sorted = recipes.toList(growable: false)
    ..sort((Recipe a, Recipe b) => a.id.compareTo(b.id));
  final String source = <String>[
    catalogVersion.toString(),
    for (final Recipe recipe in sorted)
      <String>[
        recipe.id,
        recipe.slug,
        recipe.status,
        recipe.localized.values.map((LocalizedRecipeText text) => text.title).join('|'),
        recipe.ingredients.map((RecipeIngredient item) => item.ingredientId).join('|'),
        recipe.tags.join('|'),
        recipe.techniques.join('|'),
      ].join('~'),
  ].join('||');

  int hash = 0x811c9dc5;
  for (final int codeUnit in source.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

List<String> tokenizeSearchText(String input) {
  final String normalized = normalizeSearchText(input);
  if (normalized.isEmpty) return const <String>[];
  return normalized
      .split(' ')
      .where((String token) => token.length > 1 || RegExp(r'^\d+$').hasMatch(token))
      .toList(growable: false);
}

String normalizeSearchText(String input) {
  const Map<String, String> replacements = <String, String>{
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ä': 'a',
    'ã': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'ö': 'o',
    'õ': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
  };
  String value = input.toLowerCase().trim();
  replacements.forEach((String source, String target) {
    value = value.replaceAll(source, target);
  });
  return value
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

Map<String, Object?> _stringObjectMap(Object? value) {
  if (value is! Map<Object?, Object?>) return const <String, Object?>{};
  return value.map(
    (Object? key, Object? nested) => MapEntry<String, Object?>(key.toString(), nested),
  );
}
