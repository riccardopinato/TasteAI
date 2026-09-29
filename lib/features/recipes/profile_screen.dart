import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.settings, required this.recipeCount});

  final AppSettingsController settings;
  final int recipeCount;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String selectedLanguage = settings.languageCode ?? 'system';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.offline_bolt_outlined),
                    const SizedBox(width: 10),
                    Expanded(child: Text(strings.offlineRecipeCount(recipeCount), style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(strings.localOnly),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(strings.language),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  underline: const SizedBox.shrink(),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(value: 'system', child: Text(strings.systemDefault)),
                    const DropdownMenuItem<String>(value: 'en', child: Text('English')),
                    const DropdownMenuItem<String>(value: 'it', child: Text('Italiano')),
                    const DropdownMenuItem<String>(value: 'es', child: Text('Español')),
                    const DropdownMenuItem<String>(value: 'fr', child: Text('Français')),
                    const DropdownMenuItem<String>(value: 'pt', child: Text('Português')),
                  ],
                  onChanged: (String? value) {
                    settings.setLanguageCode(value == 'system' ? null : value);
                  },
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.straighten),
                title: Text(strings.units),
                subtitle: Text(settings.metricUnits ? strings.metric : strings.imperial),
                value: settings.metricUnits,
                onChanged: settings.setMetricUnits,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const Icon(Icons.eco_outlined),
            title: Text(strings.antiWaste),
            subtitle: Text(strings.antiWasteComing),
          ),
        ),
      ],
    );
  }
}
