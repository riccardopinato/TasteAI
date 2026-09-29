import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as rc;

class PremiumPackageOption {
  const PremiumPackageOption({
    required this.identifier,
    required this.title,
    required this.description,
    required this.priceString,
  });

  final String identifier;
  final String title;
  final String description;
  final String priceString;
}

class PremiumServiceSnapshot {
  const PremiumServiceSnapshot({
    required this.isPlus,
    required this.packages,
  });

  final bool isPlus;
  final List<PremiumPackageOption> packages;
}

abstract interface class PremiumService {
  bool get configured;
  bool get supported;
  String get entitlementId;

  Future<PremiumServiceSnapshot> initialize();
  Future<PremiumServiceSnapshot> refresh();
  Future<PremiumServiceSnapshot> purchase(String packageIdentifier);
  Future<PremiumServiceSnapshot> restore();
}

class PremiumServiceException implements Exception {
  const PremiumServiceException(this.code);

  final String code;

  @override
  String toString() => 'PremiumServiceException($code)';
}

class RevenueCatPremiumService implements PremiumService {
  RevenueCatPremiumService({
    String apiKey = const String.fromEnvironment(
      'TASTEAI_REVENUECAT_API_KEY',
    ),
    String entitlementId = const String.fromEnvironment(
      'TASTEAI_REVENUECAT_ENTITLEMENT',
      defaultValue: 'plus',
    ),
  })  : _apiKey = apiKey.trim(),
        _entitlementId = entitlementId.trim().isEmpty
            ? 'plus'
            : entitlementId.trim();

  final String _apiKey;
  final String _entitlementId;

  final Map<String, rc.Package> _packagesById =
      <String, rc.Package>{};
  bool _initialized = false;

  @override
  bool get configured => _apiKey.isNotEmpty;

  @override
  bool get supported => !kIsWeb;

  @override
  String get entitlementId => _entitlementId;

  @override
  Future<PremiumServiceSnapshot> initialize() async {
    if (!supported) {
      throw const PremiumServiceException('platform_unsupported');
    }
    if (!configured) {
      throw const PremiumServiceException('not_configured');
    }

    try {
      final bool alreadyConfigured = await rc.Purchases.isConfigured;
      if (!alreadyConfigured) {
        final rc.PurchasesConfiguration configuration =
            rc.PurchasesConfiguration(_apiKey)
              ..automaticDeviceIdentifierCollectionEnabled = false;
        await rc.Purchases.configure(configuration);
      }
      _initialized = true;
      return refresh();
    } on PlatformException catch (error) {
      throw PremiumServiceException(
        'configure_${_purchaseErrorCode(error)}',
      );
    } catch (_) {
      throw const PremiumServiceException('configure_failed');
    }
  }

  @override
  Future<PremiumServiceSnapshot> refresh() async {
    _ensureInitialized();
    try {
      final List<Object> values = await Future.wait<Object>(<Future<Object>>[
        rc.Purchases.getCustomerInfo(),
        rc.Purchases.getOfferings(),
      ]);
      final rc.CustomerInfo customerInfo =
          values[0] as rc.CustomerInfo;
      final rc.Offerings offerings = values[1] as rc.Offerings;
      return _snapshot(customerInfo, offerings);
    } on PlatformException catch (error) {
      throw PremiumServiceException(
        'refresh_${_purchaseErrorCode(error)}',
      );
    } catch (_) {
      throw const PremiumServiceException('refresh_failed');
    }
  }

  @override
  Future<PremiumServiceSnapshot> purchase(
    String packageIdentifier,
  ) async {
    _ensureInitialized();
    final rc.Package? package = _packagesById[packageIdentifier];
    if (package == null) {
      throw const PremiumServiceException('package_not_found');
    }

    try {
      final rc.PurchaseResult result = await rc.Purchases.purchase(
        rc.PurchaseParams.package(package),
      );
      final rc.Offerings offerings =
          await rc.Purchases.getOfferings();
      return _snapshot(result.customerInfo, offerings);
    } on PlatformException catch (error) {
      final rc.PurchasesErrorCode code =
          rc.PurchasesErrorHelper.getErrorCode(error);
      if (code == rc.PurchasesErrorCode.purchaseCancelledError) {
        throw const PremiumServiceException('purchase_cancelled');
      }
      throw PremiumServiceException('purchase_${code.name}');
    } catch (_) {
      throw const PremiumServiceException('purchase_failed');
    }
  }

  @override
  Future<PremiumServiceSnapshot> restore() async {
    _ensureInitialized();
    try {
      final rc.CustomerInfo customerInfo =
          await rc.Purchases.restorePurchases();
      final rc.Offerings offerings =
          await rc.Purchases.getOfferings();
      return _snapshot(customerInfo, offerings);
    } on PlatformException catch (error) {
      throw PremiumServiceException(
        'restore_${_purchaseErrorCode(error)}',
      );
    } catch (_) {
      throw const PremiumServiceException('restore_failed');
    }
  }

  PremiumServiceSnapshot _snapshot(
    rc.CustomerInfo customerInfo,
    rc.Offerings offerings,
  ) {
    _packagesById.clear();
    final List<rc.Package> packages =
        offerings.current?.availablePackages ??
            const <rc.Package>[];
    final List<PremiumPackageOption> options =
        <PremiumPackageOption>[];

    for (final rc.Package package in packages) {
      _packagesById[package.identifier] = package;
      options.add(
        PremiumPackageOption(
          identifier: package.identifier,
          title: package.storeProduct.title,
          description: package.storeProduct.description,
          priceString: package.storeProduct.priceString,
        ),
      );
    }

    final bool active =
        customerInfo.entitlements.all[_entitlementId]?.isActive ??
            false;

    return PremiumServiceSnapshot(
      isPlus: active,
      packages: List<PremiumPackageOption>.unmodifiable(options),
    );
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw const PremiumServiceException('not_initialized');
    }
  }

  static String _purchaseErrorCode(PlatformException error) {
    try {
      return rc.PurchasesErrorHelper.getErrorCode(error).name;
    } catch (_) {
      return error.code;
    }
  }
}
