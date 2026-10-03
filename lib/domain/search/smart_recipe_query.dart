import 'dart:math' as math;

import 'full_text_recipe_index.dart';

class SmartRecipeIntent {
  const SmartRecipeIntent({
    required this.originalText,
    required this.retrievalText,
    required this.foodTerms,
    this.maxMinutes,
    this.category,
    this.antiWasteOnly = false,
    this.requiredDiets = const <String>{},
    this.excludedAllergens = const <String>{},
    this.requiredTechniques = const <String>{},
  });

  final String originalText;
  final String retrievalText;
  final List<String> foodTerms;
  final int? maxMinutes;
  final String? category;
  final bool antiWasteOnly;
  final Set<String> requiredDiets;
  final Set<String> excludedAllergens;
  final Set<String> requiredTechniques;
}

class SmartRecipeQueryParser {
  const SmartRecipeQueryParser();

  static const Set<String> _stopWords = <String>{
    'a',
    'ad',
    'al',
    'alla',
    'alle',
    'allo',
    'con',
    'da',
    'dal',
    'dalla',
    'de',
    'dei',
    'del',
    'della',
    'di',
    'e',
    'ed',
    'ho',
    'il',
    'in',
    'la',
    'le',
    'lo',
    'mi',
    'per',
    'prepara',
    'preparare',
    'preparo',
    'qualcosa',
    'ricetta',
    'ricette',
    'the',
    'with',
    'and',
    'or',
    'of',
    'for',
    'make',
    'cook',
    'recipe',
    'recipes',
    'i',
    'have',
    'quiero',
    'una',
    'un',
    'une',
    'avec',
    'et',
    'je',
    'veux',
    'receita',
    'receitas',
    'com',
    'uma',
    'um',
    'quero',
    'due',
    'tre',
    'quattro',
    'cinque',
    'two',
    'three',
    'four',
    'five',
  };

  static const Set<String> _quantityUnits = <String>{
    'g',
    'gr',
    'grammi',
    'grammo',
    'kg',
    'ml',
    'cl',
    'dl',
    'l',
    'litri',
    'litro',
    'cucchiaio',
    'cucchiai',
    'cucchiaino',
    'cucchiaini',
    'tbsp',
    'tsp',
    'oz',
    'lb',
  };

  static const Map<String, String> _conceptAliases = <String, String>{
    'zucchina': 'zucchine',
    'zucchine': 'zucchine',
    'zucchini': 'zucchine',
    'courgette': 'zucchine',
    'courgettes': 'zucchine',
    'patata': 'patate',
    'patate': 'patate',
    'potato': 'patate',
    'potatoes': 'patate',
    'pomodori': 'pomodoro',
    'tomato': 'pomodoro',
    'tomatoes': 'pomodoro',
    'uovo': 'uova',
    'uova': 'uova',
    'egg': 'uova',
    'eggs': 'uova',
    'fungo': 'funghi',
    'funghi': 'funghi',
    'mushroom': 'funghi',
    'mushrooms': 'funghi',
    'melanzana': 'melanzane',
    'melanzane': 'melanzane',
    'eggplant': 'melanzane',
    'aubergine': 'melanzane',
    'carciofo': 'carciofi',
    'carciofi': 'carciofi',
    'artichoke': 'carciofi',
    'artichokes': 'carciofi',
    'salmone': 'salmone',
    'salmon': 'salmone',
    'tonno': 'tonno',
    'tuna': 'tonno',
    'gambero': 'gamberi',
    'gamberi': 'gamberi',
    'shrimp': 'gamberi',
    'prawn': 'gamberi',
    'prawns': 'gamberi',
    'ricotta': 'ricotta',
    'pane': 'pane',
    'bread': 'pane',
    'pasta': 'pasta',
    'riso': 'riso',
    'rice': 'riso',
    'zucca': 'zucca',
    'pumpkin': 'zucca',
    'cioccolata': 'cioccolato',
    'cioccolato': 'cioccolato',
    'chocolate': 'cioccolato',
    'pollo': 'pollo',
    'chicken': 'pollo',
    'manzo': 'manzo',
    'beef': 'manzo',
    'maiale': 'maiale',
    'pork': 'maiale',
  };

