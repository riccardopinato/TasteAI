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
  String get antiWasteTitle => _value('antiWasteTitle');
  String get antiWasteBody => _value('antiWasteBody');
  String get antiWasteInputHint => _value('antiWasteInputHint');
  String get antiWasteAnalyze => _value('antiWasteAnalyze');
  String get antiWasteNoMatch => _value('antiWasteNoMatch');
  String get antiWasteMatched => _value('antiWasteMatched');
  String get antiWasteAdditional => _value('antiWasteAdditional');
  String get antiWasteCompatibility => _value('antiWasteCompatibility');
  String antiWasteFound(int count) =>
      _value('antiWasteFound').replaceAll('{count}', '$count');
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
  String get account => _value('account');
  String get googleOptional => _value('googleOptional');
  String get googleNotConfigured => _value('googleNotConfigured');
  String get googleUnsupported => _value('googleUnsupported');
  String get signInGoogle => _value('signInGoogle');
  String get signOut => _value('signOut');
  String get backupSync => _value('backupSync');
  String get backupDescription => _value('backupDescription');
  String get backupNow => _value('backupNow');
  String get restoreBackup => _value('restoreBackup');
  String get syncSuccess => _value('syncSuccess');
  String get noCloudBackup => _value('noCloudBackup');
  String get syncError => _value('syncError');
  String get tasteAiPlus => _value('tasteAiPlus');
  String get plusTitle => _value('plusTitle');
  String get plusBody => _value('plusBody');
  String get plusBenefitPremiumRecipes => _value('plusBenefitPremiumRecipes');
  String get plusBenefitLocalAi => _value('plusBenefitLocalAi');
  String get plusBenefitFutureFeatures => _value('plusBenefitFutureFeatures');
  String get plusActive => _value('plusActive');
  String get plusProfileBody => _value('plusProfileBody');
  String get premiumNotConfigured => _value('premiumNotConfigured');
  String get premiumWebUnavailable => _value('premiumWebUnavailable');
  String get noPremiumPackages => _value('noPremiumPackages');
  String get subscribeFor => _value('subscribeFor');
  String get restorePurchases => _value('restorePurchases');
  String get premiumError => _value('premiumError');
  String get premiumPriceStoreNotice => _value('premiumPriceStoreNotice');

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

  static bool get translationsHaveParity {
    final Set<String> base =
        _translations['en']!.keys.toSet();
    for (final Locale locale in supportedLocales) {
      final Map<String, String>? table =
          _translations[locale.languageCode];
      if (table == null) return false;
      if (!setEquals(base, table.keys.toSet())) return false;
      if (table.values.any((String value) => value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  static const Map<String, Map<String, String>> _translations = <String, Map<String, String>>{
    'en': <String, String>{
      'tasteAiPlus': 'TasteAI Plus', 'plusTitle': 'Unlock TasteAI Plus', 'plusBody': 'Premium recipes and optional local intelligence, without cloud AI fees.', 'plusBenefitPremiumRecipes': 'Access recipes marked Premium', 'plusBenefitLocalAi': 'Optional downloadable local AI when certified', 'plusBenefitFutureFeatures': 'Future Plus features without weakening the free core', 'plusActive': 'TasteAI Plus is active', 'plusProfileBody': 'View Plus options and restore purchases', 'premiumNotConfigured': 'Premium purchases are not configured in this development build.', 'premiumWebUnavailable': 'Store purchases are not available in this Web Preview.', 'noPremiumPackages': 'No purchasable Plus package is currently available from the store.', 'subscribeFor': 'Continue for', 'restorePurchases': 'Restore purchases', 'premiumError': 'The store request could not be completed.', 'premiumPriceStoreNotice': 'Prices and billing periods are provided by the device store.',
      'account': 'Account', 'googleOptional': 'Google Sign-In is optional. TasteAI remains fully usable as a guest.', 'googleNotConfigured': 'Google Sign-In is not configured in this build. Add OAuth client IDs at release time.', 'googleUnsupported': 'Interactive Google Sign-In is not available on this platform build.', 'signInGoogle': 'Sign in with Google', 'signOut': 'Sign out', 'backupSync': 'Backup & sync', 'backupDescription': 'Back up favorites and settings in your private Google Drive app data.', 'backupNow': 'Back up now', 'restoreBackup': 'Restore latest backup', 'syncSuccess': 'Backup data synchronized.', 'noCloudBackup': 'No TasteAI backup found in Google Drive.', 'syncError': 'Unable to complete Google Drive sync.',
      'antiWasteTitle': 'Cook what you already have', 'antiWasteBody': 'Enter leftovers or ingredients from your fridge. TasteAI only ranks grounded recipes from the local catalog.', 'antiWasteInputHint': 'e.g. stale bread, tomatoes, zucchini peels…', 'antiWasteAnalyze': 'Find zero-waste recipes', 'antiWasteNoMatch': 'No grounded zero-waste recipe matches these ingredients yet.', 'antiWasteMatched': 'Matched', 'antiWasteAdditional': 'You may also need', 'antiWasteCompatibility': 'Compatibility', 'antiWasteFound': '{count} grounded suggestions',
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
      'tasteAiPlus': 'TasteAI Plus', 'plusTitle': 'Sblocca TasteAI Plus', 'plusBody': 'Ricette Premium e intelligenza locale opzionale, senza costi di AI cloud.', 'plusBenefitPremiumRecipes': 'Accesso alle ricette contrassegnate Premium', 'plusBenefitLocalAi': 'AI locale scaricabile opzionale quando certificata', 'plusBenefitFutureFeatures': 'Future funzioni Plus senza indebolire il core gratuito', 'plusActive': 'TasteAI Plus è attivo', 'plusProfileBody': 'Visualizza Plus e ripristina gli acquisti', 'premiumNotConfigured': 'Gli acquisti Premium non sono configurati in questa build di sviluppo.', 'premiumWebUnavailable': 'Gli acquisti dallo store non sono disponibili nella Web Preview.', 'noPremiumPackages': 'Lo store non restituisce al momento alcun pacchetto Plus acquistabile.', 'subscribeFor': 'Continua a', 'restorePurchases': 'Ripristina acquisti', 'premiumError': 'Impossibile completare la richiesta allo store.', 'premiumPriceStoreNotice': 'Prezzi e periodi di fatturazione sono forniti dallo store del dispositivo.',
      'account': 'Account', 'googleOptional': 'L’accesso Google è opzionale. TasteAI resta completamente utilizzabile come ospite.', 'googleNotConfigured': 'Google Sign-In non è configurato in questa build. Gli ID OAuth verranno aggiunti in release.', 'googleUnsupported': 'L’accesso Google interattivo non è disponibile in questa build della piattaforma.', 'signInGoogle': 'Accedi con Google', 'signOut': 'Esci', 'backupSync': 'Backup e sincronizzazione', 'backupDescription': 'Salva preferiti e impostazioni nello spazio dati privato di Google Drive.', 'backupNow': 'Esegui backup', 'restoreBackup': 'Ripristina ultimo backup', 'syncSuccess': 'Dati di backup sincronizzati.', 'noCloudBackup': 'Nessun backup TasteAI trovato su Google Drive.', 'syncError': 'Impossibile completare la sincronizzazione Google Drive.',
      'antiWasteTitle': 'Cucina quello che hai già', 'antiWasteBody': 'Inserisci avanzi o ingredienti del frigo. TasteAI ordina solo ricette reali presenti nel catalogo locale.', 'antiWasteInputHint': 'es. pane raffermo, pomodori, bucce di zucchina…', 'antiWasteAnalyze': 'Trova ricette anti-spreco', 'antiWasteNoMatch': 'Non ci sono ancora ricette anti-spreco del catalogo compatibili con questi ingredienti.', 'antiWasteMatched': 'Corrispondenze', 'antiWasteAdditional': 'Potrebbero servire anche', 'antiWasteCompatibility': 'Compatibilità', 'antiWasteFound': '{count} suggerimenti basati sul catalogo',
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
      'tasteAiPlus': 'TasteAI Plus', 'plusTitle': 'Desbloquea TasteAI Plus', 'plusBody': 'Recetas Premium e inteligencia local opcional, sin costes de IA cloud.', 'plusBenefitPremiumRecipes': 'Acceso a recetas marcadas Premium', 'plusBenefitLocalAi': 'IA local descargable opcional cuando esté certificada', 'plusBenefitFutureFeatures': 'Futuras funciones Plus sin debilitar el núcleo gratuito', 'plusActive': 'TasteAI Plus está activo', 'plusProfileBody': 'Ver opciones Plus y restaurar compras', 'premiumNotConfigured': 'Las compras Premium no están configuradas en esta compilación de desarrollo.', 'premiumWebUnavailable': 'Las compras de la tienda no están disponibles en la vista Web.', 'noPremiumPackages': 'La tienda no ofrece actualmente ningún paquete Plus.', 'subscribeFor': 'Continuar por', 'restorePurchases': 'Restaurar compras', 'premiumError': 'No se pudo completar la solicitud a la tienda.', 'premiumPriceStoreNotice': 'Los precios y periodos de facturación los proporciona la tienda del dispositivo.',
      'account': 'Cuenta', 'googleOptional': 'Google Sign-In es opcional. TasteAI funciona completamente como invitado.', 'googleNotConfigured': 'Google Sign-In no está configurado en esta compilación. Los IDs OAuth se añadirán en la versión final.', 'googleUnsupported': 'El acceso interactivo con Google no está disponible en esta compilación.', 'signInGoogle': 'Iniciar sesión con Google', 'signOut': 'Cerrar sesión', 'backupSync': 'Copia y sincronización', 'backupDescription': 'Guarda favoritos y ajustes en los datos privados de Google Drive.', 'backupNow': 'Crear copia ahora', 'restoreBackup': 'Restaurar última copia', 'syncSuccess': 'Datos de copia sincronizados.', 'noCloudBackup': 'No se encontró ninguna copia de TasteAI en Google Drive.', 'syncError': 'No se pudo completar la sincronización con Google Drive.',
      'antiWasteTitle': 'Cocina lo que ya tienes', 'antiWasteBody': 'Introduce sobras o ingredientes. TasteAI solo ordena recetas reales del catálogo local.', 'antiWasteInputHint': 'p. ej. pan duro, tomates, pieles de calabacín…', 'antiWasteAnalyze': 'Buscar recetas anti-desperdicio', 'antiWasteNoMatch': 'Aún no hay una receta del catálogo compatible con estos ingredientes.', 'antiWasteMatched': 'Coincidencias', 'antiWasteAdditional': 'También puedes necesitar', 'antiWasteCompatibility': 'Compatibilidad', 'antiWasteFound': '{count} sugerencias basadas en el catálogo',
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
      'tasteAiPlus': 'TasteAI Plus', 'plusTitle': 'Débloquer TasteAI Plus', 'plusBody': 'Recettes Premium et intelligence locale optionnelle, sans coûts d’IA cloud.', 'plusBenefitPremiumRecipes': 'Accès aux recettes marquées Premium', 'plusBenefitLocalAi': 'IA locale téléchargeable optionnelle une fois certifiée', 'plusBenefitFutureFeatures': 'Fonctions Plus futures sans affaiblir le cœur gratuit', 'plusActive': 'TasteAI Plus est actif', 'plusProfileBody': 'Voir les options Plus et restaurer les achats', 'premiumNotConfigured': 'Les achats Premium ne sont pas configurés dans cette build de développement.', 'premiumWebUnavailable': 'Les achats du store ne sont pas disponibles dans la Web Preview.', 'noPremiumPackages': 'Aucun forfait Plus achetable n’est actuellement proposé.', 'subscribeFor': 'Continuer pour', 'restorePurchases': 'Restaurer les achats', 'premiumError': 'La requête au store n’a pas pu être terminée.', 'premiumPriceStoreNotice': 'Les prix et périodes de facturation sont fournis par le store de l’appareil.',
      'account': 'Compte', 'googleOptional': 'Google Sign-In est facultatif. TasteAI reste entièrement utilisable en mode invité.', 'googleNotConfigured': 'Google Sign-In n’est pas configuré dans cette build. Les identifiants OAuth seront ajoutés à la release.', 'googleUnsupported': 'La connexion Google interactive n’est pas disponible dans cette build.', 'signInGoogle': 'Se connecter avec Google', 'signOut': 'Se déconnecter', 'backupSync': 'Sauvegarde et synchronisation', 'backupDescription': 'Sauvegardez favoris et réglages dans les données privées Google Drive.', 'backupNow': 'Sauvegarder maintenant', 'restoreBackup': 'Restaurer la dernière sauvegarde', 'syncSuccess': 'Données de sauvegarde synchronisées.', 'noCloudBackup': 'Aucune sauvegarde TasteAI trouvée sur Google Drive.', 'syncError': 'Impossible de terminer la synchronisation Google Drive.',
      'antiWasteTitle': 'Cuisinez ce que vous avez déjà', 'antiWasteBody': 'Saisissez vos restes ou ingrédients. TasteAI classe uniquement les recettes réelles du catalogue local.', 'antiWasteInputHint': 'ex. pain rassis, tomates, épluchures de courgette…', 'antiWasteAnalyze': 'Trouver des recettes anti-gaspillage', 'antiWasteNoMatch': 'Aucune recette anti-gaspillage du catalogue ne correspond encore à ces ingrédients.', 'antiWasteMatched': 'Correspondances', 'antiWasteAdditional': 'Il peut aussi falloir', 'antiWasteCompatibility': 'Compatibilité', 'antiWasteFound': '{count} suggestions issues du catalogue',
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
      'tasteAiPlus': 'TasteAI Plus', 'plusTitle': 'Desbloquear TasteAI Plus', 'plusBody': 'Receitas Premium e inteligência local opcional, sem custos de IA cloud.', 'plusBenefitPremiumRecipes': 'Acesso a receitas marcadas Premium', 'plusBenefitLocalAi': 'IA local opcional para download quando certificada', 'plusBenefitFutureFeatures': 'Futuros recursos Plus sem enfraquecer o núcleo gratuito', 'plusActive': 'TasteAI Plus está ativo', 'plusProfileBody': 'Ver opções Plus e restaurar compras', 'premiumNotConfigured': 'As compras Premium não estão configuradas nesta build de desenvolvimento.', 'premiumWebUnavailable': 'As compras da loja não estão disponíveis na Web Preview.', 'noPremiumPackages': 'A loja não oferece atualmente nenhum pacote Plus.', 'subscribeFor': 'Continuar por', 'restorePurchases': 'Restaurar compras', 'premiumError': 'Não foi possível concluir o pedido à loja.', 'premiumPriceStoreNotice': 'Preços e períodos de cobrança são fornecidos pela loja do dispositivo.',
      'account': 'Conta', 'googleOptional': 'O Google Sign-In é opcional. O TasteAI continua totalmente utilizável como convidado.', 'googleNotConfigured': 'O Google Sign-In não está configurado nesta build. Os IDs OAuth serão adicionados na release.', 'googleUnsupported': 'O login interativo do Google não está disponível nesta build.', 'signInGoogle': 'Entrar com Google', 'signOut': 'Sair', 'backupSync': 'Backup e sincronização', 'backupDescription': 'Guarde favoritos e definições nos dados privados do Google Drive.', 'backupNow': 'Fazer backup agora', 'restoreBackup': 'Restaurar último backup', 'syncSuccess': 'Dados de backup sincronizados.', 'noCloudBackup': 'Nenhum backup TasteAI encontrado no Google Drive.', 'syncError': 'Não foi possível concluir a sincronização com o Google Drive.',
      'antiWasteTitle': 'Cozinhe o que já tem', 'antiWasteBody': 'Insira sobras ou ingredientes. O TasteAI classifica apenas receitas reais do catálogo local.', 'antiWasteInputHint': 'ex. pão amanhecido, tomates, cascas de curgete…', 'antiWasteAnalyze': 'Encontrar receitas anti-desperdício', 'antiWasteNoMatch': 'Ainda não há uma receita anti-desperdício do catálogo compatível com estes ingredientes.', 'antiWasteMatched': 'Correspondências', 'antiWasteAdditional': 'Também pode precisar de', 'antiWasteCompatibility': 'Compatibilidade', 'antiWasteFound': '{count} sugestões baseadas no catálogo',
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
