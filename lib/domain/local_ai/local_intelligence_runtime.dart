import 'dart:async';

import 'local_intelligence_provider.dart';
import 'no_model_local_intelligence_provider.dart';

class LocalIntelligenceRuntime {
  LocalIntelligenceRuntime({
    LocalIntelligenceProvider provider =
        const NoModelLocalIntelligenceProvider(),
    this.preferredMaxModelBytes = 50 * 1024 * 1024,
    this.allowOversizedModels = false,
    this.defaultTimeout = const Duration(seconds: 4),
  }) : _provider = provider;

  final LocalIntelligenceProvider _provider;
  final int preferredMaxModelBytes;
  final bool allowOversizedModels;
  final Duration defaultTimeout;

  LocalAiRuntimeStatus _status = LocalAiRuntimeStatus.unavailable;
  String _lastErrorCode = '';

  LocalAiRuntimeStatus get status => _status;
  String get lastErrorCode => _lastErrorCode;
  LocalModelDescriptor get descriptor => _provider.descriptor;

  bool get available => _status == LocalAiRuntimeStatus.ready;

  bool get meetsPreferredSizeTarget {
    final int bytes = descriptor.modelBytes;
    return bytes <= 0 || bytes <= preferredMaxModelBytes;
  }

  bool supports(LocalAiCapability capability) {
    return available && descriptor.capabilities.contains(capability);
  }

  Future<void> initialize() async {
    _lastErrorCode = '';

    if (descriptor.isNoModel) {
      _status = LocalAiRuntimeStatus.unavailable;
      return;
    }
    if (!_provider.isLocalOnly) {
      _status = LocalAiRuntimeStatus.rejected;
      _lastErrorCode = 'provider_not_local';
      return;
    }
    if (!allowOversizedModels && !meetsPreferredSizeTarget) {
      _status = LocalAiRuntimeStatus.rejected;
      _lastErrorCode = 'model_over_preferred_size';
      return;
    }

    _status = LocalAiRuntimeStatus.initializing;
    try {
      final bool supported = await _provider.probe();
      if (!supported) {
        _status = LocalAiRuntimeStatus.unavailable;
        _lastErrorCode = 'device_not_supported';
        return;
      }
      await _provider.initialize();
      _status = LocalAiRuntimeStatus.ready;
    } catch (_) {
      _status = LocalAiRuntimeStatus.failed;
      _lastErrorCode = 'initialization_failed';
    }
  }

  Future<LocalAiResult> run(
    LocalAiRequest request, {
    Duration? timeout,
  }) async {
    if (!available) {
      return LocalAiResult.unavailable(
        providerId: descriptor.id,
        errorCode: _lastErrorCode.isEmpty ? 'runtime_not_ready' : _lastErrorCode,
      );
    }

    final LocalAiCapability capability = capabilityForTask(request.task);
    if (!descriptor.capabilities.contains(capability)) {
      return LocalAiResult.rejected(
        providerId: descriptor.id,
        errorCode: 'capability_not_supported',
      );
    }

    if (request.task == LocalAiTask.explainGroundedResult &&
        request.contexts.isEmpty) {
      return LocalAiResult.rejected(
        providerId: descriptor.id,
        errorCode: 'grounding_required',
      );
    }

    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final LocalAiResult result = await _provider
          .run(request)
          .timeout(timeout ?? defaultTimeout);
      stopwatch.stop();
      return LocalAiResult(
        status: result.status,
        text: result.text,
        orderedRecipeIds: result.orderedRecipeIds,
        embedding: result.embedding,
        providerId:
            result.providerId.isEmpty ? descriptor.id : result.providerId,
        errorCode: result.errorCode,
        elapsedMilliseconds: stopwatch.elapsedMilliseconds,
      );
    } on TimeoutException {
      stopwatch.stop();
      return LocalAiResult.timedOut(providerId: descriptor.id);
    } catch (_) {
      stopwatch.stop();
      return LocalAiResult.failed(providerId: descriptor.id);
    }
  }

  void dispose() {
    _provider.dispose();
  }
}
