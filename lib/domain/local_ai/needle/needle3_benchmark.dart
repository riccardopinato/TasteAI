import 'dart:convert';

import '../local_ai_models.dart';
import '../local_intelligence_runtime.dart';

class Needle3IntentExpectation {
  const Needle3IntentExpectation({
    required this.input,
    this.requiredIngredients = const <String>{},
    this.maxMinutes,
    this.category,
    this.requiredDiet = const <String>{},
    this.excludedAllergens = const <String>{},
    this.requiredTechniques = const <String>{},
    this.antiWaste,
  });

  final String input;
  final Set<String> requiredIngredients;
  final int? maxMinutes;
  final String? category;
  final Set<String> requiredDiet;
  final Set<String> excludedAllergens;
  final Set<String> requiredTechniques;
  final bool? antiWaste;
}

class Needle3BenchmarkResult {
  const Needle3BenchmarkResult({
    required this.total,
    required this.passed,
    required this.failedInputs,
  });

  final int total;
  final int passed;
  final List<String> failedInputs;

  double get passRate => total == 0 ? 0 : passed / total;
}

class Needle3BenchmarkHarness {
  const Needle3BenchmarkHarness(this.runtime);

  final LocalIntelligenceRuntime runtime;

  Future<Needle3BenchmarkResult> runIntentSuite(
    Iterable<Needle3IntentExpectation> cases,
  ) async {
    int total = 0;
    int passed = 0;
    final List<String> failed = <String>[];

    for (final Needle3IntentExpectation testCase in cases) {
      total += 1;
      final LocalAiResult result = await runtime.run(
        LocalAiRequest(
          task: LocalAiTask.interpretQuery,
          input: testCase.input,
        ),
      );
      if (!result.success || !_matches(result.text, testCase)) {
        failed.add(testCase.input);
      } else {
        passed += 1;
      }
    }

    return Needle3BenchmarkResult(
      total: total,
      passed: passed,
      failedInputs: List<String>.unmodifiable(failed),
    );
  }

  static bool _matches(
    String encoded,
    Needle3IntentExpectation expected,
  ) {
    try {
      final Object? decoded = jsonDecode(encoded);
      if (decoded is! Map<Object?, Object?>) return false;
      final Map<String, Object?> map = decoded.map(
        (Object? key, Object? value) =>
            MapEntry<String, Object?>(key.toString(), value),
      );

      final Set<String> ingredients =
          _strings(map['ingredients']).map(_normalize).toSet();
      if (!expected.requiredIngredients
          .map(_normalize)
          .every(ingredients.contains)) {
        return false;
      }

      if (expected.maxMinutes != null &&
          (map['max_minutes'] as num?)?.toInt() != expected.maxMinutes) {
        return false;
      }
      if (expected.category != null &&
          map['category']?.toString() != expected.category) {
        return false;
      }

      final Set<String> diet = _strings(map['diet']).toSet();
      if (!expected.requiredDiet.every(diet.contains)) return false;

      final Set<String> allergens =
          _strings(map['exclude_allergens']).toSet();
      if (!expected.excludedAllergens.every(allergens.contains)) {
        return false;
      }

      final Set<String> techniques =
          _strings(map['techniques']).toSet();
      if (!expected.requiredTechniques.every(techniques.contains)) {
        return false;
      }

      if (expected.antiWaste != null &&
          map['anti_waste'] != expected.antiWaste) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  static Iterable<String> _strings(Object? value) {
    return (value as List<Object?>? ?? const <Object?>[])
        .map((Object? item) => item?.toString() ?? '')
        .where((String item) => item.isNotEmpty);
  }

  static String _normalize(String value) =>
      value.toLowerCase().trim();
}

const List<Needle3IntentExpectation> tasteAiNeedle3IntentSuite =
    <Needle3IntentExpectation>[
  Needle3IntentExpectation(
    input: 'Ho zucchine, ricotta e due uova. Qualcosa entro 30 minuti.',
    requiredIngredients: <String>{'zucchine', 'ricotta', 'uova'},
    maxMinutes: 30,
  ),
  Needle3IntentExpectation(
    input: 'Vorrei un dessert vegetariano senza glutine.',
    category: 'dessert',
    requiredDiet: <String>{'vegetarian'},
    excludedAllergens: <String>{'gluten'},
  ),
  Needle3IntentExpectation(
    input: 'Come recupero le bucce di patata in friggitrice ad aria?',
    requiredIngredients: <String>{'bucce di patata'},
    requiredTechniques: <String>{'air_fryer'},
    antiWaste: true,
  ),
  Needle3IntentExpectation(
    input: 'Salmone sous vide, massimo 45 minuti.',
    requiredIngredients: <String>{'salmone'},
    maxMinutes: 45,
    requiredTechniques: <String>{'sous_vide'},
  ),
  Needle3IntentExpectation(
    input: 'Pasta senza latte e senza uova.',
    requiredIngredients: <String>{'pasta'},
    excludedAllergens: <String>{'milk', 'eggs'},
  ),
];
