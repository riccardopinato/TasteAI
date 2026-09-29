import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/local_ai/local_ai_models.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_runtime.dart';
import 'package:taste_ai/domain/local_ai/needle/needle3_benchmark.dart';
import 'package:taste_ai/domain/local_ai/needle/needle3_bridge.dart';
import 'package:taste_ai/domain/local_ai/needle/needle3_local_intelligence_provider.dart';

class CaseBridge implements Needle3Bridge {
  @override
  bool get isAvailable => true;
  @override
  bool get telemetryDisabled => true;
  @override
  bool get modelAvailable => true;
  @override
  int get modelBytes => 35 * 1024 * 1024;

  @override
  Future<void> initialize() async {}

  @override
  Future<Map<String, Object?>> extractRecipeIntent({
    required String input,
    required String languageCode,
  }) async {
    if (input.contains('zucchine')) {
      return <String, Object?>{
        'ingredients': <String>['zucchine', 'ricotta', 'uova'],
        'max_minutes': 30,
        'diet': <String>[],
        'exclude_allergens': <String>[],
        'techniques': <String>[],
        'anti_waste': false,
      };
    }
    return <String, Object?>{
      'ingredients': <String>[],
      'diet': <String>[],
      'exclude_allergens': <String>[],
      'techniques': <String>[],
      'anti_waste': false,
    };
  }

  @override
  Future<List<String>> rerankRecipeIds({
    required String input,
    required List<String> candidateRecipeIds,
    required List<Map<String, Object?>> groundedRecipes,
  }) async => candidateRecipeIds;

  @override
  Future<List<double>> embed(String text) async => const <double>[0.1];

  @override
  void dispose() {}
}

void main() {
  test('benchmark harness reports exact grounded extraction pass rate', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: Needle3LocalIntelligenceProvider(bridge: CaseBridge()),
    );
    await runtime.initialize();

    final Needle3BenchmarkResult result =
        await Needle3BenchmarkHarness(runtime).runIntentSuite(
      const <Needle3IntentExpectation>[
        Needle3IntentExpectation(
          input: 'Ho zucchine, ricotta e uova entro 30 minuti',
          requiredIngredients: <String>{'zucchine', 'ricotta', 'uova'},
          maxMinutes: 30,
        ),
        Needle3IntentExpectation(
          input: 'qualcosa con salmone',
          requiredIngredients: <String>{'salmone'},
        ),
      ],
    );

    expect(result.total, 2);
    expect(result.passed, 1);
    expect(result.passRate, 0.5);
  });
}
