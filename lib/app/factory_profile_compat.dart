import 'package:factory_profile_kit/factory_profile_kit.dart';

import 'app_settings_controller.dart';

/// X10-026: an opt-in, read-only projection into the shared Factory profile.
/// Does NOT replace TasteAI's existing settings/storage or start OAuth, ads,
/// tracking, cloud backup, or any migration.
ProfilePreferences tasteAiFactoryProfileSnapshot(AppSettingsController app) {
  final locale = switch (app.languageCode) {
    'it' => 'it',
    'en' => 'en',
    'es' => 'es',
    'fr' => 'fr',
    'pt' => 'pt',
    _ => 'system',
  };
  return ProfilePreferences(
    displayName: '',
    locale: locale,
    theme: ProfileTheme.system,
    analyticsOptIn: false,
  );
}
