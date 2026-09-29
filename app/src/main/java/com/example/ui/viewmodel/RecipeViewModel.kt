package com.example.ui.viewmodel

import android.app.Application
import android.content.Context
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.BuildConfig
import com.example.data.local.AppDatabase
import com.example.data.model.Recipe
import com.example.data.model.Favorite
import com.example.data.remote.Content
import com.example.data.remote.GenerateContentRequest
import com.example.data.remote.Part
import com.example.data.remote.RetrofitClient
import com.example.data.repository.RecipeRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

sealed interface AssistantUiState {
    object Idle : AssistantUiState
    object Loading : AssistantUiState
    data class Success(
        val title: String,
        val ecoBenefit: String,
        val ingredients: String,
        val preparation: String,
        val chefTips: String
    ) : AssistantUiState
    data class Error(val message: String) : AssistantUiState
}

class RecipeViewModel(application: Application) : AndroidViewModel(application) {

    private val repository: RecipeRepository
    private val sharedPrefs = application.getSharedPreferences("tasteai_prefs", Context.MODE_PRIVATE)

    // UI States
    val recipes: StateFlow<List<Recipe>>
    val favorites: StateFlow<List<Favorite>>

    // Selected Recipe Detail State
    private val _selectedRecipe = MutableStateFlow<Recipe?>(null)
    val selectedRecipe: StateFlow<Recipe?> = _selectedRecipe.asStateFlow()

    // Preferences & Settings
    private val _isMetric = MutableStateFlow(sharedPrefs.getBoolean("is_metric", true))
    val isMetric: StateFlow<Boolean> = _isMetric.asStateFlow()

    private val _isPremiumUnlocked = MutableStateFlow(sharedPrefs.getBoolean("is_premium_unlocked", false))
    val isPremiumUnlocked: StateFlow<Boolean> = _isPremiumUnlocked.asStateFlow()

    private val _userApiKey = MutableStateFlow(sharedPrefs.getString("user_gemini_api_key", "") ?: "")
    val userApiKey: StateFlow<String> = _userApiKey.asStateFlow()

    // Randomizer states
    val categories = listOf("Tutti", "Antipasto", "Primo", "Secondo", "Dessert")
    val subcategories = listOf("Tutti", "Carne", "Pesce", "Vegano", "Pasta", "Risotto", "CBT/Sottovuoto")

    private val _selectedCategory = MutableStateFlow("Tutti")
    val selectedCategory: StateFlow<String> = _selectedCategory.asStateFlow()

    private val _selectedSubcategory = MutableStateFlow("Tutti")
    val selectedSubcategory: StateFlow<String> = _selectedSubcategory.asStateFlow()

    private val _randomizerRunning = MutableStateFlow(false)
    val randomizerRunning: StateFlow<Boolean> = _randomizerRunning.asStateFlow()

    private val _randomizerResult = MutableStateFlow<Recipe?>(null)
    val randomizerResult: StateFlow<Recipe?> = _randomizerResult.asStateFlow()

    // Anti-Spreco assistant states
    private val _assistantState = MutableStateFlow<AssistantUiState>(AssistantUiState.Idle)
    val assistantState: StateFlow<AssistantUiState> = _assistantState.asStateFlow()

    init {
        val database = AppDatabase.getDatabase(application)
        repository = RecipeRepository(database.recipeDao())

        recipes = repository.allRecipes.stateIn(
            scope = viewModelScope,
            started = SharingStarted.Eagerly,
            initialValue = emptyList()
        )

        favorites = repository.allFavorites.stateIn(
            scope = viewModelScope,
            started = SharingStarted.Eagerly,
            initialValue = emptyList()
        )

        viewModelScope.launch {
            repository.prepopulateIfNeeded()
        }
    }

    fun selectRecipe(recipe: Recipe?) {
        _selectedRecipe.value = recipe
    }

    fun toggleMetric() {
        val newVal = !_isMetric.value
        _isMetric.value = newVal
        sharedPrefs.edit().putBoolean("is_metric", newVal).apply()
    }

    fun saveUserApiKey(key: String) {
        _userApiKey.value = key
        sharedPrefs.edit().putString("user_gemini_api_key", key).apply()
    }

    fun unlockPremiumSimulated() {
        _isPremiumUnlocked.value = true
        sharedPrefs.edit().putBoolean("is_premium_unlocked", true).apply()
    }

    fun lockPremiumSimulated() {
        _isPremiumUnlocked.value = false
        sharedPrefs.edit().putBoolean("is_premium_unlocked", false).apply()
    }

    fun setCategoryFilter(category: String) {
        _selectedCategory.value = category
    }

    fun setSubcategoryFilter(sub: String) {
        _selectedSubcategory.value = sub
    }

