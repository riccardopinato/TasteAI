import 'dart:convert';

import '../local_ai_models.dart';
import '../local_intelligence_provider.dart';
import 'needle3_bridge.dart';

class Needle3LocalIntelligenceProvider implements LocalIntelligenceProvider {
  Needle3LocalIntelligenceProvider({
    Needle3Bridge bridge = const UnavailableNeedle3Bridge(),
  }) : _bridge = bridge;

  static const int expectedFullModelBytes = 35 * 1024 * 1024;

  final Needle3Bridge _bridge;

  @override
  LocalModelDescriptor get descriptor => LocalModelDescriptor(
        id: 'needle3',
        displayName: 'Needle 3',
        version: 'candidate',
        modelBytes:
            _bridge.modelBytes > 0 ? _bridge.modelBytes : expectedFullModelBytes,
        capabilities: const <LocalAiCapability>{
          LocalAiCapability.intentUnderstanding,
          LocalAiCapability.reranking,
          LocalAiCapability.embeddings,
        },
        bundled: false,
      );

  @override
  bool get isLocalOnly => true;

  @override
  Future<bool> probe() async {
    return _bridge.isAvailable &&
        _bridge.modelAvailable &&
        _bridge.telemetryDisabled;
  }

  @override
  Future<void> initialize() async {
    if (!_bridge.telemetryDisabled) {
      throw StateError('needle_telemetry_must_be_disabled');
    }
    if (!_bridge.isAvailable || !_bridge.modelAvailable) {
      throw StateError('needle_runtime_or_model_unavailable');
    }
    await _bridge.initialize();
  }

  @override
  Future<LocalAiResult> run(LocalAiRequest request) async {
    switch (request.task) {
      case LocalAiTask.interpretQuery:
        final Map<String, Object?> intent =
            await _bridge.extractRecipeIntent(
          input: request.input,
          languageCode: _languageFromContexts(request.contexts),
        );
        if (intent.isEmpty) {
          return const LocalAiResult(
            status: LocalAiRunStatus.failed,
            providerId: 'needle3',
            errorCode: 'empty_intent',
          );
        }
        return LocalAiResult(
          status: LocalAiRunStatus.success,
          text: jsonEncode(_sanitizeIntent(intent)),
          providerId: descriptor.id,
        );

      case LocalAiTask.rerankCandidates:
        if (request.candidateRecipeIds.isEmpty) {
          return LocalAiResult.rejected(
            providerId: descriptor.id,
            errorCode: 'candidate_ids_required',
          );
        }
        final List<String> ordered = await _bridge.rerankRecipeIds(
          input: request.input,
          candidateRecipeIds: request.candidateRecipeIds,
          groundedRecipes: request.contexts
              .map(
                (GroundedRecipeContext context) => <String, Object?>{
                  'recipe_id': context.recipeId,
                  'title': context.title,
                  'ingredients': context.ingredients,
                  'facts': context.facts,
                },
              )
              .toList(growable: false),
        );
        final Set<String> allowed = request.candidateRecipeIds.toSet();
        final List<String> safeOrder = <String>[
          for (final String id in ordered)
            if (allowed.contains(id)) id,
          for (final String id in request.candidateRecipeIds)
            if (!ordered.contains(id)) id,
        ];
        return LocalAiResult(
          status: LocalAiRunStatus.success,
          orderedRecipeIds: safeOrder,
          providerId: descriptor.id,
        );

      case LocalAiTask.embedText:
        final List<double> embedding = await _bridge.embed(request.input);
        if (embedding.isEmpty) {
          return const LocalAiResult(
            status: LocalAiRunStatus.failed,
            providerId: 'needle3',
            errorCode: 'empty_embedding',
          );
        }
        return LocalAiResult(
          status: LocalAiRunStatus.success,
          embedding: embedding,
          providerId: descriptor.id,
        );

      case LocalAiTask.explainGroundedResult:
        return LocalAiResult.rejected(
          providerId: descriptor.id,
          errorCode: 'needle3_not_used_for_freeform_explanation',
        );
    }
  }

  @override
  void dispose() {
    _bridge.dispose();
  }

  static String _languageFromContexts(
    List<GroundedRecipeContext> contexts,
  ) {
    // Language is intentionally not inferred from content. The native bridge
    // may use device locale when no explicit language field is available.
    return 'auto';
  }

  static Map<String, Object?> _sanitizeIntent(
    Map<String, Object?> raw,
  ) {
    const Set<String> allowedKeys = <String>{
      'ingredients',
      'max_minutes',
      'category',
      'diet',
      'exclude_allergens',
      'techniques',
      'anti_waste',
    };
    return <String, Object?>{
      for (final MapEntry<String, Object?> entry in raw.entries)
        if (allowedKeys.contains(entry.key)) entry.key: entry.value,
    };
  }
}
