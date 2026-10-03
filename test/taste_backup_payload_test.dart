import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/backup/taste_backup_payload.dart';

void main() {
  test('Taste backup payload round-trips deterministically', () {
    final TasteBackupPayload source = TasteBackupPayload(
      favoriteRecipeIds: <String>{'B', 'A'},
      metricUnits: false,
      languageCode: 'it',
      createdAtUtc: DateTime.utc(2026, 9, 29, 12, 0),
    );

    final TasteBackupPayload restored =
        TasteBackupPayload.decode(source.encode());

    expect(restored.schemaVersion, 1);
    expect(restored.favoriteRecipeIds, <String>{'A', 'B'});
    expect(restored.metricUnits, isFalse);
    expect(restored.languageCode, 'it');
    expect(
      restored.createdAtUtc,
      DateTime.utc(2026, 9, 29, 12, 0),
    );
  });

  test('Taste backup rejects unknown schema', () {
    expect(
      () => TasteBackupPayload.decode(
        '{"schemaVersion":99,"createdAtUtc":"2026-09-29T12:00:00Z","favoriteRecipeIds":[],"settings":{}}',
      ),
      throwsFormatException,
    );
  });
}