    // Toggle Favorite
    fun toggleFavorite(recipe: Recipe) {
        viewModelScope.launch {
            repository.toggleFavorite(recipe.id, recipe.category)
        }
    }

    // Randomizer "Ispirami" Animation Logic
    fun triggerRandomizer() {
        viewModelScope.launch {
            val allList = recipes.value
            if (allList.isEmpty()) return@launch

            // Filter according to selections
            val filtered = allList.filter { recipe ->
                val catMatches = _selectedCategory.value == "Tutti" || recipe.category.equals(_selectedCategory.value, ignoreCase = true)
                val subMatches = _selectedSubcategory.value == "Tutti" || recipe.subcategory.contains(_selectedSubcategory.value, ignoreCase = true)
                val premiumAllowed = !recipe.isPremium || _isPremiumUnlocked.value
                catMatches && subMatches && premiumAllowed
            }

            if (filtered.isEmpty()) {
                _randomizerResult.value = null
                return@launch
            }

            _randomizerRunning.value = true
            _randomizerResult.value = null

            // Animate rolling effect: quickly cycle through recipes for a smooth premium experience!
            val duration = 1500L
            val startTime = System.currentTimeMillis()
            var delayMs = 50L

            while (System.currentTimeMillis() - startTime < duration) {
                val tempIndex = (0 until filtered.size).random()
                _randomizerResult.value = filtered[tempIndex]
                delay(delayMs)
                delayMs += 15L // Slow down gradually
            }

            // Stop on final choice
            val finalChoice = filtered.random()
            _randomizerResult.value = finalChoice
            _randomizerRunning.value = false
        }
    }

    // AI Anti-Spreco logic: Supports cloud Gemini AND super-smart local rules engine
    fun analyzeIngredientsAntiWaste(ingredient1: String, ingredient2: String, ingredient3: String) {
        val queryList = listOf(ingredient1.trim().lowercase(), ingredient2.trim().lowercase(), ingredient3.trim().lowercase())
            .filter { it.isNotEmpty() }

        if (queryList.isEmpty()) {
            _assistantState.value = AssistantUiState.Error("Per favore, inserisci almeno un ingrediente.")
            return
        }

        viewModelScope.launch {
            _assistantState.value = AssistantUiState.Loading

            // 1. Check if we have an API Key (either user-defined or injected via BuildConfig)
            var apiKey = _userApiKey.value.trim()
            if (apiKey.isEmpty()) {
                apiKey = BuildConfig.GEMINI_API_KEY.trim()
            }

            // Clean key if placeholder
            val isKeyAvailable = apiKey.isNotEmpty() && apiKey != "MY_GEMINI_API_KEY"

            if (isKeyAvailable) {
                try {
                    val prompt = """
                        Agisci come un Lead AI Architect e chef stellato specializzato nell'app "TasteAI". 
                        L'utente ha inserito questi ingredienti/scarti dal frigo: ${queryList.joinToString(", ")}.
                        Crea una ricetta di upcycling gastronomico di alto livello (stile premium, zero-waste).
                        Il risultato deve essere strutturato ESATTAMENTE in questi 5 capitoli in lingua italiana:
                        
                        [TITOLO]
                        Un nome di ricetta accattivante da food-magazine.
                        
                        [BENEFICI ECO]
                        Stima in litri d'acqua e kg di CO2 risparmiati riutilizzando questi scarti.
                        
                        [INGREDIENTI]
                        Dosi precise per 2 persone con indicazione del sistema metrico (es. grammi) e imperiale (es. once/tazze) affiancati.
                        
                        [PREPARAZIONE]
                        Istruzioni passo-passo brevi e leggibili, ottimizzate per smartphone (utilizza i numeri).
                        
                        [TIPS DELLO CHEF]
                        Consigli tecnici avanzati (es. spiegazione scientifica come reazione di Maillard, emulsione a freddo o CBT).
                    """.trimIndent()

                    val request = GenerateContentRequest(
                        contents = listOf(
                            Content(parts = listOf(Part(text = prompt)))
                        )
                    )

                    val response = withContext(Dispatchers.IO) {
                        RetrofitClient.service.generateContent(apiKey, request)
                    }

                    val rawText = response.candidates?.firstOrNull()?.content?.parts?.firstOrNull()?.text
                    if (rawText != null) {
                        parseGeminiResponse(rawText)
                    } else {
                        // Fallback to local if empty text
                        fallbackToLocalUpcycling(queryList)
                    }
                } catch (e: Exception) {
                    // Fallback to local on API failure
                    fallbackToLocalUpcycling(queryList)
                }
            } else {
                // Key not configured, use local smart engine
                delay(1200) // Simulate chef thinking
                fallbackToLocalUpcycling(queryList)
            }
        }
    }

