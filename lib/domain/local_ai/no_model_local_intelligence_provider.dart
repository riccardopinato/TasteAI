import 'local_ai_models.dart';
import 'local_intelligence_provider.dart';

class NoModelLocalIntelligenceProvider implements LocalIntelligenceProvider {
  const NoModelLocalIntelligenceProvider();

  @override
  LocalModelDescriptor get descriptor => const LocalModelDescriptor(
        id: 'none',
        displayName: 'No local model',
        version: '0',
        modelBytes: 0,
        capabilities: <LocalAiCapability>{},
        bundled: false,
      );

  @override
  bool get isLocalOnly => true;

  @override
  Future<bool> probe() async => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<LocalAiResult> run(LocalAiRequest request) async {
    return LocalAiResult.unavailable(providerId: descriptor.id);
  }

  @override
  void dispose() {}
}
