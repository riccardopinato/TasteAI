import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    final AppStrings? strings = Localizations.of<AppStrings>(context, AppStrings);
    assert(strings != null, 'AppStrings not found in widget tree.');
    return strings!;
  }

  String _value(String key) {
    final Map<String, String> table = _translations[locale.languageCode] ?? _translations['en']!;
    return table[key] ?? _translations['en']![key] ?? key;
  }

  String get appName => _value('appName');
  String get inspire => _value('inspire');
  String get search => _value('search');
  String get antiWaste => _value('antiWaste');
  String get favorites => _value('favorites');
  String get profile => _value('profile');
  String get searchHint => _value('searchHint');
  String get results => _value('results');
  String get all => _value('all');
  String get filters => _value('filters');
  String get category => _value('category');
  String get difficulty => _value('difficulty');
  String get maxTime => _value('maxTime');
  String get antiWasteOnly => _value('antiWasteOnly');
  String get clearFilters => _value('clearFilters');
  String get noResults => _value('noResults');
  String get noFavorites => _value('noFavorites');
  String offlineRecipeCount(int count) => _value('offlineReady').replaceAll('{count}', '$count');
  String get inspireTitle => _value('inspireTitle');
  String get inspireBody => _value('inspireBody');
  String get inspireAction => _value('inspireAction');
  String get ingredients => _value('ingredients');
  String get preparation => _value('preparation');
  String get chefTips => _value('chefTips');
  String get time => _value('time');
  String get servings => _value('servings');
  String get metric => _value('metric');
  String get imperial => _value('imperial');
  String get language => _value('language');
  String get units => _value('units');
  String get localOnly => _value('localOnly');
  String get antiWasteComing => _value('antiWasteComing');
  String get free => _value('free');
  String get premium => _value('premium');
  String get minutes => _value('minutes');
  String get easy => _value('easy');
  String get medium => _value('medium');
  String get hard => _value('hard');
  String get prep => _value('prep');
  String get cook => _value('cook');
  String get rest => _value('rest');
  String get saved => _value('saved');
  String get removed => _value('removed');
  String get systemDefault => _value('systemDefault');
  String get catalogError => _value('catalogError');
  String get retry => _value('retry');

  String categoryLabel(String category) {
    final String key = 'category_$category';
    final String value = _value(key);
    return value == key ? category.replaceAll('_', ' ') : value;
  }

  String difficultyLabel(String value) {
    if (value == 'easy') return easy;
    if (value == 'hard') return hard;
    return medium;
  }

  String resultCount(int count) => '$results: $count';

  static const Map<String, Map<String, String>> _translations = <String, Map<String, String>>{
    'en': <String, String>{
      'appName': 'TasteAI', 'inspire': 'Inspire me', 'search': 'Search', 'antiWaste': 'Zero waste',
      'favorites': 'Favorites', 'profile': 'Profile', 'searchHint': 'Search recipes, ingredients or techniques…',
      'results': 'Results', 'all': 'All', 'filters': 'Filters', 'category': 'Category', 'difficulty': 'Difficulty',
      'maxTime': 'Max time', 'antiWasteOnly': 'Zero-waste only', 'clearFilters': 'Clear filters',
      'noResults': 'No recipes match these filters.', 'noFavorites': 'No favorites yet.',
      'offlineReady': '{count} recipes available offline', 'inspireTitle': 'Need an idea?',
      'inspireBody': 'Choose a few constraints and TasteAI will pick from the local catalog.', 'inspireAction': 'Inspire me',
      'ingredients': 'Ingredients', 'preparation': 'Preparation', 'chefTips': "Chef's tips", 'time': 'Time',
      'servings': 'Servings', 'metric': 'Metric', 'imperial': 'Imperial', 'language': 'Language', 'units': 'Units',
      'localOnly': 'Local-first. No Gemini or mandatory cloud AI.', 'antiWasteComing': 'The deterministic zero-waste engine arrives in v0.6.',
      'free': 'Free', 'premium': 'Premium', 'minutes': 'min', 'easy': 'Easy', 'medium': 'Medium', 'hard': 'Hard',
      'prep': 'Prep', 'cook': 'Cook', 'rest': 'Rest', 'saved': 'Saved to favorites', 'removed': 'Removed from favorites',
      'systemDefault': 'System', 'catalogError': 'Unable to load the local catalog.', 'retry': 'Retry', 'category_starter': 'Starter', 'category_first_course': 'First course', 'category_main_course': 'Main course',
      'category_dessert': 'Dessert', 'category_side': 'Side',
    },
    'it': <String, String>{
      'appName': 'TasteAI', 'inspire': 'Ispirami', 'search': 'Cerca', 'antiWaste': 'Anti-spreco',
      'favorites': 'Preferiti', 'profile': 'Profilo', 'searchHint': 'Cerca ricette, ingredienti o tecniche…',
      'results': 'Risultati', 'all': 'Tutti', 'filters': 'Filtri', 'category': 'Categoria', 'difficulty': 'Difficoltà',
      'maxTime': 'Tempo massimo', 'antiWasteOnly': 'Solo anti-spreco', 'clearFilters': 'Azzera filtri',
      'noResults': 'Nessuna ricetta corrisponde ai filtri.', 'noFavorites': 'Non hai ancora preferiti.',
      'offlineReady': '{count} ricette disponibili offline', 'inspireTitle': 'Non sai cosa cucinare?',
      'inspireBody': 'Imposta qualche vincolo e TasteAI sceglie dal catalogo locale.', 'inspireAction': 'Ispirami',
      'ingredients': 'Ingredienti', 'preparation': 'Preparazione', 'chefTips': 'Consigli dello chef', 'time': 'Tempo',
      'servings': 'Porzioni', 'metric': 'Metrico', 'imperial': 'Imperiale', 'language': 'Lingua', 'units': 'Unità',
      'localOnly': 'Local-first. Nessun Gemini o AI cloud obbligatoria.', 'antiWasteComing': 'Il motore anti-spreco deterministico arriva nella v0.6.',
      'free': 'Free', 'premium': 'Premium', 'minutes': 'min', 'easy': 'Facile', 'medium': 'Media', 'hard': 'Difficile',
      'prep': 'Prep.', 'cook': 'Cottura', 'rest': 'Riposo', 'saved': 'Salvata nei preferiti', 'removed': 'Rimossa dai preferiti',
      'systemDefault': 'Sistema', 'catalogError': 'Impossibile caricare il catalogo locale.', 'retry': 'Riprova', 'category_starter': 'Antipasto', 'category_first_course': 'Primo', 'category_main_course': 'Secondo',
      'category_dessert': 'Dessert', 'category_side': 'Contorno',
    },
    'es': <String, String>{
      'appName': 'TasteAI', 'inspire': 'Inspírame', 'search': 'Buscar', 'antiWaste': 'Cero desperdicio',
      'favorites': 'Favoritos', 'profile': 'Perfil', 'searchHint': 'Busca recetas, ingredientes o técnicas…',
      'results': 'Resultados', 'all': 'Todos', 'filters': 'Filtros', 'category': 'Categoría', 'difficulty': 'Dificultad',
      'maxTime': 'Tiempo máximo', 'antiWasteOnly': 'Solo anti-desperdicio', 'clearFilters': 'Limpiar filtros',
      'noResults': 'Ninguna receta coincide.', 'noFavorites': 'Aún no tienes favoritos.',
      'offlineReady': '{count} recetas disponibles sin conexión', 'inspireTitle': '¿Necesitas una idea?',
      'inspireBody': 'Elige algunos filtros y TasteAI seleccionará una receta local.', 'inspireAction': 'Inspírame',
      'ingredients': 'Ingredientes', 'preparation': 'Preparación', 'chefTips': 'Consejos del chef', 'time': 'Tiempo',
      'servings': 'Porciones', 'metric': 'Métrico', 'imperial': 'Imperial', 'language': 'Idioma', 'units': 'Unidades',
      'localOnly': 'Local-first. Sin Gemini ni IA cloud obligatoria.', 'antiWasteComing': 'El motor anti-desperdicio determinista llegará en v0.6.',
      'free': 'Gratis', 'premium': 'Premium', 'minutes': 'min', 'easy': 'Fácil', 'medium': 'Media', 'hard': 'Difícil',
      'prep': 'Prep.', 'cook': 'Cocción', 'rest': 'Reposo', 'saved': 'Guardada en favoritos', 'removed': 'Eliminada de favoritos',
      'systemDefault': 'Sistema', 'catalogError': 'No se puede cargar el catálogo local.', 'retry': 'Reintentar', 'category_starter': 'Entrante', 'category_first_course': 'Primer plato', 'category_main_course': 'Segundo plato',
      'category_dessert': 'Postre', 'category_side': 'Guarnición',
    },
    'fr': <String, String>{
      'appName': 'TasteAI', 'inspire': 'Inspirez-moi', 'search': 'Rechercher', 'antiWaste': 'Anti-gaspillage',
      'favorites': 'Favoris', 'profile': 'Profil', 'searchHint': 'Rechercher recettes, ingrédients ou techniques…',
      'results': 'Résultats', 'all': 'Tous', 'filters': 'Filtres', 'category': 'Catégorie', 'difficulty': 'Difficulté',
      'maxTime': 'Temps maximum', 'antiWasteOnly': 'Anti-gaspillage uniquement', 'clearFilters': 'Effacer les filtres',
      'noResults': 'Aucune recette ne correspond.', 'noFavorites': 'Aucun favori pour le moment.',
      'offlineReady': '{count} recettes disponibles hors ligne', 'inspireTitle': 'Besoin d’une idée ?',
      'inspireBody': 'Choisissez quelques critères et TasteAI sélectionnera une recette locale.', 'inspireAction': 'Inspirez-moi',
      'ingredients': 'Ingrédients', 'preparation': 'Préparation', 'chefTips': 'Conseils du chef', 'time': 'Temps',
      'servings': 'Portions', 'metric': 'Métrique', 'imperial': 'Impérial', 'language': 'Langue', 'units': 'Unités',
      'localOnly': 'Local-first. Aucun Gemini ni IA cloud obligatoire.', 'antiWasteComing': 'Le moteur anti-gaspillage déterministe arrive en v0.6.',
      'free': 'Gratuit', 'premium': 'Premium', 'minutes': 'min', 'easy': 'Facile', 'medium': 'Moyenne', 'hard': 'Difficile',
      'prep': 'Prép.', 'cook': 'Cuisson', 'rest': 'Repos', 'saved': 'Ajoutée aux favoris', 'removed': 'Retirée des favoris',
      'systemDefault': 'Système', 'catalogError': 'Impossible de charger le catalogue local.', 'retry': 'Réessayer', 'category_starter': 'Entrée', 'category_first_course': 'Premier plat', 'category_main_course': 'Plat principal',
      'category_dessert': 'Dessert', 'category_side': 'Accompagnement',
    },
    'pt': <String, String>{
      'appName': 'TasteAI', 'inspire': 'Inspire-me', 'search': 'Pesquisar', 'antiWaste': 'Anti-desperdício',
      'favorites': 'Favoritos', 'profile': 'Perfil', 'searchHint': 'Pesquise receitas, ingredientes ou técnicas…',
      'results': 'Resultados', 'all': 'Todas', 'filters': 'Filtros', 'category': 'Categoria', 'difficulty': 'Dificuldade',
      'maxTime': 'Tempo máximo', 'antiWasteOnly': 'Só anti-desperdício', 'clearFilters': 'Limpar filtros',
      'noResults': 'Nenhuma receita corresponde.', 'noFavorites': 'Ainda não há favoritos.',
      'offlineReady': '{count} receitas disponíveis offline', 'inspireTitle': 'Precisa de uma ideia?',
      'inspireBody': 'Escolha alguns critérios e o TasteAI selecionará uma receita local.', 'inspireAction': 'Inspire-me',
      'ingredients': 'Ingredientes', 'preparation': 'Preparação', 'chefTips': 'Dicas do chef', 'time': 'Tempo',
      'servings': 'Porções', 'metric': 'Métrico', 'imperial': 'Imperial', 'language': 'Idioma', 'units': 'Unidades',
      'localOnly': 'Local-first. Sem Gemini ou IA cloud obrigatória.', 'antiWasteComing': 'O motor anti-desperdício determinístico chega na v0.6.',
      'free': 'Grátis', 'premium': 'Premium', 'minutes': 'min', 'easy': 'Fácil', 'medium': 'Média', 'hard': 'Difícil',
      'prep': 'Prep.', 'cook': 'Cozimento', 'rest': 'Repouso', 'saved': 'Salva nos favoritos', 'removed': 'Removida dos favoritos',
      'systemDefault': 'Sistema', 'catalogError': 'Não foi possível carregar o catálogo local.', 'retry': 'Tentar novamente', 'category_starter': 'Entrada', 'category_first_course': 'Primeiro prato', 'category_main_course': 'Prato principal',
      'category_dessert': 'Sobremesa', 'category_side': 'Acompanhamento',
    },
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales.any((Locale item) => item.languageCode == locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) => SynchronousFuture<AppStrings>(AppStrings(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
