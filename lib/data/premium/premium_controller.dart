import 'package:flutter/foundation.dart';

import 'premium_service.dart';

enum PremiumStatus {
  notConfigured,
  unsupported,
  loading,
  free,
  plus,
  purchasing,
  restoring,
  error,
}

class PremiumController extends ChangeNotifier {
  PremiumController({
    PremiumService? service,
  }) : _service = service ?? RevenueCatPremiumService();

  final PremiumService _service;

  PremiumStatus _status = PremiumStatus.loading;
  List<PremiumPackageOption> _packages =
      const <PremiumPackageOption>[];
  String _errorCode = '';

  PremiumStatus get status => _status;
  bool get isPlus => _status == PremiumStatus.plus;
  bool get busy =>
      _status == PremiumStatus.loading ||
      _status == PremiumStatus.purchasing ||
      _status == PremiumStatus.restoring;
  List<PremiumPackageOption> get packages => _packages;
  String get errorCode => _errorCode;
  bool get configured => _service.configured;
  bool get supported => _service.supported;
  String get entitlementId => _service.entitlementId;

  Future<void> initialize() async {
    _errorCode = '';
    if (!_service.supported) {
      _status = PremiumStatus.unsupported;
      notifyListeners();
      return;
    }
    if (!_service.configured) {
      _status = PremiumStatus.notConfigured;
      notifyListeners();
      return;
    }

    _status = PremiumStatus.loading;
    notifyListeners();
    try {
      _applySnapshot(await _service.initialize());
    } on PremiumServiceException catch (error) {
      _applyServiceError(error.code);
    } catch (_) {
      _status = PremiumStatus.error;
      _errorCode = 'initialization_failed';
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    if (!_service.supported || !_service.configured) return;
    _status = PremiumStatus.loading;
    _errorCode = '';
    notifyListeners();
    try {
      _applySnapshot(await _service.refresh());
    } on PremiumServiceException catch (error) {
      _applyServiceError(error.code);
    } catch (_) {
      _status = PremiumStatus.error;
      _errorCode = 'refresh_failed';
    }
    notifyListeners();
  }

  Future<bool> purchase(String packageIdentifier) async {
    if (!_service.supported || !_service.configured) return false;
    _status = PremiumStatus.purchasing;
    _errorCode = '';
    notifyListeners();
    try {
      _applySnapshot(
        await _service.purchase(packageIdentifier),
      );
      notifyListeners();
      return isPlus;
    } on PremiumServiceException catch (error) {
      if (error.code == 'purchase_cancelled') {
        _status = PremiumStatus.free;
        _errorCode = '';
      } else {
        _applyServiceError(error.code);
      }
      notifyListeners();
      return false;
    } catch (_) {
      _status = PremiumStatus.error;
      _errorCode = 'purchase_failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> restore() async {
    if (!_service.supported || !_service.configured) return false;
    _status = PremiumStatus.restoring;
    _errorCode = '';
    notifyListeners();
    try {
      _applySnapshot(await _service.restore());
      notifyListeners();
      return isPlus;
    } on PremiumServiceException catch (error) {
      _applyServiceError(error.code);
      notifyListeners();
      return false;
    } catch (_) {
      _status = PremiumStatus.error;
      _errorCode = 'restore_failed';
      notifyListeners();
      return false;
    }
  }

  void _applySnapshot(PremiumServiceSnapshot snapshot) {
    _packages = snapshot.packages;
    _status =
        snapshot.isPlus ? PremiumStatus.plus : PremiumStatus.free;
    _errorCode = '';
  }

  void _applyServiceError(String code) {
    _errorCode = code;
    if (code == 'not_configured') {
      _status = PremiumStatus.notConfigured;
    } else if (code == 'platform_unsupported') {
      _status = PremiumStatus.unsupported;
    } else {
      _status = PremiumStatus.error;
    }
  }
}