    private fun parseGeminiResponse(text: String) {
        try {
            // Parse with resilient split rules
            var title = ""
            var ecoBenefit = ""
            var ingredients = ""
            var preparation = ""
            var chefTips = ""

            val sections = text.split(Regex("\\[(?i)(TITOLO|BENEFICI ECO|INGREDIENTI|PREPARAZIONE|TIPS DELLO CHEF|TIPS)\\]"))
            if (sections.size >= 5) {
                title = sections[1].trim().removePrefix(":").removePrefix("\n").trim()
                ecoBenefit = sections[2].trim().removePrefix(":").removePrefix("\n").trim()
                ingredients = sections[3].trim().removePrefix(":").removePrefix("\n").trim()
                preparation = sections[4].trim().removePrefix(":").removePrefix("\n").trim()
                chefTips = if (sections.size > 5) sections[5].trim().removePrefix(":").removePrefix("\n").trim() else ""
            } else {
                // Resilient parsing if formatting differs slightly
                val lines = text.lines()
                title = lines.firstOrNull { it.contains("TITOLO", true) }?.replace(Regex(".*TITOLO:?\\s*", RegexOption.IGNORE_CASE), "") 
                    ?: "Pasticcio Svuotafrigo Gourmet"
                ecoBenefit = lines.filter { it.contains("BENEFICI", true) || it.contains("ECO", true) }.joinToString("\n")
                if (ecoBenefit.isEmpty()) ecoBenefit = "Riduce lo spreco alimentare. Risparmio idrico stimato: 100 litri."
                ingredients = text // fallback
                preparation = "Segui la ricetta classica dell'upcycling."
                chefTips = "Utilizza ingredienti freschi per bilanciare gli scarti."
            }

            _assistantState.value = AssistantUiState.Success(
                title = title.ifEmpty { "Piatto Upcycling Creativo" },
                ecoBenefit = ecoBenefit.ifEmpty { "Risparmio di 150 litri d'acqua virtuale." },
                ingredients = ingredients.ifEmpty { "Utilizza gli scarti inseriti conditi con olio e sale." },
                preparation = preparation.ifEmpty { "Cuocere in padella antiaderente fino a doratura completa." },
                chefTips = chefTips.ifEmpty { "La reazione di Maillard dona sapore di nocciola anche agli elementi più semplici." }
            )
        } catch (e: Exception) {
            _assistantState.value = AssistantUiState.Success(
                title = "Gourmet Upcycling Plate",
                ecoBenefit = "Riduce lo spreco del 100%, risparmiando preziosa acqua virtuale.",
                ingredients = "• Scarti frigo\n• Olio e spezie a scelta",
                preparation = "1. Salta in padella rovente con aglio fresco.\n2. Servi con erbe aromatiche.",
                chefTips = "La marinatura preventiva in olio e scorza d'agrumi nobilita qualsiasi foglia o gambo."
            )
        }
    }

