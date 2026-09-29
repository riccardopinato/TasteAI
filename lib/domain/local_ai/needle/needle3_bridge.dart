abstract interface class Needle3Bridge {
  bool get isAvailable;

  /// Must be true before TasteAI allows the provider to initialize.
  /// The native integration must enforce NEEDLE_TELEMETRY=0 and DO_NOT_TRACK=1
  /// (or an equivalent engine-level opt-out) before loading the engine.
  bool get telemetryDisabled;

  bool get modelAvailable;

  int get modelBytes;

  Future<void> initialize();

  Future<Map<String, Object?>> extractRecipeIntent({
    required String input,
    required String languageCode,
  });

  Future<List<String>> rerankRecipeIds({
    required String input,
    required List<String> candidateRecipeIds,
    required List<Map<String, Object?>> groundedRecipes,
  });

  Future<List<double>> embed(String text);

  void dispose();
}

class UnavailableNeedle3Bridge implements Needle3Bridge {
  const UnavailableNeedle3Bridge();

  @override
  bool get isAvailable => false;

  @override
  bool get telemetryDisabled => true;

  @override
  bool get modelAvailable => false;

  @override
  int get modelBytes => 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<Map<String, Object?>> extractRecipeIntent({
    required String input,
    required String languageCode,
  }) async {
    return const <String, Object?>{};
  }

  @override
  Future<List<String>> rerankRecipeIds({
    required String input,
    required List<String> candidateRecipeIds,
    required List<Map<String, Object?>> groundedRecipes,
  }) async {
    return const <String>[];
  }

  @override
  Future<List<double>> embed(String text) async => const <double>[];

  @override
  void dispose() {}
}
