import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/core/design/responsive.dart';
import 'package:taste_ai/core/design/taste_theme.dart';
import 'package:taste_ai/core/l10n/app_strings.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';
import 'package:taste_ai/features/recipes/recipe_widgets.dart';

Recipe _recipe() {
  return const Recipe(
    id: 'ACCESSIBLE_RECIPE',
    slug: 'accessible-recipe',
    localized: <String, LocalizedRecipeText>{
      'en': LocalizedRecipeText(
        title: 'Accessible recipe',
        summary: 'A compact accessibility test recipe.',
        instructions: <String>[
          'Prepare the ingredients.',
          'Cook and serve.',
        ],
      ),
    },
    ingredients: <RecipeIngredient>[
      RecipeIngredient(
        ingredientId: 'tomato',
        localizedNames: <String, String>{
          'en': 'Tomato',
        },
        metric: IngredientAmount(raw: '100 g tomato'),
        imperial: IngredientAmount(raw: '3.5 oz tomato'),
      ),
    ],
    category: 'main_course',
    times: RecipeTimes(
      prepMinutes: 10,
      cookMinutes: 15,
      restMinutes: 5,
    ),
    difficulty: 'easy',
    servings: 2,
    antiWaste: AntiWasteInfo(enabled: false),
    premiumTier: 'free',
  );
}

Widget _app(Widget home, {double textScale = 1}) {
  return MaterialApp(
    theme: TasteTheme.light(),
    locale: const Locale('en'),
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppStrings.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      );
    },
    home: home,
  );
}

void main() {
  testWidgets('favorite control has explicit tooltip and padded target', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: RecipeCard(
            recipe: _recipe(),
            languageCode: 'en',
            favorite: false,
            onOpen: () {},
            onToggleFavorite: () {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Add to favorites'), findsOneWidget);
    final Size buttonSize = tester.getSize(find.byType(IconButton));
    expect(buttonSize.width, greaterThanOrEqualTo(48));
    expect(buttonSize.height, greaterThanOrEqualTo(48));
  });

  testWidgets('recipe detail tolerates large text on a small phone', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(
        RecipeDetailPage(
          recipe: _recipe(),
          languageCode: 'en',
          metricUnits: true,
          favorite: false,
          onToggleFavorite: () {},
        ),
        textScale: 2,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Accessible recipe'), findsWidgets);
  });

  testWidgets('desktop content frame prevents over-wide reading columns', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const Key contentKey = Key('content-frame-child');
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: TasteContentFrame(
            child: ColoredBox(
              key: contentKey,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(contentKey)).width, 980);
  });
}