    private fun fallbackToLocalUpcycling(queryList: List<String>) {
        val q = queryList.joinToString(" ")

        // Let's check matches
        val hasBread = q.contains("pane") || q.contains("raffermo")
        val hasPotato = q.contains("patat") || q.contains("buccia") || q.contains("bucce")
        val hasOrange = q.contains("aranc") || q.contains("scorza") || q.contains("scorze")
        val hasAvocado = q.contains("avocad")
        val hasSalmon = q.contains("salmone") || q.contains("pesce")

        when {
            hasPotato -> {
                _assistantState.value = AssistantUiState.Success(
                    title = "Chips di Bucce di Patate Dorate",
                    ecoBenefit = "Risparmio idrico di 50 litri d'acqua dolce e prevenzione del 100% di scarti organici umidi.",
                    ingredients = "• 150g / 5.3 oz Bucce di patata biologiche ben lavate\n• 1 cucchiaio Olio d'oliva\n• Rosmarino freschissimo\n• Sale marino di Cipro q.b.",
                    preparation = "1. Lasciare le bucce in ammollo in acqua fredda per 10 minuti per eliminare l'amido.\n2. Asciugare perfettamente.\n3. Condire con olio, rosmarino e sale.\n4. Cuocere a 200°C (390°F) in friggitrice ad aria per 12-15 minuti fino a renderle super croccanti.",
                    chefTips = "L'asciugatura è fondamentale: l'umidità residua produce vapore, ostacolando una cottura croccante. L'amido eliminato dall'acqua garantisce una doratura stellata."
                )
            }
            hasBread -> {
                _assistantState.value = AssistantUiState.Success(
                    title = "Pappa al Pomodoro Rustica di Recupero",
                    ecoBenefit = "Recuperare il pane raffermo risparmia fino a 250 litri di acqua virtuale per porzione ed evita l'acquisto di grano surplus.",
                    ingredients = "• 300g / 10.5 oz Pane raffermo rustico\n• 500g / 17.6 oz Passata o pomodori pelati\n• 2 Spicchi d'aglio\n• Foglie di basilico fresco\n• Brodo vegetale bollente",
                    preparation = "1. Strofinare le fette di pane con aglio e ridurle in cubetti.\n2. Scaldare olio e aglio in una pentola, aggiungere pomodoro e cuocere per 10 min.\n3. Unire il pane e coprire di brodo caldo.\n4. Cuocere a fuoco lento per 20 min rompendo il pane con una frusta.\n5. Lasciare riposare 15 min prima di servire con olio a crudo.",
                    chefTips = "Il riposo finale a fuoco spento è cruciale per permettere agli amidi del pane di legarsi intimamente con l'acidità dolce del pomodoro, sprigionando aromi ricchissimi."
                )
            }
            hasOrange || hasAvocado -> {
                _assistantState.value = AssistantUiState.Success(
                    title = "Vellutata di Avocado e Scorze d'Arancia Candite",
                    ecoBenefit = "L'upcycling delle scorze di agrumi valorizza oli essenziali ricchi di nutrienti, salvando 80 litri d'acqua.",
                    ingredients = "• 2 Avocado maturi (polpa)\n• 100g / 3.5 oz Cioccolato fondente 70% fuso\n• 30g / 1 oz Scorze d'arancia candite (upcycled)\n• Latte vegetale q.b.",
                    preparation = "1. Frullare la polpa degli avocado maturi con cioccolato fuso e cacao.\n2. Regolare la consistenza con un goccio di latte vegetale fino ad avere una mousse densa.\n3. Trasferire in bicchieri e guarnire con scorze d'arancia tritate fini.\n4. Lasciare rassodare in frigo 1 ora.",
                    chefTips = "Gli oli essenziali dell'arancia candita si sposano divinamente con la ricchezza lipidica naturale dell'avocado, che sostituisce panna e uova senza compromessi di consistenza."
                )
            }
            else -> {
                // Creative generic recipe based on inputs
                val itemTitle = queryList.first().replaceFirstChar { it.uppercase() }
                _assistantState.value = AssistantUiState.Success(
                    title = "Sformato Gourmet Svuotafrigo al Tocco di $itemTitle",
                    ecoBenefit = "Ottimizzazione totale del frigo domestico: riduce l'impronta carbonica familiare di 2.4kg di CO2 equivalenti alla settimana.",
                    ingredients = "• Scarti di ${queryList.joinToString(", ")}\n• 2 Uova fresche biologiche (o fecola per versione vegana)\n• 50g Parmigiano grattugiato (o lievito alimentare)\n• Sale, pepe e olio extravergine",
                    preparation = "1. Scottare gli scarti vegetali sminuzzati in padella con un goccio d'olio e aglio per 5 minuti.\n2. Sbattere le uova in una ciotola con parmigiano, sale e pepe.\n3. Unire gli scarti tiepidi al composto.\n4. Versare in pirottini da muffin oliati.\n5. Cuocere in forno caldo a 180°C (350°F) per 15 minuti finché non saranno gonfi e dorati.",
                    chefTips = "La coagulazione delle uova a 180°C intrappola l'umidità delle verdure di recupero. Se usate scarti coriacei come gambi, frullateli prima di unirli al composto per una texture vellutata."
                )
            }
        }
    }

    // On-the-fly translation function using Gemini with robust fallback
    fun translateText(text: String, targetLanguage: String, callback: (String) -> Unit) {
        if (text.isEmpty() || targetLanguage == "IT") {
            callback(text)
            return
        }

        viewModelScope.launch {
            var apiKey = _userApiKey.value.trim()
            if (apiKey.isEmpty()) {
                apiKey = BuildConfig.GEMINI_API_KEY.trim()
            }

            val isKeyAvailable = apiKey.isNotEmpty() && apiKey != "MY_GEMINI_API_KEY"
            if (isKeyAvailable) {
                try {
                    val prompt = "Translate the following recipe content into ${
                        when (targetLanguage) {
                            "EN" -> "English"
                            "ES" -> "Spanish"
                            "FR" -> "French"
                            "DE" -> "German"
                            else -> "Italian"
                        }
                    }. Return ONLY the translation, with no extra commentary, introduction, or formatting other than bullet points if present:\n\n$text"

                    val request = GenerateContentRequest(
                        contents = listOf(
                            Content(parts = listOf(Part(text = prompt)))
                        )
                    )

                    val response = withContext(Dispatchers.IO) {
                        RetrofitClient.service.generateContent(apiKey, request)
                    }

                    val translated = response.candidates?.firstOrNull()?.content?.parts?.firstOrNull()?.text
                    if (translated != null) {
                        callback(translated.trim())
                        return@launch
                    }
                } catch (e: Exception) {
                    // fall through to fallback
                }
            }
            // Offline/API fallback
            callback(text) // Just return original text if translation fails/not available
        }
    }
}

