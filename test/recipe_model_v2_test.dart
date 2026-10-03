import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/recipe/recipe.dart';

void main() {
  test('schema v2 ingredient keeps metric and imperial source rows', () {
    final Recipe recipe = Recipe.fromJson(<String, Object?>{
      'id': 'TEST',
      'slug': 'test',
      'localized': <String, Object?>{
        'it': <String, Object?>{
          'title': 'Test',
          'summary': '',
          'instructions': <String>['Cuoci.'],
          'chefTips': '',
        },
      },
      'ingredients': <Object?>[
        <String, Object?>{
          'ingredientId': 'patate',
          'localizedNames': <String, String>{'it': 'Patate', 'en': 'Potatoes'},
          'metric': <String, Object?>{'quantity': 200, 'unit': 'g', 'raw': '200g Patate'},
          'imperial': <String, Object?>{'quantity': 7, 'unit': 'oz', 'raw': '7 oz Potatoes'},
          'optional': false,
          'normalizationConfidence': 'high',
        },
      ],
      'category': 'side',
      'subcategories': <String>['vegan'],
      'tags': <String>[],
      'techniques': <String>[],
      'diets': <String>['vegan'],
      'allergens': <String>[],
      'times': <String, Object?>{'prepMinutes': 5, 'cookMinutes': 10, 'restMinutes': 0},
      'difficulty': 'easy',
      'servings': 2,
      'antiWaste': <String, Object?>{'enabled': false, 'usesScraps': <String>[], 'note': ''},
      'premiumTier': 'free',
      'status': 'ready',
      'searchAliases': <String>[],
    });

    expect(recipe.ingredients.single.nameFor('it'), 'Patate');
    expect(recipe.ingredients.single.amountText(metricUnits: true, languageCode: 'it'), '200 g Patate');
    expect(recipe.ingredients.single.amountText(metricUnits: false, languageCode: 'en'), '7 oz Potatoes');
  });
}
