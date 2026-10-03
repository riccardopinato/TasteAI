import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppPreferencesStore {
  Future<Set<String>> loadFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);
  Future<bool> loadMetricUnits();
  Future<void> saveMetricUnits(bool metricUnits);
  Future<String?> loadLanguageCode();
  Future<void> saveLanguageCode(String? languageCode);
  Future<String?> loadRecipeSearchIndex();
  Future<void> saveRecipeSearchIndex(String encodedIndex);
}

class SharedPreferencesAppPreferencesStore implements AppPreferencesStore {
  static const String _favoritesKey = 'tasteai.favorite_ids.v1';
  static const String _metricKey = 'tasteai.metric_units.v1';
  static const String _languageKey = 'tasteai.language_code.v1';
  static const String _searchIndexKey = 'tasteai.recipe_search_index.v1';

  @override
  Future<Set<String>> loadFavoriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_favoritesKey) ?? const <String>[]).toSet();
  }

  @override
  Future<bool> loadMetricUnits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_metricKey) ?? true;
  }

  @override
  Future<String?> loadLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  @override
  Future<String?> loadRecipeSearchIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_searchIndexKey);
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> sorted = ids.toList()..sort();
    await prefs.setStringList(_favoritesKey, sorted);
  }

  @override
  Future<void> saveMetricUnits(bool metricUnits) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_metricKey, metricUnits);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (languageCode == null || languageCode.isEmpty) {
      await prefs.remove(_languageKey);
      return;
    }
    await prefs.setString(_languageKey, languageCode);
  }

  @override
  Future<void> saveRecipeSearchIndex(String encodedIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_searchIndexKey, encodedIndex);
  }
}
