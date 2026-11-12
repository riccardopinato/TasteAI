import 'package:factory_profile_kit/factory_profile_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/app/app_settings_controller.dart';
import 'package:taste_ai/app/factory_profile_compat.dart';
import 'package:taste_ai/data/preferences/app_preferences_store.dart';

class InMemoryTasteSettings implements AppPreferencesStore {
  String? language;
  bool metric = true;
  int saves = 0;
  @override
  Future<String?> loadLanguageCode() async => language;
  @override
  Future<bool> loadMetricUnits() async => metric;
  @override
  Future<Set<String>> loadFavoriteIds() async => const {};
  @override
  Future<String?> loadRecipeSearchIndex() async => null;
  @override
  Future<void> saveFavoriteIds(Set<String> _) async { saves++; }
  @override
  Future<void> saveLanguageCode(String? value) async { saves++; language = value; }
  @override
  Future<void> saveMetricUnits(bool value) async { saves++; metric = value; }
  @override
  Future<void> saveRecipeSearchIndex(String _) async { saves++; }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('actual TasteAI settings produce a read-only pinned Factory profile', () async {
    final store = InMemoryTasteSettings()..language = 'fr'..metric = false;
    final settings = AppSettingsController(store);
    await settings.initialize();
    final snapshot = tasteAiFactoryProfileSnapshot(settings);
    expect(snapshot.locale, 'fr');
    expect(snapshot.displayName, isEmpty);
    expect(snapshot.analyticsOptIn, isFalse);
    expect(snapshot.theme, ProfileTheme.system);
    expect(snapshot.toJson()['schema_version'], 1);
    expect(settings.metricUnits, isFalse);
    expect(settings.languageCode, 'fr');
    expect(store.saves, 0);
    settings.dispose();
  });

  test('unknown legacy TasteAI language fails closed without overwriting data', () async {
    final store = InMemoryTasteSettings()..language = 'invalid_legacy';
    final settings = AppSettingsController(store);
    await settings.initialize();
    final snapshot = tasteAiFactoryProfileSnapshot(settings);
    expect(snapshot.locale, 'system');
    expect(snapshot.analyticsOptIn, isFalse);
    expect(settings.languageCode, 'invalid_legacy');
    expect(store.saves, 0);
    settings.dispose();
  });

  test('Factory schema v0 migration is isolated from existing TasteAI store', () async {
    final original = InMemoryTasteSettings()..language = 'it';
    final settings = AppSettingsController(original);
    await settings.initialize();
    final snapshot = tasteAiFactoryProfileSnapshot(settings);
    final legacy = ProfilePreferences.fromJson(const {
      'schema_version': 0,
      'name': '',
      'language': 'it',
      'theme': 'system',
    });
    expect(legacy.locale, snapshot.locale);
    expect(legacy.analyticsOptIn, isFalse);
    expect(original.saves, 0);
    settings.dispose();
  });
}
