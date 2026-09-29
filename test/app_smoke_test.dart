import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taste_ai/app/taste_ai_app.dart';

void main() {
  testWidgets('TasteAI app shell renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.pumpWidget(const TasteAiApp());
    await tester.pump();

    expect(find.text('TasteAI'), findsOneWidget);
  });
}
