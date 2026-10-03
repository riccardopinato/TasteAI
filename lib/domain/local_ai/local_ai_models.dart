enum LocalAiCapability {
  intentUnderstanding,
  reranking,
  groundedExplanation,
  embeddings,
}

enum LocalAiTask {
  interpretQuery,
  rerankCandidates,
  explainGroundedResult,
  embedText,
}

enum LocalAiRuntimeStatus {
  unavailable,
  initializing,
  ready,
  rejected,
  failed,
}

enum LocalAiRunStatus {
  success,
  unavailable,
  rejected,
  timedOut,
  failed,
}

class LocalModelDescriptor {
  const LocalModelDescriptor({
    required this.id,
    required this.displayName,
    required this.version,
    required this.modelBytes,
    required this.capabilities,
    this.bundled = false,
  });

  final String id;
  final String displayName;
  final String version;
  final int modelBytes;
  final Set<LocalAiCapability> capabilities;
  final bool bundled;

  bool get isNoModel => id == 'none';
}

class GroundedRecipeContext {
  const GroundedRecipeContext({
    required this.recipeId,
    required this.title,
    this.ingredients = const <String>[],
    this.facts = const <String>[],
  });

  final String recipeId;
  final String title;
  final List<String> ingredients;
  final List<String> facts;
}

class LocalAiRequest {
  const LocalAiRequest({
    required this.task,
    required this.input,
    this.contexts = const <GroundedRecipeContext>[],
    this.candidateRecipeIds = const <String>[],
    this.maxOutputTokens = 160,
  });

  final LocalAiTask task;
  final String input;
  final List<GroundedRecipeContext> contexts;
  final List<String> candidateRecipeIds;
  final int maxOutputTokens;
}

class LocalAiResult {
  const LocalAiResult({
    required this.status,
    this.text = '',
    this.orderedRecipeIds = const <String>[],
    this.embedding = const <double>[],
    this.providerId = '',
    this.errorCode = '',
    this.elapsedMilliseconds = 0,
  });

  final LocalAiRunStatus status;
  final String text;
  final List<String> orderedRecipeIds;
  final List<double> embedding;
  final String providerId;
  final String errorCode;
  final int elapsedMilliseconds;

  bool get success => status == LocalAiRunStatus.success;

  factory LocalAiResult.unavailable({
    String providerId = '',
    String errorCode = 'unavailable',
  }) {
    return LocalAiResult(
      status: LocalAiRunStatus.unavailable,
      providerId: providerId,
      errorCode: errorCode,
    );
  }

  factory LocalAiResult.rejected({
    String providerId = '',
    required String errorCode,
  }) {
    return LocalAiResult(
      status: LocalAiRunStatus.rejected,
      providerId: providerId,
      errorCode: errorCode,
    );
  }

  factory LocalAiResult.timedOut({
    String providerId = '',
  }) {
    return LocalAiResult(
      status: LocalAiRunStatus.timedOut,
      providerId: providerId,
      errorCode: 'timeout',
    );
  }

  factory LocalAiResult.failed({
    String providerId = '',
    String errorCode = 'provider_failure',
  }) {
    return LocalAiResult(
      status: LocalAiRunStatus.failed,
      providerId: providerId,
      errorCode: errorCode,
    );
  }
}

LocalAiCapability capabilityForTask(LocalAiTask task) {
  switch (task) {
    case LocalAiTask.interpretQuery:
      return LocalAiCapability.intentUnderstanding;
    case LocalAiTask.rerankCandidates:
      return LocalAiCapability.reranking;
    case LocalAiTask.explainGroundedResult:
      return LocalAiCapability.groundedExplanation;
    case LocalAiTask.embedText:
      return LocalAiCapability.embeddings;
  }
}
