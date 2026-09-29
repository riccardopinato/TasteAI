import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/data/premium/premium_controller.dart';
import 'package:taste_ai/data/premium/premium_service.dart';

class FakePremiumService implements PremiumService {
  FakePremiumService({
    this.isConfigured = true,
    this.isSupported = true,
    this.initialPlus = false,
  });

  final bool isConfigured;
  final bool isSupported;
  final bool initialPlus;
  bool purchased = false;
  bool restored = false;

  @override
  bool get configured => isConfigured;

  @override
  bool get supported => isSupported;

  @override
  String get entitlementId => 'plus';

  PremiumServiceSnapshot _snapshot(bool plus) {
    return PremiumServiceSnapshot(
      isPlus: plus,
      packages: const <PremiumPackageOption>[
        PremiumPackageOption(
          identifier: r'$rc_monthly',
          title: 'Monthly',
          description: 'TasteAI Plus',
          priceString: '€4.99',
        ),
      ],
    );
  }

  @override
  Future<PremiumServiceSnapshot> initialize() async =>
      _snapshot(initialPlus);

  @override
  Future<PremiumServiceSnapshot> refresh() async =>
      _snapshot(initialPlus || purchased || restored);

  @override
  Future<PremiumServiceSnapshot> purchase(
    String packageIdentifier,
  ) async {
    purchased = true;
    return _snapshot(true);
  }

  @override
  Future<PremiumServiceSnapshot> restore() async {
    restored = true;
    return _snapshot(true);
  }
}

void main() {
  test('unconfigured premium never simulates an unlock', () async {
    final PremiumController controller = PremiumController(
      service: FakePremiumService(isConfigured: false),
    );

    await controller.initialize();

    expect(controller.status, PremiumStatus.notConfigured);
    expect(controller.isPlus, isFalse);
    expect(controller.packages, isEmpty);
  });

  test('active entitlement is the only source of Plus state', () async {
    final PremiumController controller = PremiumController(
      service: FakePremiumService(initialPlus: true),
    );

    await controller.initialize();

    expect(controller.status, PremiumStatus.plus);
    expect(controller.isPlus, isTrue);
  });

  test('purchase transitions to Plus only from service entitlement', () async {
    final FakePremiumService service = FakePremiumService();
    final PremiumController controller =
        PremiumController(service: service);

    await controller.initialize();
    expect(controller.isPlus, isFalse);

    final bool unlocked =
        await controller.purchase(r'$rc_monthly');

    expect(service.purchased, isTrue);
    expect(unlocked, isTrue);
    expect(controller.status, PremiumStatus.plus);
  });

  test('restore uses real service state', () async {
    final FakePremiumService service = FakePremiumService();
    final PremiumController controller =
        PremiumController(service: service);

    await controller.initialize();
    final bool restored = await controller.restore();

    expect(service.restored, isTrue);
    expect(restored, isTrue);
    expect(controller.isPlus, isTrue);
  });

  test('unsupported platform remains Free', () async {
    final PremiumController controller = PremiumController(
      service: FakePremiumService(isSupported: false),
    );

    await controller.initialize();

    expect(controller.status, PremiumStatus.unsupported);
    expect(controller.isPlus, isFalse);
  });
}
