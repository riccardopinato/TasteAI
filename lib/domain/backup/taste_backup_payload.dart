import 'dart:convert';

class TasteBackupPayload {
  const TasteBackupPayload({
    required this.favoriteRecipeIds,
    required this.metricUnits,
    required this.languageCode,
    required this.createdAtUtc,
    this.schemaVersion = 1,
  });

  final int schemaVersion;
  final Set<String> favoriteRecipeIds;
  final bool metricUnits;
  final String? languageCode;
  final DateTime createdAtUtc;

  Map<String, Object?> toJson() {
    final List<String> favorites = favoriteRecipeIds.toList()..sort();
    return <String, Object?>{
      'schemaVersion': schemaVersion,
      'createdAtUtc': createdAtUtc.toUtc().toIso8601String(),
      'favoriteRecipeIds': favorites,
      'settings': <String, Object?>{
        'metricUnits': metricUnits,
        'languageCode': languageCode,
      },
    };
  }

  String encode() => jsonEncode(toJson());

  factory TasteBackupPayload.decode(String encoded) {
    final Object? decoded = jsonDecode(encoded);
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException('backup_root_not_object');
    }
    final Map<String, Object?> root = decoded.map(
      (Object? key, Object? value) =>
          MapEntry<String, Object?>(key.toString(), value),
    );
    final int schemaVersion =
        (root['schemaVersion'] as num?)?.toInt() ?? 0;
    if (schemaVersion != 1) {
      throw FormatException('unsupported_backup_schema_$schemaVersion');
    }

    final Object? rawSettings = root['settings'];
    if (rawSettings is! Map<Object?, Object?>) {
      throw const FormatException('backup_settings_missing');
    }
    final Map<String, Object?> settings = rawSettings.map(
      (Object? key, Object? value) =>
          MapEntry<String, Object?>(key.toString(), value),
    );

    final List<Object?> rawFavorites =
        root['favoriteRecipeIds'] as List<Object?>? ??
            const <Object?>[];
    final Set<String> favorites = rawFavorites
        .whereType<String>()
        .where((String id) => id.trim().isNotEmpty)
        .toSet();

    final String? languageCode =
        settings['languageCode']?.toString();
    final DateTime? createdAt = DateTime.tryParse(
      root['createdAtUtc']?.toString() ?? '',
    );
    if (createdAt == null) {
      throw const FormatException('backup_timestamp_invalid');
    }

    return TasteBackupPayload(
      schemaVersion: schemaVersion,
      favoriteRecipeIds: favorites,
      metricUnits: settings['metricUnits'] as bool? ?? true,
      languageCode:
          languageCode == null || languageCode.isEmpty
              ? null
              : languageCode,
      createdAtUtc: createdAt.toUtc(),
    );
  }
}
