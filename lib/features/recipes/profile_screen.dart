import 'package:flutter/material.dart';

import '../../app/app_settings_controller.dart';
import '../../core/l10n/app_strings.dart';
import '../../data/sync/profile_sync_controller.dart';
import '../../domain/account/google_account_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.settings,
    required this.recipeCount,
    required this.syncController,
  });

  final AppSettingsController settings;
  final int recipeCount;
  final ProfileSyncController syncController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        syncController,
        syncController.accountController,
        settings,
      ]),
      builder: (BuildContext context, Widget? child) {
        return _ProfileBody(
          settings: settings,
          recipeCount: recipeCount,
          syncController: syncController,
        );
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.settings,
    required this.recipeCount,
    required this.syncController,
  });

  final AppSettingsController settings;
  final int recipeCount;
  final ProfileSyncController syncController;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final String selectedLanguage =
        settings.languageCode ?? 'system';
    final GoogleAccountController accountController =
        syncController.accountController;
    final GoogleAccountSnapshot? account =
        accountController.account;
    final bool busy =
        syncController.status == ProfileSyncStatus.uploading ||
        syncController.status == ProfileSyncStatus.restoring;

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
                    Expanded(
                      child: Text(
                        strings.offlineRecipeCount(recipeCount),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  strings.account,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                if (account != null) ...<Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      account.displayName?.trim().isNotEmpty == true
                          ? account.displayName!
                          : account.email,
                    ),
                    subtitle: Text(account.email),
                  ),
                  OutlinedButton.icon(
                    onPressed:
                        busy ? null : accountController.signOut,
                    icon: const Icon(Icons.logout),
                    label: Text(strings.signOut),
                  ),
                ] else if (!accountController.configured) ...<Widget>[
                  Text(strings.googleNotConfigured),
                ] else ...<Widget>[
                  Text(strings.googleOptional),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: busy
                        ? null
                        : () async {
                            await accountController
                                .signInInteractively();
                          },
                    icon: const Icon(Icons.login),
                    label: Text(strings.signInGoogle),
                  ),
                  if (accountController.status ==
                      GoogleAccountStatus.unsupported)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(strings.googleUnsupported),
                    ),
                ],
              ],
            ),
          ),
        ),
        if (account != null) ...<Widget>[
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    strings.backupSync,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(strings.backupDescription),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed:
                        busy ? null : syncController.backupNow,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text(strings.backupNow),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed:
                        busy ? null : syncController.restoreLatest,
                    icon:
                        const Icon(Icons.cloud_download_outlined),
                    label: Text(strings.restoreBackup),
                  ),
                  if (busy) ...<Widget>[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(),
                  ],
                  if (syncController.status ==
                      ProfileSyncStatus.success) ...<Widget>[
                    const SizedBox(height: 10),
                    Text(strings.syncSuccess),
                  ],
                  if (syncController.status ==
                      ProfileSyncStatus.empty) ...<Widget>[
                    const SizedBox(height: 10),
                    Text(strings.noCloudBackup),
                  ],
                  if (syncController.status ==
                      ProfileSyncStatus.error) ...<Widget>[
                    const SizedBox(height: 10),
                    Text(strings.syncError),
                  ],
                ],
              ),
            ),
          ),
        ],
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
                    DropdownMenuItem<String>(
                      value: 'system',
                      child: Text(strings.systemDefault),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'en',
                      child: Text('English'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'it',
                      child: Text('Italiano'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'es',
                      child: Text('Español'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'fr',
                      child: Text('Français'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'pt',
                      child: Text('Português'),
                    ),
                  ],
                  onChanged: (String? value) {
                    settings.setLanguageCode(
                      value == 'system' ? null : value,
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.straighten),
                title: Text(strings.units),
                subtitle: Text(
                  settings.metricUnits
                      ? strings.metric
                      : strings.imperial,
                ),
                value: settings.metricUnits,
                onChanged: settings.setMetricUnits,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
