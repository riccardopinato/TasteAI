import 'package:flutter_test/flutter_test.dart';
import 'package:taste_ai/domain/search/smart_recipe_query.dart';

void main() {
  const SmartRecipeQueryParser parser = SmartRecipeQueryParser();

  test('extracts food terms time and exclusions from natural Italian query', () {
    final SmartRecipeIntent intent = parser.parse(
      'Ho 2 zucchine, ricotta e due uova: qualcosa di veloce senza glutine',
      languageCode: 'it',
    );

    expect(intent.foodTerms, containsAll(<String>['zucchine', 'ricotta', 'uova']));
    expect(intent.retrievalText, 'zucchine ricotta uova');
    expect(intent.maxMinutes, 30);
    expect(intent.excludedAllergens, contains('gluten'));
  });

  test('extracts category diet and explicit time without polluting retrieval text', () {
    final SmartRecipeIntent intent = parser.parse(
      'dessert vegetariano entro 45 minuti',
      languageCode: 'it',
    );

    expect(intent.category, 'dessert');
    expect(intent.requiredDiets, contains('vegetarian'));
    expect(intent.maxMinutes, 45);
    expect(intent.retrievalText, isEmpty);
  });

  test('extracts anti-waste and cooking technique intent', () {
    final SmartRecipeIntent intent = parser.parse(
      'avanzi di patate in friggitrice ad aria',
      languageCode: 'it',
    );

    expect(intent.antiWasteOnly, isTrue);
    expect(intent.requiredTechniques, contains('air_fryer'));
    expect(intent.foodTerms, contains('patate'));
  });
}
