import 'local_ai_models.dart';

abstract interface class LocalIntelligenceProvider {
  LocalModelDescriptor get descriptor;

  /// Must be true for providers admitted by TasteAI v1.x.
  bool get isLocalOnly;

  Future<bool> probe();

  Future<void> initialize();

  Future<LocalAiResult> run(LocalAiRequest request);

  void dispose();
}
