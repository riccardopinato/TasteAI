import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/core/l10n/app_strings.dart';

void main() {
  test('all supported UI locales have complete key parity', () {
    expect(AppStrings.translationsHaveParity, isTrue);
  });
}
