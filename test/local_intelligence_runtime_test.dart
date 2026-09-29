import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/local_ai/local_ai_models.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_provider.dart';
import 'package:taste_ai/domain/local_ai/local_intelligence_runtime.dart';

class FakeProvider implements LocalIntelligenceProvider {
  FakeProvider({
    required this.localOnly,
    required this.supported,
    required this.bytes,
    required this.capabilities,
    this.delay = Duration.zero,
  });

  final bool localOnly;
  final bool supported;
  final int bytes;
  final Set<LocalAiCapability> capabilities;
  final Duration delay;
  bool initialized = false;

  @override
  LocalModelDescriptor get descriptor => LocalModelDescriptor(
        id: 'fake',
        displayName: 'Fake local model',
        version: '1',
        modelBytes: bytes,
        capabilities: capabilities,
      );

  @override
  bool get isLocalOnly => localOnly;

  @override
  Future<bool> probe() async => supported;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<LocalAiResult> run(LocalAiRequest request) async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return LocalAiResult(
      status: LocalAiRunStatus.success,
      text: 'ok',
      orderedRecipeIds: request.candidateRecipeIds,
      providerId: descriptor.id,
    );
  }

  @override
  void dispose() {}
}

void main() {
  test('default runtime adds zero model bytes and stays unavailable', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime();

    await runtime.initialize();

    expect(runtime.status, LocalAiRuntimeStatus.unavailable);
    expect(runtime.descriptor.modelBytes, 0);
    expect(runtime.available, isFalse);
  });

  test('accepts a supported local model under the preferred 50 MB cap', () async {
    final FakeProvider provider = FakeProvider(
      localOnly: true,
      supported: true,
      bytes: 32 * 1024 * 1024,
      capabilities: <LocalAiCapability>{LocalAiCapability.reranking},
    );
    final LocalIntelligenceRuntime runtime =
        LocalIntelligenceRuntime(provider: provider);

    await runtime.initialize();

    expect(runtime.status, LocalAiRuntimeStatus.ready);
    expect(runtime.meetsPreferredSizeTarget, isTrue);
    expect(provider.initialized, isTrue);
  });

  test('rejects cloud or remote providers by policy', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: FakeProvider(
        localOnly: false,
        supported: true,
        bytes: 10,
        capabilities: <LocalAiCapability>{
          LocalAiCapability.intentUnderstanding,
        },
      ),
    );

    await runtime.initialize();

    expect(runtime.status, LocalAiRuntimeStatus.rejected);
    expect(runtime.lastErrorCode, 'provider_not_local');
  });

  test('rejects oversized model unless explicitly allowed', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: FakeProvider(
        localOnly: true,
        supported: true,
        bytes: 80 * 1024 * 1024,
        capabilities: <LocalAiCapability>{LocalAiCapability.reranking},
      ),
    );

    await runtime.initialize();

    expect(runtime.status, LocalAiRuntimeStatus.rejected);
    expect(runtime.lastErrorCode, 'model_over_preferred_size');
  });

  test('grounded explanation cannot run without recipe context', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: FakeProvider(
        localOnly: true,
        supported: true,
        bytes: 1,
        capabilities: <LocalAiCapability>{
          LocalAiCapability.groundedExplanation,
        },
      ),
    );
    await runtime.initialize();

    final LocalAiResult result = await runtime.run(
      const LocalAiRequest(
        task: LocalAiTask.explainGroundedResult,
        input: 'Explain the choice',
      ),
    );

    expect(result.status, LocalAiRunStatus.rejected);
    expect(result.errorCode, 'grounding_required');
  });

  test('runtime enforces inference timeout', () async {
    final LocalIntelligenceRuntime runtime = LocalIntelligenceRuntime(
      provider: FakeProvider(
        localOnly: true,
        supported: true,
        bytes: 1,
        delay: const Duration(milliseconds: 50),
        capabilities: <LocalAiCapability>{
          LocalAiCapability.intentUnderstanding,
        },
      ),
      defaultTimeout: const Duration(milliseconds: 5),
    );
    await runtime.initialize();

    final LocalAiResult result = await runtime.run(
      const LocalAiRequest(
        task: LocalAiTask.interpretQuery,
        input: 'zucchine veloci',
      ),
    );

    expect(result.status, LocalAiRunStatus.timedOut);
  });
}
