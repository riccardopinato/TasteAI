import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taste_ai/app/taste_ai_app.dart';

void main() {
  testWidgets('TasteAI loads the local recipe core', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.pumpWidget(const TasteAiApp());
    await tester.pump();

    for (int i = 0; i < 30 && find.textContaining('111').evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('TasteAI'), findsOneWidget);
    expect(find.textContaining('111'), findsWidgets);
  });
}
