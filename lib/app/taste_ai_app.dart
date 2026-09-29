import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/design/taste_theme.dart';
import '../core/l10n/app_strings.dart';
import '../data/preferences/app_preferences_store.dart';
import '../features/shell/home_shell.dart';
import 'app_settings_controller.dart';

class TasteAiApp extends StatefulWidget {
  const TasteAiApp({super.key});

  @override
  State<TasteAiApp> createState() => _TasteAiAppState();
}

class _TasteAiAppState extends State<TasteAiApp> {
  late final AppPreferencesStore _preferencesStore;
  late final AppSettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _preferencesStore = SharedPreferencesAppPreferencesStore();
    _settingsController = AppSettingsController(_preferencesStore);
    _settingsController.initialize();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (BuildContext context) => AppStrings.of(context).appName,
          theme: TasteTheme.light(),
          darkTheme: TasteTheme.dark(),
          themeMode: ThemeMode.system,
          locale: _settingsController.locale,
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
            if (locale != null) {
              for (final Locale supported in supportedLocales) {
                if (supported.languageCode == locale.languageCode) return supported;
              }
            }
            return const Locale('en');
          },
          home: HomeShell(
            preferencesStore: _preferencesStore,
            settingsController: _settingsController,
          ),
        );
      },
    );
  }
}
