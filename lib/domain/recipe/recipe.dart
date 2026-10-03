class LocalizedRecipeText {
  const LocalizedRecipeText({
    required this.title,
    required this.instructions,
    this.summary = '',
    this.chefTips = '',
  });

  final String title;
  final String summary;
  final List<String> instructions;
  final String chefTips;

  factory LocalizedRecipeText.fromJson(Map<String, Object?> json) {
    return LocalizedRecipeText(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      instructions: _stringList(json['instructions']),
      chefTips: json['chefTips'] as String? ?? '',
    );
  }
}

class IngredientAmount {
  const IngredientAmount({
    this.quantity,
    this.unit = '',
    this.raw = '',
  });

  final double? quantity;
  final String unit;
  final String raw;

  factory IngredientAmount.fromJson(Map<String, Object?> json) {
    return IngredientAmount(
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String? ?? '',
      raw: json['raw'] as String? ?? '',
    );
  }
}

class RecipeIngredient {
  const RecipeIngredient({
    required this.ingredientId,
    required this.localizedNames,
    required this.metric,
    required this.imperial,
    this.optional = false,
    this.normalizationConfidence = 'low',
  });

  final String ingredientId;
  final Map<String, String> localizedNames;
  final IngredientAmount metric;
  final IngredientAmount imperial;
  final bool optional;
  final String normalizationConfidence;

  String nameFor(String languageCode) {
    return localizedNames[languageCode] ?? localizedNames['en'] ?? localizedNames['it'] ?? ingredientId;
  }

  String amountText({required bool metricUnits, required String languageCode}) {
    final IngredientAmount value = metricUnits ? metric : imperial;
    final String quantity = value.quantity == null ? '' : _formatQuantity(value.quantity!);
    final String prefix = <String>[quantity, value.unit].where((String part) => part.isNotEmpty).join(' ');
    final String localizedName = nameFor(languageCode);
    if (prefix.isNotEmpty) {
      return <String>[prefix, localizedName].where((String part) => part.isNotEmpty).join(' ');
    }
    if (localizedName.isNotEmpty) return localizedName;
    return value.raw;
  }

  factory RecipeIngredient.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> names = _stringObjectMap(json['localizedNames']);
    return RecipeIngredient(
      ingredientId: json['ingredientId'] as String? ?? '',
      localizedNames: names.map(
        (String key, Object? value) => MapEntry<String, String>(key, value?.toString() ?? ''),
      ),
      metric: IngredientAmount.fromJson(_stringObjectMap(json['metric'])),
      imperial: IngredientAmount.fromJson(_stringObjectMap(json['imperial'])),
      optional: json['optional'] as bool? ?? false,
      normalizationConfidence: json['normalizationConfidence'] as String? ?? 'low',
    );
  }
}

class RecipeTimes {
  const RecipeTimes({
    required this.prepMinutes,
    required this.cookMinutes,
    required this.restMinutes,
  });

  final int prepMinutes;
  final int cookMinutes;
  final int restMinutes;

  int get totalMinutes => prepMinutes + cookMinutes + restMinutes;