  SmartRecipeIntent parse(
    String rawText, {
    String languageCode = 'it',
  }) {
    String working = normalizeSearchText(rawText);
    int? maxMinutes;
    String? category;
    bool antiWasteOnly = false;
    final Set<String> requiredDiets = <String>{};
    final Set<String> excludedAllergens = <String>{};
    final Set<String> requiredTechniques = <String>{};

    final RegExp explicitMinutes = RegExp(
      r'(?:(?:meno di|entro|massimo|max|under|within|less than)\s*)?(\d{1,3})\s*(?:minuti|minutes|minute|min)',
    );
    final Iterable<RegExpMatch> minuteMatches = explicitMinutes.allMatches(working);
    for (final RegExpMatch match in minuteMatches) {
      final int? parsed = int.tryParse(match.group(1) ?? '');
      if (parsed != null && parsed > 0 && parsed <= 1440) {
        maxMinutes = maxMinutes == null ? parsed : math.min(maxMinutes, parsed);
      }
    }
    working = working.replaceAll(explicitMinutes, ' ');

    if (_containsAny(working, const <String>[
      'veloce',
      'veloci',
      'rapida',
      'rapido',
      'quick',
      'fast',
      'poco tempo',
    ])) {
      maxMinutes = maxMinutes == null ? 30 : math.min(maxMinutes, 30);
      working = _removePhrases(
        working,
        const <String>['veloce', 'veloci', 'rapida', 'rapido', 'quick', 'fast', 'poco tempo'],
      );
    }

    final Map<String, String> categories = <String, String>{
      'antipasto': 'starter',
      'starter': 'starter',
      'primo': 'first_course',
      'first course': 'first_course',
      'secondo': 'main_course',
      'main course': 'main_course',
      'contorno': 'side',
      'side dish': 'side',
      'dessert': 'dessert',
      'dolce': 'dessert',
      'dolci': 'dessert',
    };
    for (final MapEntry<String, String> entry in categories.entries) {
      if (_containsPhrase(working, entry.key)) {
        category ??= entry.value;
        working = _removePhrases(working, <String>[entry.key]);
      }
    }

    final Map<String, String> diets = <String, String>{
      'vegano': 'vegan',
      'vegana': 'vegan',
      'vegan': 'vegan',
      'vegetariano': 'vegetarian',
      'vegetariana': 'vegetarian',
      'vegetarian': 'vegetarian',
    };
    for (final MapEntry<String, String> entry in diets.entries) {
      if (_containsPhrase(working, entry.key)) {
        requiredDiets.add(entry.value);
        working = _removePhrases(working, <String>[entry.key]);
      }
    }

    final Map<String, String> allergenExclusions = <String, String>{
      'senza glutine': 'gluten',
      'gluten free': 'gluten',
      'senza latte': 'milk',
      'senza latticini': 'milk',
      'dairy free': 'milk',
      'senza uova': 'eggs',
      'egg free': 'eggs',
      'senza frutta secca': 'tree_nuts',
      'nut free': 'tree_nuts',
      'senza soia': 'soy',
      'soy free': 'soy',
      'senza sesamo': 'sesame',
      'sesame free': 'sesame',
      'senza pesce': 'fish',
      'senza crostacei': 'crustaceans',
    };
    for (final MapEntry<String, String> entry in allergenExclusions.entries) {
      if (_containsPhrase(working, entry.key)) {
        excludedAllergens.add(entry.value);
        working = _removePhrases(working, <String>[entry.key]);
      }
    }

    final Map<String, String> techniques = <String, String>{
      'friggitrice ad aria': 'air_fryer',
      'air fryer': 'air_fryer',
      'forno': 'baking',
      'al forno': 'baking',
      'baked': 'baking',
      'sottovuoto': 'sous_vide',
      'sous vide': 'sous_vide',
      'cbt': 'sous_vide',
      'griglia': 'grilling',
      'grill': 'grilling',
      'vapore': 'steaming',
      'steam': 'steaming',
    };
    for (final MapEntry<String, String> entry in techniques.entries) {
      if (_containsPhrase(working, entry.key)) {
        requiredTechniques.add(entry.value);
        working = _removePhrases(working, <String>[entry.key]);
      }
    }

    if (_containsAny(
      working,
      const <String>[
        'anti spreco',
        'antispreco',
        'avanzi',
        'avanzo',
        'scarti',
        'scarto',
        'recupero',
        'leftover',
        'leftovers',
        'scraps',
      ],
    )) {
      antiWasteOnly = true;
      working = _removePhrases(
        working,
        const <String>[
          'anti spreco',
          'antispreco',
          'avanzi',
          'avanzo',
          'scarti',
          'scarto',
          'recupero',
          'leftover',
          'leftovers',
          'scraps',
        ],
      );
    }

    final List<String> foodTerms = <String>[];
    for (final String token in tokenizeSearchText(working)) {
      if (_stopWords.contains(token)) continue;
      if (_quantityUnits.contains(token)) continue;
      if (RegExp(r'^\d+(?:[.,]\d+)?$').hasMatch(token)) continue;
      foodTerms.add(_conceptAliases[token] ?? token);
    }

    final List<String> deduplicated = <String>[];
    for (final String term in foodTerms) {
      if (!deduplicated.contains(term)) deduplicated.add(term);
    }

    return SmartRecipeIntent(
      originalText: rawText,
      retrievalText: deduplicated.join(' '),
      foodTerms: List<String>.unmodifiable(deduplicated),
      maxMinutes: maxMinutes,
      category: category,
      antiWasteOnly: antiWasteOnly,
      requiredDiets: Set<String>.unmodifiable(requiredDiets),
      excludedAllergens: Set<String>.unmodifiable(excludedAllergens),
      requiredTechniques: Set<String>.unmodifiable(requiredTechniques),
    );
  }

  static bool _containsAny(String input, Iterable<String> phrases) {
    return phrases.any((String phrase) => _containsPhrase(input, phrase));
  }

  static bool _containsPhrase(String input, String phrase) {
    final String normalized = normalizeSearchText(phrase);
    return RegExp('(?:^| )${RegExp.escape(normalized)}(?: |\$)').hasMatch(input);
  }

  static String _removePhrases(String input, Iterable<String> phrases) {
    String value = input;
    for (final String phrase in phrases) {
      final String normalized = normalizeSearchText(phrase);
      value = value.replaceAll(
        RegExp('(?:^| )${RegExp.escape(normalized)}(?= |\$)'),
        ' ',
      );
    }
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
