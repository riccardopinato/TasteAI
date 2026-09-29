import 'package:flutter/material.dart';

import '../data/preferences/app_preferences_store.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController(this._store);

  final AppPreferencesStore _store;

  bool _metricUnits = true;
  String? _languageCode;

  bool get metricUnits => _metricUnits;
  String? get languageCode => _languageCode;
  Locale? get locale => _languageCode == null ? null : Locale(_languageCode!);

  Future<void> initialize() async {
    _metricUnits = await _store.loadMetricUnits();
    _languageCode = await _store.loadLanguageCode();
    notifyListeners();
  }

  Future<void> setMetricUnits(bool value) async {
    if (_metricUnits == value) return;
    _metricUnits = value;
    notifyListeners();
    await _store.saveMetricUnits(value);
  }

  Future<void> setLanguageCode(String? value) async {
    if (_languageCode == value) return;
    _languageCode = value;
    notifyListeners();
    await _store.saveLanguageCode(value);
  }
}