  factory RecipeTimes.fromJson(Map<String, Object?> json) {
    return RecipeTimes(
      prepMinutes: (json['prepMinutes'] as num?)?.toInt() ?? 0,
      cookMinutes: (json['cookMinutes'] as num?)?.toInt() ?? 0,
      restMinutes: (json['restMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class AntiWasteInfo {
  const AntiWasteInfo({
    required this.enabled,
    this.usesScraps = const <String>[],
    this.note = '',
  });

  final bool enabled;
  final List<String> usesScraps;
  final String note;

  factory AntiWasteInfo.fromJson(Map<String, Object?> json) {
    return AntiWasteInfo(
      enabled: json['enabled'] as bool? ?? false,
      usesScraps: _stringList(json['usesScraps']),
      note: json['note'] as String? ?? '',
    );
  }
}

class RecipeSource {
  const RecipeSource({
    required this.sourceId,
    this.sourceTitle = '',
    this.originalTitle = '',
    this.repository = '',
    this.ref = '',
    this.baselineCommit = '',
    this.sourceFile = '',
  });

  final String sourceId;
  final String sourceTitle;
  final String originalTitle;
  final String repository;
  final String ref;
  final String baselineCommit;
  final String sourceFile;

  factory RecipeSource.fromJson(Map<String, Object?> json) {
    return RecipeSource(
      sourceId: json['sourceId'] as String? ?? '',
      sourceTitle: json['sourceTitle'] as String? ?? '',
      originalTitle: json['originalTitle'] as String? ?? '',
      repository: json['repository'] as String? ?? '',
      ref: json['ref'] as String? ?? '',
      baselineCommit: json['baselineCommit'] as String? ?? '',
      sourceFile: json['sourceFile'] as String? ?? '',
    );
  }
}

class Recipe {
  const Recipe({
    required this.id,
    required this.slug,
    required this.localized,
    required this.ingredients,
    required this.category,
    required this.times,
    required this.difficulty,
    required this.servings,
    required this.antiWaste,
    required this.premiumTier,
    this.status = 'ready',
    this.subcategories = const <String>[],
    this.tags = const <String>[],
    this.techniques = const <String>[],
    this.diets = const <String>[],
    this.allergens = const <String>[],
    this.searchAliases = const <String>[],
    this.source,
  });

  final String id;
  final String slug;
  final Map<String, LocalizedRecipeText> localized;
  final List<RecipeIngredient> ingredients;
  final String category;
  final List<String> subcategories;
  final List<String> tags;
  final List<String> techniques;
  final List<String> diets;
  final List<String> allergens;
  final RecipeTimes times;
  final String difficulty;
  final int servings;
  final AntiWasteInfo antiWaste;
  final String premiumTier;
  final String status;
  final List<String> searchAliases;
  final RecipeSource? source;

  LocalizedRecipeText textFor(String languageCode) {
    return localized[languageCode] ?? localized['en'] ?? localized['it'] ?? localized.values.first;
  }

  factory Recipe.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> localizedJson = _stringObjectMap(json['localized']);
    return Recipe(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      localized: localizedJson.map(
        (String language, Object? value) => MapEntry<String, LocalizedRecipeText>(
          language,
          LocalizedRecipeText.fromJson(_stringObjectMap(value)),
        ),
      ),
      ingredients: (json['ingredients'] as List<Object?>? ?? const <Object?>[])
          .whereType<Map<Object?, Object?>>()
          .map((Map<Object?, Object?> item) => RecipeIngredient.fromJson(
                item.map((Object? key, Object? value) => MapEntry<String, Object?>(key.toString(), value)),
              ))
          .toList(growable: false),
      category: json['category'] as String? ?? '',
      subcategories: _stringList(json['subcategories']),
      tags: _stringList(json['tags']),
      techniques: _stringList(json['techniques']),
      diets: _stringList(json['diets']),
      allergens: _stringList(json['allergens']),
      times: RecipeTimes.fromJson(_stringObjectMap(json['times'])),
      difficulty: json['difficulty'] as String? ?? 'medium',
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      antiWaste: AntiWasteInfo.fromJson(_stringObjectMap(json['antiWaste'])),
      premiumTier: json['premiumTier'] as String? ?? 'free',
      status: json['status'] as String? ?? 'ready',
      searchAliases: _stringList(json['searchAliases']),
      source: json['source'] is Map<Object?, Object?> ? RecipeSource.fromJson(_stringObjectMap(json['source'])) : null,
    );
  }
}

String _formatQuantity(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

List<String> _stringList(Object? value) {
  return (value as List<Object?>? ?? const <Object?>[]).whereType<String>().toList(growable: false);
}

Map<String, Object?> _stringObjectMap(Object? value) {
  if (value is! Map<Object?, Object?>) return const <String, Object?>{};
  return value.map((Object? key, Object? nested) => MapEntry<String, Object?>(key.toString(), nested));
}
