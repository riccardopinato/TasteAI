import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/local_ai/local_ai_models.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_runtime.dart';
import 'package:taste_ai/domain/local_ai/needle/needle3_bridge.dart';
import 'package:taste_ai/domain/local_ai/needle/needle3_local_intelligence_provider.dart';

class FakeNeedleBridge implements Needle3Bridge {
  FakeNeedleBridge({
    this.available = true,
    this.telemetryOff = true,
    this.modelPresent = true,
    this.bytes = 35 * 1024 * 1024,
    this.intent = const <String, Object?>{},
    this.order = const <String>[],
    this.vector = const <double>[0.1, 0.2],
  });

  final bool available;
  final bool telemetryOff;
  final bool modelPresent;
  final int bytes;
  final Map<String, Object?> intent;
  final List<String> order;
  final List<double> vector;

  @override
  bool get isAvailable => available;
  @override
  bool get telemetryDisabled => telemetryOff;
  @override
  bool get modelAvailable => modelPresent;
  @override
  int get modelBytes => bytes;

  @override
  Future<void> initialize() async {}

  @override
  Future<Map<String, Object?>> extractRecipeIntent({
    required String input,
    required String languageCode,
  }) async => intent;

  @override
  Future<List<String>> rerankRecipeIds({
    required String input,
    required List<String> candidateRecipeIds,
    required List<Map<String, Object?>> groundedRecipes,
  }) async => order;

  @override
  Future<List<double>> embed(String text) async => vector;

  @override
  void dispose() {}
}

void main() {
  test('Needle 3 candidate fits the default local size policy', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: Needle3LocalIntelligenceProvider(
        bridge: FakeNeedleBridge(
          intent: const <String, Object?>{
            'ingredients': <String>['zucchine'],
            'diet': <String>[],
            'exclude_allergens': <String>[],
            'techniques': <String>[],
            'anti_waste': false,
          },
        ),
      ),
    );

    await runtime.initialize();

    expect(runtime.status, LocalAiRuntimeStatus.ready);
    expect(runtime.meetsPreferredSizeTarget, isTrue);
    expect(runtime.descriptor.bundled, isFalse);
  });

  test('Needle 3 is unavailable when telemetry opt-out is not guaranteed', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: Needle3LocalIntelligenceProvider(
        bridge: FakeNeedleBridge(telemetryOff: false),
      ),
    );

    await runtime.initialize();

    expect(runtime.available, isFalse);
  });

  test('provider strips unknown intent keys', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: Needle3LocalIntelligenceProvider(
        bridge: FakeNeedleBridge(
          intent: const <String, Object?>{
            'ingredients': <String>['zucchine'],
            'anti_waste': false,
            'invented_field': 'must disappear',
          },
        ),
      ),
    );
    await runtime.initialize();

    final LocalAiResult result = await runtime.run(
      const LocalAiRequest(
        task: LocalAiTask.interpretQuery,
        input: 'zucchine',
      ),
    );

    expect(result.success, isTrue);
    expect(result.text, contains('ingredients'));
    expect(result.text, isNot(contains('invented_field')));
  });

  test('reranking cannot inject recipe IDs outside grounded candidates', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: Needle3LocalIntelligenceProvider(
        bridge: FakeNeedleBridge(
          order: const <String>['b', 'invented', 'a'],
        ),
      ),
    );
    await runtime.initialize();

    final LocalAiResult result = await runtime.run(
      const LocalAiRequest(
        task: LocalAiTask.rerankCandidates,
        input: 'best match',
        candidateRecipeIds: <String>['a', 'b', 'c'],
      ),
    );

    expect(result.orderedRecipeIds, <String>['b', 'a', 'c']);
  });
}
