import 'package:flutter/foundation.dart';

import '../../app/app_settings_controller.dart';
import '../../domain/account/google_account_controller.dart';
import '../../domain/backup/taste_backup_payload.dart';
import '../../features/recipes/recipe_controller.dart';
import 'google_drive_backup_service.dart';

enum ProfileSyncStatus {
  idle,
  uploading,
  restoring,
  success,
  empty,
  error,
}

class ProfileSyncController extends ChangeNotifier {
  ProfileSyncController({
    required GoogleAccountController accountController,
    required GoogleDriveBackupService driveBackupService,
    required RecipeController recipeController,
    required AppSettingsController settingsController,
  })  : _accountController = accountController,
        _driveBackupService = driveBackupService,
        _recipeController = recipeController,
        _settingsController = settingsController;

  final GoogleAccountController _accountController;
  final GoogleDriveBackupService _driveBackupService;
  final RecipeController _recipeController;
  final AppSettingsController _settingsController;

  ProfileSyncStatus _status = ProfileSyncStatus.idle;
  String _errorCode = '';

  GoogleAccountController get accountController => _accountController;
  ProfileSyncStatus get status => _status;
  String get errorCode => _errorCode;

  Future<void> backupNow() async {
    _status = ProfileSyncStatus.uploading;
    _errorCode = '';
    notifyListeners();
    try {
      final TasteBackupPayload payload = TasteBackupPayload(
        favoriteRecipeIds: _recipeController.favoriteIds,
        metricUnits: _settingsController.metricUnits,
        languageCode: _settingsController.languageCode,
        createdAtUtc: DateTime.now().toUtc(),
      );
      await _driveBackupService.upload(payload);
      _status = ProfileSyncStatus.success;
    } on DriveBackupException catch (error) {
      _status = ProfileSyncStatus.error;
      _errorCode = error.code;
    } catch (_) {
      _status = ProfileSyncStatus.error;
      _errorCode = 'backup_failed';
    }
    notifyListeners();
  }

  Future<void> restoreLatest() async {
    _status = ProfileSyncStatus.restoring;
    _errorCode = '';
    notifyListeners();
    try {
      final TasteBackupPayload? payload =
          await _driveBackupService.downloadLatest();
      if (payload == null) {
        _status = ProfileSyncStatus.empty;
        notifyListeners();
        return;
      }
      await _recipeController.replaceFavorites(
        payload.favoriteRecipeIds,
      );
      await _settingsController.applyBackup(
        metricUnits: payload.metricUnits,
        languageCode: payload.languageCode,
      );
      _status = ProfileSyncStatus.success;
    } on DriveBackupException catch (error) {
      _status = ProfileSyncStatus.error;
      _errorCode = error.code;
    } catch (_) {
      _status = ProfileSyncStatus.error;
      _errorCode = 'restore_failed';
    }
    notifyListeners();
  }
}
