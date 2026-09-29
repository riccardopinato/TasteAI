package com.example

import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.*
import androidx.compose.foundation.interaction.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.delay
import com.example.data.model.Recipe
import com.example.data.repository.RecipeTranslations
import com.example.ui.theme.MyApplicationTheme
import com.example.ui.theme.SagePrimary
import com.example.ui.theme.ApricotAccent
import com.example.ui.viewmodel.AssistantUiState
import com.example.ui.viewmodel.RecipeViewModel
import com.example.ui.components.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                TasteAIApp()
            }
        }
    }
}

enum class Tab(
    val title: String, 
    val icon: androidx.compose.ui.graphics.vector.ImageVector
) {
    ISPIRAMI("Ispirami", Icons.Filled.Refresh),
    RICETTE("Cerca", Icons.Filled.Search),
    ASSISTENTE("Anti-Spreco", Icons.Filled.PlayArrow),
    PREFERITI("Preferiti", Icons.Filled.Favorite),
    PREMIUM("Premium", Icons.Filled.Star)
}

@Composable
fun TasteAIApp(viewModel: RecipeViewModel = viewModel()) {
    var currentTab by remember { mutableStateOf(Tab.ISPIRAMI) }
    var showSettings by remember { mutableStateOf(false) }
    var showPurchaseDialog by remember { mutableStateOf(false) }

    val selectedRecipe by viewModel.selectedRecipe.collectAsStateWithLifecycle()
    val isPremiumUnlocked by viewModel.isPremiumUnlocked.collectAsStateWithLifecycle()

    CupertinoScaffold(
        modifier = Modifier
            .fillMaxSize()
            .testTag("app_root"),
        topBar = {
            CupertinoNavigationBar(
                title = "TasteAI",
                leftAction = {
                    // Impostazioni (API Configuration) styled like iOS Settings cog icon
                    CupertinoButton(
                        onClick = { showSettings = true },
                        contentPadding = PaddingValues(8.dp),
                        modifier = Modifier.testTag("settings_top_button")
                    ) {
                        CupertinoIcon(
                            imageVector = Icons.Filled.Settings,
                            contentDescription = "Configurazione API Key",
                            tint = cupertinoBlue()
                        )
                    }
                },
                rightAction = {
                    // Elite Premium status switch indicator with a circular background of 20% opacity, borders and golden star assets
                    val badgeColor = Color(0xFFFBB07E)
                    val bgOpacity = if (isPremiumUnlocked) 0.20f else 0.05f
                    val borderOpacity = if (isPremiumUnlocked) 0.50f else 0.15f
                    val iconTint = if (isPremiumUnlocked) badgeColor else cupertinoSecondaryLabel().copy(alpha = 0.5f)

                    Box(
                        modifier = Modifier
                            .size(36.dp)
                            .clip(CircleShape)
                            .background(badgeColor.copy(alpha = bgOpacity))
                            .border(1.dp, badgeColor.copy(alpha = borderOpacity), CircleShape)
                            .clickable {
                                if (isPremiumUnlocked) viewModel.lockPremiumSimulated() 
                                else viewModel.unlockPremiumSimulated()
                            }
                            .testTag("premium_quick_toggle"),
                        contentAlignment = Alignment.Center
                    ) {
                        CupertinoIcon(
                            imageVector = Icons.Filled.Star,
                            contentDescription = "Premium Mode",
                            tint = iconTint,
                            modifier = Modifier.size(16.dp)
                        )
                    }
                }
            )
        },
        bottomBar = {
            CupertinoTabBar {
                Tab.values().forEach { tab ->
                    CupertinoTabItem(
                        selected = currentTab == tab,
                        onClick = { currentTab = tab },
                        icon = tab.icon,
                        label = tab.title
                    )
                }
            }
        }
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(cupertinoBgGrouped())
        ) {
            // High-fidelity dynamic tab crossfade animation
            AnimatedContent(
                targetState = currentTab,
                transitionSpec = {
                    fadeIn(animationSpec = tween(180)) togetherWith fadeOut(animationSpec = tween(180))
                },
                label = "tab_crossfade"
            ) { tab ->
                when (tab) {
                    Tab.ISPIRAMI -> IspiramiScreen(viewModel, onUnlockClick = { showPurchaseDialog = true })
                    Tab.RICETTE -> RicetteScreen(viewModel, onUnlockClick = { showPurchaseDialog = true })
                    Tab.ASSISTENTE -> AntiSprecoScreen(viewModel)
                    Tab.PREFERITI -> PreferitiScreen(viewModel)
                    Tab.PREMIUM -> PremiumScreen(viewModel, onTriggerPurchase = { showPurchaseDialog = true })
                }
            }

            // Recipe Detail Dialog sheet overlay
            selectedRecipe?.let { recipe ->
                RecipeDetailDialog(
                    recipe = recipe,
                    onDismiss = { viewModel.selectRecipe(null) },
                    viewModel = viewModel
                )
            }

            // Settings Alert dialog
            if (showSettings) {
                SettingsDialog(
                    viewModel = viewModel,
                    onDismiss = { showSettings = false }
                )
            }

            // Simulated App Store payment flow sheet
            if (showPurchaseDialog) {
                SimulatedPurchaseDialog(
                    onDismiss = { showPurchaseDialog = false },
                    onConfirm = {
                        viewModel.unlockPremiumSimulated()
                        showPurchaseDialog = false
                    }
                )
            }
        }
    }
}

// Visual layout card optimized to render exactly on screenshot tests and iOS presentation
@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
            .clip(RoundedCornerShape(14.dp))
            .background(cupertinoBgRow())
            .border(0.5.dp, cupertinoSeparator(), RoundedCornerShape(14.dp))
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            LogoImage(modifier = Modifier.size(54.dp).clip(RoundedCornerShape(12.dp)))
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                CupertinoText(
                    text = "TasteAI Chef App",
                    fontWeight = FontWeight.Bold,
                    style = CupertinoTypography.headline,
                    color = cupertinoLabel()
                )
                Spacer(modifier = Modifier.height(3.dp))
                CupertinoText(
                    text = "Benvenuto, $name! Pronto per l'upcycling gastronomico?",
                    style = CupertinoTypography.footnote,
                    color = cupertinoSecondaryLabel()
                )
            }
        }
    }
}

@Composable
fun LogoImage(modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val hasLogo = remember {
        try {
            context.resources.getDrawable(R.drawable.tasteai_logo, null)
            true
        } catch (e: Exception) {
            false
        }
    }
    if (hasLogo) {
        Image(
            painter = painterResource(id = R.drawable.tasteai_logo),
            contentDescription = "TasteAI Logo",
            modifier = modifier,
            contentScale = ContentScale.Crop
        )
    } else {
        Box(
            modifier = modifier.background(cupertinoBlue(), RoundedCornerShape(12.dp)),
            contentAlignment = Alignment.Center
        ) {
            CupertinoText(
                text = "TA",
                color = Color.White,
                fontWeight = FontWeight.Bold,
                style = CupertinoTypography.title3
            )
        }
    }
}

// ==========================================
// ISPIRAMI TAB SCREEN
// ==========================================
@Composable
fun IspiramiScreen(viewModel: RecipeViewModel, onUnlockClick: () -> Unit) {
    val isPremiumUnlocked by viewModel.isPremiumUnlocked.collectAsStateWithLifecycle()
    val randomizerRunning by viewModel.randomizerRunning.collectAsStateWithLifecycle()
    val randomizerResult by viewModel.randomizerResult.collectAsStateWithLifecycle()
    val selectedCategory by viewModel.selectedCategory.collectAsStateWithLifecycle()
    val selectedSubcategory by viewModel.selectedSubcategory.collectAsStateWithLifecycle()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
            .testTag("ispirami_screen"),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Greeting(name = "Chef")
        }

        item {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(cupertinoBgRow())
                    .border(0.5.dp, cupertinoSeparator(), RoundedCornerShape(16.dp))
                    .padding(16.dp)
            ) {
                CupertinoText(
                    text = "Ispirami! - Ricerca Casuale",
                    fontWeight = FontWeight.Bold,
                    style = CupertinoTypography.title3,
                    color = cupertinoBlue()
                )
                Spacer(modifier = Modifier.height(4.dp))
                CupertinoText(
                    text = "Imposta i tuoi filtri e l'intelligenza artificiale estrarrà il piatto perfetto con un'animazione fluida.",
                    style = CupertinoTypography.footnote,
                    color = cupertinoSecondaryLabel()
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Category selection chips
                CupertinoText(
                    text = "Tipo Pasto",
                    fontWeight = FontWeight.SemiBold,
                    style = CupertinoTypography.subhead,
                    color = cupertinoLabel()
                )
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.padding(vertical = 8.dp)
                ) {
                    items(viewModel.categories) { cat ->
                        val active = selectedCategory == cat
                        val pillBg = if (active) cupertinoBlue() else if (isDark()) Color(0xFF3A3A3C) else Color(0xFFE5E5EA)
                        val textCol = if (active) Color.White else cupertinoLabel()
                        
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(20.dp))
                                .background(pillBg)
                                .clickable { viewModel.setCategoryFilter(cat) }
                                .padding(horizontal = 14.dp, vertical = 6.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CupertinoText(text = cat, style = CupertinoTypography.footnote, color = textCol)
                        }
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Subcategory selection chips
                CupertinoText(
                    text = "Proteina / Base",
                    fontWeight = FontWeight.SemiBold,
                    style = CupertinoTypography.subhead,
                    color = cupertinoLabel()
                )
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.padding(vertical = 8.dp)
                ) {
                    items(viewModel.subcategories) { sub ->
                        val active = selectedSubcategory == sub
                        val pillBg = if (active) cupertinoOrange() else if (isDark()) Color(0xFF3A3A3C) else Color(0xFFE5E5EA)
                        val textCol = if (active) Color.White else cupertinoLabel()
                        
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(20.dp))
                                .background(pillBg)
                                .clickable { viewModel.setSubcategoryFilter(sub) }
                                .padding(horizontal = 14.dp, vertical = 6.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CupertinoText(text = sub, style = CupertinoTypography.footnote, color = textCol)
                        }
                    }
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Ispirami Action button (large iOS system button styled with Apricot Orange)
                CupertinoButton(
                    onClick = { viewModel.triggerRandomizer() },
                    enabled = !randomizerRunning,
                    containerColor = Color(0xFFFBB07E),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp)
                        .testTag("ispirami_button")
                ) {
                    if (randomizerRunning) {
                        CupertinoActivityIndicator(color = Color(0xFF2D2D2D))
                    } else {
                        CupertinoIcon(imageVector = Icons.Filled.Refresh, contentDescription = "Ispirami", tint = Color(0xFF2D2D2D))
                        Spacer(modifier = Modifier.width(8.dp))
                        CupertinoText(
                            text = "Ispirami!",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.headline,
                            color = Color(0xFF2D2D2D)
                        )
                    }
                }
            }
        }

        // Randomizer Result with beautiful iOS HIG transitions
        item {
            AnimatedVisibility(
                visible = randomizerResult != null,
                enter = slideInVertically(animationSpec = spring()) + fadeIn(),
                exit = slideOutVertically() + fadeOut()
            ) {
                randomizerResult?.let { recipe ->
                    Column(modifier = Modifier.fillMaxWidth()) {
                        CupertinoText(
                            text = if (randomizerRunning) "Sincronizzazione..." else "Il tuo Piatto Consigliato",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.subhead,
                            color = cupertinoSecondaryLabel(),
                            modifier = Modifier.padding(bottom = 8.dp, start = 4.dp)
                        )

                        RecipeCard(
                            recipe = recipe,
                            onRecipeClick = { viewModel.selectRecipe(recipe) },
                            onToggleFavorite = { viewModel.toggleFavorite(recipe) },
                            isFavorite = false,
                            isPremiumUnlocked = isPremiumUnlocked,
                            onUnlockClick = onUnlockClick
                        )
                    }
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

// ==========================================
// BROWSE RECIPES TAB SCREEN
// ==========================================
@Composable
fun RicetteScreen(viewModel: RecipeViewModel, onUnlockClick: () -> Unit) {
    val recipes by viewModel.recipes.collectAsStateWithLifecycle()
    val favorites by viewModel.favorites.collectAsStateWithLifecycle()
    val isPremiumUnlocked by viewModel.isPremiumUnlocked.collectAsStateWithLifecycle()
    var searchQuery by remember { mutableStateOf("") }
    var selectedTipo by remember { mutableStateOf("Tutti") }
    var selectedBase by remember { mutableStateOf("Tutti") }

    val filteredRecipes = recipes.filter { recipe ->
        // Search query filter
        val matchesQuery = searchQuery.isEmpty() ||
            recipe.titleItalian.contains(searchQuery, ignoreCase = true) ||
            recipe.category.contains(searchQuery, ignoreCase = true) ||
            recipe.subcategory.contains(searchQuery, ignoreCase = true)

        // Tipo (Category) filter
        val matchesTipo = selectedTipo == "Tutti" || recipe.category.equals(selectedTipo, ignoreCase = true)

        // Base ingredient filter
        val matchesBase = selectedBase == "Tutti" || when (selectedBase) {
            "Zucca" -> recipe.titleItalian.contains("zucca", ignoreCase = true) || recipe.ingredientsMetric.contains("zucca", ignoreCase = true) || recipe.tags.contains("zucca", ignoreCase = true)
            "Zucchine" -> recipe.titleItalian.contains("zucchin", ignoreCase = true) || recipe.ingredientsMetric.contains("zucchin", ignoreCase = true) || recipe.tags.contains("zucchine", ignoreCase = true)
            "Funghi" -> recipe.titleItalian.contains("fungh", ignoreCase = true) || recipe.titleItalian.contains("porcin", ignoreCase = true) || recipe.titleItalian.contains("finferl", ignoreCase = true) || recipe.ingredientsMetric.contains("fungh", ignoreCase = true) || recipe.tags.contains("funghi", ignoreCase = true)
            "Salmone" -> recipe.titleItalian.contains("salmon", ignoreCase = true) || recipe.ingredientsMetric.contains("salmon", ignoreCase = true) || recipe.tags.contains("salmone", ignoreCase = true)
            "Tonno" -> recipe.titleItalian.contains("tonno", ignoreCase = true) || recipe.ingredientsMetric.contains("tonno", ignoreCase = true) || recipe.tags.contains("tonno", ignoreCase = true)
            "Gamberi" -> recipe.titleItalian.contains("gamber", ignoreCase = true) || recipe.ingredientsMetric.contains("gamber", ignoreCase = true) || recipe.tags.contains("gamberi", ignoreCase = true) || recipe.tags.contains("gamber", ignoreCase = true)
            "Frutti di Mare" -> recipe.titleItalian.contains("mare", ignoreCase = true) || recipe.titleItalian.contains("pescat", ignoreCase = true) || recipe.titleItalian.contains("cozz", ignoreCase = true) || recipe.titleItalian.contains("vongol", ignoreCase = true) || recipe.titleItalian.contains("capesant", ignoreCase = true) || recipe.titleItalian.contains("merluzz", ignoreCase = true) || recipe.titleItalian.contains("seppi", ignoreCase = true) || recipe.titleItalian.contains("calamar", ignoreCase = true) || recipe.tags.contains("pesce", ignoreCase = true)
            "Carne" -> recipe.titleItalian.contains("carne", ignoreCase = true) || recipe.titleItalian.contains("pollo", ignoreCase = true) || recipe.titleItalian.contains("vitell", ignoreCase = true) || recipe.titleItalian.contains("maial", ignoreCase = true) || recipe.titleItalian.contains("salsicci", ignoreCase = true) || recipe.titleItalian.contains("tastasal", ignoreCase = true) || recipe.titleItalian.contains("tacchin", ignoreCase = true) || recipe.titleItalian.contains("agnell", ignoreCase = true) || recipe.titleItalian.contains("manzo", ignoreCase = true) || recipe.titleItalian.contains("speck", ignoreCase = true) || recipe.titleItalian.contains("bacon", ignoreCase = true) || recipe.titleItalian.contains("pancett", ignoreCase = true) || recipe.titleItalian.contains("lardo", ignoreCase = true) || recipe.tags.contains("carne", ignoreCase = true)
            "Cioccolato" -> recipe.titleItalian.contains("cioccolat", ignoreCase = true) || recipe.titleItalian.contains("mousse", ignoreCase = true) || recipe.titleItalian.contains("crostata", ignoreCase = true) || recipe.titleItalian.contains("strudel", ignoreCase = true) || recipe.titleItalian.contains("torta", ignoreCase = true) || recipe.titleItalian.contains("semifreddo", ignoreCase = true) || recipe.titleItalian.contains("tartufin", ignoreCase = true) || recipe.titleItalian.contains("nutella", ignoreCase = true) || recipe.tags.contains("cioccolato", ignoreCase = true)
            "Carciofi" -> recipe.titleItalian.contains("carciof", ignoreCase = true) || recipe.ingredientsMetric.contains("carciof", ignoreCase = true) || recipe.tags.contains("carciofi", ignoreCase = true)
            "Melanzane" -> recipe.titleItalian.contains("melanzan", ignoreCase = true) || recipe.ingredientsMetric.contains("melanzan", ignoreCase = true) || recipe.tags.contains("melanzane", ignoreCase = true)
            "Patate" -> recipe.titleItalian.contains("patat", ignoreCase = true) || recipe.ingredientsMetric.contains("patat", ignoreCase = true) || recipe.tags.contains("patate", ignoreCase = true)
            else -> false
        }

        matchesQuery && matchesTipo && matchesBase
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
            .testTag("ricette_screen")
    ) {
        Spacer(modifier = Modifier.height(16.dp))
        
        // Search bar styled strictly like a native iOS UISearchBar
        CupertinoTextField(
            value = searchQuery,
            onValueChange = { searchQuery = it },
            placeholder = "Cerca ricette gourmet o tecniche...",
            leadingIcon = {
                CupertinoIcon(Icons.Filled.Search, contentDescription = "Cerca", tint = cupertinoSecondaryLabel(), modifier = Modifier.size(18.dp))
            },
            trailingIcon = {
                if (searchQuery.isNotEmpty()) {
                    CupertinoButton(
                        onClick = { searchQuery = "" },
                        contentPadding = PaddingValues(0.dp)
                    ) {
                        CupertinoIcon(Icons.Filled.Clear, contentDescription = "Cancella", tint = cupertinoSecondaryLabel(), modifier = Modifier.size(16.dp))
                    }
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .testTag("recipe_search_input")
        )

        Spacer(modifier = Modifier.height(12.dp))

        // Row 1: Tipo di Piatto (Category Filter)
        CupertinoText(
            text = "Tipo di Piatto",
            style = CupertinoTypography.footnote,
            fontWeight = FontWeight.Bold,
            color = cupertinoSecondaryLabel(),
            modifier = Modifier.padding(start = 4.dp, bottom = 6.dp)
        )
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 12.dp)
        ) {
            val tipi = listOf("Tutti", "Antipasto", "Primo", "Secondo", "Dessert", "Contorno")
            items(tipi) { tipo ->
                val selected = selectedTipo == tipo
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (selected) SagePrimary.copy(alpha = 0.15f) else cupertinoBgRow())
                        .border(1.dp, if (selected) SagePrimary else cupertinoSeparator(), RoundedCornerShape(12.dp))
                        .clickable { selectedTipo = tipo }
                        .padding(horizontal = 14.dp, vertical = 6.dp)
                ) {
                    CupertinoText(
                        text = tipo,
                        style = CupertinoTypography.footnote,
                        fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal,
                        color = if (selected) SagePrimary else cupertinoLabel()
                    )
                }
            }
        }

        // Row 2: Ingrediente Base (Base Ingredient Filter)
        CupertinoText(
            text = "Ingrediente Base",
            style = CupertinoTypography.footnote,
            fontWeight = FontWeight.Bold,
            color = cupertinoSecondaryLabel(),
            modifier = Modifier.padding(start = 4.dp, bottom = 6.dp)
        )
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 16.dp)
        ) {
            val basi = listOf("Tutti", "Zucca", "Zucchine", "Funghi", "Salmone", "Tonno", "Gamberi", "Frutti di Mare", "Carne", "Cioccolato", "Carciofi", "Melanzane", "Patate")
            items(basi) { base ->
                val selected = selectedBase == base
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (selected) ApricotAccent.copy(alpha = 0.15f) else cupertinoBgRow())
                        .border(1.dp, if (selected) ApricotAccent else cupertinoSeparator(), RoundedCornerShape(12.dp))
                        .clickable { selectedBase = base }
                        .padding(horizontal = 14.dp, vertical = 6.dp)
                ) {
                    CupertinoText(
                        text = base,
                        style = CupertinoTypography.footnote,
                        fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal,
                        color = if (selected) ApricotAccent else cupertinoLabel()
                    )
                }
            }
        }

        CupertinoText(
            text = "Menu Gastronomico (${filteredRecipes.size})",
            fontWeight = FontWeight.Bold,
            style = CupertinoTypography.subhead,
            color = cupertinoSecondaryLabel(),
            modifier = Modifier.padding(bottom = 8.dp, start = 4.dp)
        )

        if (filteredRecipes.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    CupertinoIcon(
                        imageVector = Icons.Filled.Info,
                        contentDescription = "Nessuna ricetta",
                        tint = cupertinoSecondaryLabel(),
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    CupertinoText(
                        text = "Nessuna ricetta corrisponde ai filtri selezionati.",
                        style = CupertinoTypography.footnote,
                        color = cupertinoSecondaryLabel()
                    )
                }
            }
        } else {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.weight(1f)
            ) {
                items(filteredRecipes) { recipe ->
                    val isFav = favorites.any { it.recipeId == recipe.id }
                    RecipeCard(
                        recipe = recipe,
                        onRecipeClick = { viewModel.selectRecipe(recipe) },
                        onToggleFavorite = { viewModel.toggleFavorite(recipe) },
                        isFavorite = isFav,
                        isPremiumUnlocked = isPremiumUnlocked,
                        onUnlockClick = onUnlockClick
                    )
                }
                item {
                    Spacer(modifier = Modifier.height(24.dp))
                }
            }
        }
    }
}

// ==========================================
// ANTI-SPRECO TAB SCREEN (AI ASSISTANT)
// ==========================================
@Composable
fun AntiSprecoScreen(viewModel: RecipeViewModel) {
    val keyboardController = LocalSoftwareKeyboardController.current
    val assistantState by viewModel.assistantState.collectAsStateWithLifecycle()

    var ing1 by remember { mutableStateOf("") }
    var ing2 by remember { mutableStateOf("") }
    var ing3 by remember { mutableStateOf("") }

    val chefSayings = listOf(
        "L'upcycling gastronomico estrae sapori inattesi dagli scarti nobili...",
        "Le bucce di patata contengono gran parte dell'amido e aromi terrosi ideali...",
        "Il pane raffermo possiede una consistenza perfetta per legare salse stellate...",
        "La reazione di Maillard trasforma scarti organici in piccoli capolavori...",
        "Le scorze di arancia racchiudono preziosissimi oli essenziali candibili..."
    )

    var currentSayingIndex by remember { mutableStateOf(0) }
    LaunchedEffect(assistantState) {
        if (assistantState is AssistantUiState.Loading) {
            while (true) {
                delay(2500)
                currentSayingIndex = (currentSayingIndex + 1) % chefSayings.size
            }
        }
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
            .testTag("anti_waste_screen"),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(8.dp))
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(14.dp))
                    .background(cupertinoBlue().copy(alpha = 0.08f))
                    .border(0.5.dp, cupertinoBlue().copy(alpha = 0.2f), RoundedCornerShape(14.dp))
                    .padding(16.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    CupertinoIcon(
                        imageVector = Icons.Filled.CheckCircle,
                        contentDescription = "Zero Waste",
                        tint = cupertinoBlue(),
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Column {
                        CupertinoText(
                            text = "Assistente Anti-Spreco IA",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.headline,
                            color = cupertinoBlue()
                        )
                        Spacer(modifier = Modifier.height(2.dp))
                        CupertinoText(
                            text = "Inserisci fino a 3 ingredienti o scarti (es. 'bucce di patata', 'pane raffermo') e l'IA ricette calcolerà una ricetta ad-hoc stimando il risparmio ecologico.",
                            style = CupertinoTypography.caption1,
                            color = cupertinoLabel()
                        )
                    }
                }
            }
        }

        // Beautiful iOS Rounded Group Inputs Form
        item {
            CupertinoFormSection(
                title = "I Tuoi Ingredienti Disponibili",
                modifier = Modifier.padding(horizontal = 0.dp) // align naturally
            ) {
                Box(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    CupertinoTextField(
                        value = ing1,
                        onValueChange = { ing1 = it },
                        placeholder = "Ingrediente / Scarto 1 (es. Bucce di patata)",
                        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                        modifier = Modifier.testTag("ingredient_input_1")
                    )
                }
                CupertinoSeparator()
                Box(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    CupertinoTextField(
                        value = ing2,
                        onValueChange = { ing2 = it },
                        placeholder = "Ingrediente / Scarto 2 (es. Pane raffermo)",
                        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                        modifier = Modifier.testTag("ingredient_input_2")
                    )
                }
                CupertinoSeparator()
                Box(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    CupertinoTextField(
                        value = ing3,
                        onValueChange = { ing3 = it },
                        placeholder = "Ingrediente 3 (Opzionale, es. Scorza arancia)",
                        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                        keyboardActions = KeyboardActions(onDone = { keyboardController?.hide() }),
                        modifier = Modifier.testTag("ingredient_input_3")
                    )
                }
                
                CupertinoSeparator()
                
                // Form action row with iOS button
                Box(modifier = Modifier.padding(16.dp)) {
                    CupertinoButton(
                        onClick = {
                            keyboardController?.hide()
                            viewModel.analyzeIngredientsAntiWaste(ing1, ing2, ing3)
                        },
                        containerColor = cupertinoBlue(),
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp)
                            .testTag("anti_waste_generate")
                    ) {
                        CupertinoIcon(imageVector = Icons.Filled.Check, contentDescription = "Genera", tint = Color.White)
                        Spacer(modifier = Modifier.width(8.dp))
                        CupertinoText(
                            text = "Genera Ricetta Sostenibile",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.headline,
                            color = Color.White
                        )
                    }
                }
            }
        }

        // Output results container
        item {
            when (val state = assistantState) {
                is AssistantUiState.Idle -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 32.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CupertinoText(
                            text = "L'assistente è pronto ad aiutarti.",
                            style = CupertinoTypography.footnote,
                            color = cupertinoSecondaryLabel()
                        )
                    }
                }
                is AssistantUiState.Loading -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(16.dp))
                            .background(cupertinoBgRow())
                            .border(0.5.dp, cupertinoSeparator(), RoundedCornerShape(16.dp))
                            .padding(24.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            CupertinoActivityIndicator(size = 36.dp)
                            Spacer(modifier = Modifier.height(16.dp))
                            CupertinoText(
                                text = "L'Intelligenza Artificiale sta elaborando...",
                                fontWeight = FontWeight.Bold,
                                style = CupertinoTypography.headline,
                                color = cupertinoBlue()
                            )
                            Spacer(modifier = Modifier.height(10.dp))
                            AnimatedContent(
                                targetState = currentSayingIndex,
                                transitionSpec = {
                                    fadeIn() togetherWith fadeOut()
                                },
                                label = "insight_transition"
                            ) { idx ->
                                CupertinoText(
                                    text = chefSayings[idx],
                                    style = CupertinoTypography.subhead,
                                    fontStyle = FontStyle.Italic,
                                    textAlign = TextAlign.Center,
                                    color = cupertinoSecondaryLabel(),
                                    modifier = Modifier.padding(horizontal = 16.dp)
                                )
                            }
                        }
                    }
                }
                is AssistantUiState.Success -> {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(16.dp))
                            .background(cupertinoBgRow())
                            .border(0.5.dp, cupertinoBlue().copy(alpha = 0.3f), RoundedCornerShape(16.dp))
                            .padding(20.dp)
                    ) {
                        // Header and ECO stamp
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.Top
                        ) {
                            CupertinoText(
                                text = state.title,
                                fontWeight = FontWeight.Black,
                                style = CupertinoTypography.title3,
                                color = cupertinoBlue(),
                                modifier = Modifier.weight(1f)
                            )
                            CupertinoBadge(
                                text = "ECO UP",
                                color = cupertinoGreen(),
                                textColor = Color.White
                            )
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        // Eco benefits box
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .background(cupertinoGreen().copy(alpha = 0.08f))
                                .padding(12.dp)
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                CupertinoIcon(imageVector = Icons.Filled.Star, contentDescription = "Eco Benefit", tint = cupertinoGreen(), modifier = Modifier.size(20.dp))
                                Spacer(modifier = Modifier.width(10.dp))
                                CupertinoText(
                                    text = state.ecoBenefit,
                                    style = CupertinoTypography.footnote,
                                    fontWeight = FontWeight.Medium,
                                    color = cupertinoGreen()
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        CupertinoText("Ingredienti & Dosi", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                        Spacer(modifier = Modifier.height(4.dp))
                        CupertinoText(
                            text = state.ingredients,
                            style = CupertinoTypography.body,
                            color = cupertinoLabel()
                        )

                        Spacer(modifier = Modifier.height(16.dp))

                        CupertinoText("Preparazione Passo-Passo", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                        Spacer(modifier = Modifier.height(4.dp))
                        CupertinoText(
                            text = state.preparation,
                            style = CupertinoTypography.body,
                            color = cupertinoLabel()
                        )

                        Spacer(modifier = Modifier.height(16.dp))

                        // Chef's secrets card panel
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .background(cupertinoOrange().copy(alpha = 0.08f))
                                .border(0.5.dp, cupertinoOrange().copy(alpha = 0.2f), RoundedCornerShape(12.dp))
                                .padding(12.dp)
                        ) {
                            Column {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    CupertinoIcon(imageVector = Icons.Filled.Star, contentDescription = "Chef Tips", tint = cupertinoOrange(), modifier = Modifier.size(16.dp))
                                    Spacer(modifier = Modifier.width(6.dp))
                                    CupertinoText("Segreto dello Chef", fontWeight = FontWeight.Bold, style = CupertinoTypography.subhead, color = cupertinoOrange())
                                }
                                Spacer(modifier = Modifier.height(6.dp))
                                CupertinoText(
                                    text = state.chefTips,
                                    style = CupertinoTypography.footnote,
                                    color = cupertinoLabel()
                                )
                            }
                        }
                    }
                }
                is AssistantUiState.Error -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(cupertinoRed().copy(alpha = 0.1f))
                            .border(0.5.dp, cupertinoRed().copy(alpha = 0.2f), RoundedCornerShape(12.dp))
                            .padding(16.dp)
                    ) {
                        CupertinoText(
                            text = state.message,
                            color = cupertinoRed(),
                            style = CupertinoTypography.subhead
                        )
                    }
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

// ==========================================
// FAVORITES TAB SCREEN (FOLDER SYSTEM)
// ==========================================
@Composable
fun PreferitiScreen(viewModel: RecipeViewModel) {
    val recipes by viewModel.recipes.collectAsStateWithLifecycle()
    val favorites by viewModel.favorites.collectAsStateWithLifecycle()
    val isPremiumUnlocked by viewModel.isPremiumUnlocked.collectAsStateWithLifecycle()

    var expandedFolder by remember { mutableStateOf<String?>(null) }

    // Map favorites to recipes
    val favoritedRecipes = recipes.filter { recipe -> favorites.any { fav -> fav.recipeId == recipe.id } }

    // Sort favorited recipes into folders (automatically grouped by Category)
    val folders = favoritedRecipes.groupBy { recipe ->
        if (recipe.subcategory.contains("CBT", ignoreCase = true)) "CBT" else recipe.category
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
            .testTag("favorites_screen"),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            CupertinoText(
                text = "Cartelle Automatiche Preferiti",
                fontWeight = FontWeight.Black,
                style = CupertinoTypography.title2,
                color = cupertinoBlue()
            )
            Spacer(modifier = Modifier.height(4.dp))
            CupertinoText(
                text = "I tuoi piatti salvati vengono organizzati e smistati in automatico nel loro archivio specifico.",
                style = CupertinoTypography.footnote,
                color = cupertinoSecondaryLabel()
            )
        }

        if (folders.isEmpty()) {
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 64.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        CupertinoIcon(
                            imageVector = Icons.Filled.Favorite,
                            contentDescription = "Vuoto",
                            tint = cupertinoSecondaryLabel().copy(alpha = 0.3f),
                            modifier = Modifier.size(56.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        CupertinoText(
                            text = "Non hai ancora salvato alcuna ricetta.",
                            style = CupertinoTypography.footnote,
                            color = cupertinoSecondaryLabel()
                        )
                    }
                }
            }
        } else {
            // Render beautiful iOS-style expandable table views
            folders.forEach { (folderName, list) ->
                val isExpanded = expandedFolder == folderName
                item {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(14.dp))
                            .background(cupertinoBgRow())
                            .border(0.5.dp, cupertinoSeparator(), RoundedCornerShape(14.dp))
                    ) {
                        // Folder Row header
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable { expandedFolder = if (isExpanded) null else folderName }
                                .padding(16.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                CupertinoIcon(
                                    imageVector = Icons.Filled.Favorite,
                                    contentDescription = "Cartella",
                                    tint = if (isExpanded) cupertinoBlue() else cupertinoSecondaryLabel(),
                                    modifier = Modifier.size(24.dp)
                                )
                                Spacer(modifier = Modifier.width(12.dp))
                                Column {
                                    CupertinoText(
                                        text = folderName,
                                        fontWeight = FontWeight.Bold,
                                        style = CupertinoTypography.headline,
                                        color = if (isExpanded) cupertinoBlue() else cupertinoLabel()
                                    )
                                    CupertinoText(
                                        text = "Smistamento automatico: $folderName",
                                        style = CupertinoTypography.caption2,
                                        color = cupertinoSecondaryLabel()
                                    )
                                }
                            }
                            
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(6.dp))
                                    .background(cupertinoBlue().copy(alpha = 0.1f))
                                    .padding(horizontal = 8.dp, vertical = 3.dp)
                            ) {
                                CupertinoText(
                                    text = "${list.size} piatti",
                                    fontWeight = FontWeight.Bold,
                                    style = CupertinoTypography.caption2,
                                    color = cupertinoBlue()
                                )
                            }
                        }

                        // Expandable rows section
                        AnimatedVisibility(visible = isExpanded) {
                            Column {
                                Box(modifier = Modifier.fillMaxWidth().height(0.5.dp).background(cupertinoSeparator()))
                                list.forEachIndexed { idx, r ->
                                    Row(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .clickable { viewModel.selectRecipe(r) }
                                            .padding(horizontal = 16.dp, vertical = 12.dp),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            Box(
                                                modifier = Modifier
                                                    .size(8.dp)
                                                    .background(cupertinoBlue(), CircleShape)
                                            )
                                            Spacer(modifier = Modifier.width(12.dp))
                                            CupertinoText(
                                                text = r.titleItalian,
                                                style = CupertinoTypography.body,
                                                color = cupertinoLabel(),
                                                maxLines = 1,
                                                overflow = TextOverflow.Ellipsis
                                            )
                                        }
                                        
                                        // Left aligned details arrows
                                        CupertinoIcon(
                                            imageVector = Icons.Filled.ArrowBack,
                                            contentDescription = "Dettaglio",
                                            tint = cupertinoSecondaryLabel(),
                                            modifier = Modifier.size(14.dp).rotate(180f)
                                        )
                                    }
                                    if (idx < list.size - 1) {
                                        CupertinoSeparator()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

// ==========================================
// PREMIUM ELITE PERKS SCREEN
// ==========================================
@Composable
fun PremiumScreen(viewModel: RecipeViewModel, onTriggerPurchase: () -> Unit) {
    val isPremiumUnlocked by viewModel.isPremiumUnlocked.collectAsStateWithLifecycle()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .testTag("premium_screen"),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        item {
            Spacer(modifier = Modifier.height(24.dp))
            Box(
                modifier = Modifier
                    .background(
                        Brush.verticalGradient(
                            colors = listOf(cupertinoOrange().copy(alpha = 0.15f), Color.Transparent)
                        ),
                        RoundedCornerShape(32.dp)
                    )
                    .padding(32.dp),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    CupertinoIcon(
                        imageVector = Icons.Filled.Star,
                        contentDescription = "TasteAI Elite",
                        tint = cupertinoOrange(),
                        modifier = Modifier
                            .size(72.dp)
                            .rotate(15f)
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    CupertinoText(
                        text = "TasteAI Elite",
                        fontWeight = FontWeight.Black,
                        style = CupertinoTypography.title1,
                        color = cupertinoLabel(),
                        textAlign = TextAlign.Center
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    CupertinoText(
                        text = "SBLOCCA IL MASSIMO POTENZIALE GASTRONOMICO",
                        fontWeight = FontWeight.Bold,
                        style = CupertinoTypography.caption2,
                        color = cupertinoOrange(),
                        textAlign = TextAlign.Center
                    )
                }
            }
        }

        item {
            CupertinoFormSection(
                title = "Vantaggi Esclusivi Elite"
            ) {
                PremiumFeatureRow(
                    title = "Ricette Gourmet di Pesce",
                    desc = "Salmone CBT, ostriche a infusione, aragosta sous-vide e piatti lussuosi.",
                    isLast = false
                )
                PremiumFeatureRow(
                    title = "Tecniche CBT / Sottovuoto Avanzate",
                    desc = "Tempi esatti e temperature scientifiche per cotture incredibili.",
                    isLast = false
                )
                PremiumFeatureRow(
                    title = "Cucina Internazionale Stellata",
                    desc = "Traduzione completa in 6 lingue e preparazioni stellate.",
                    isLast = false
                )
                PremiumFeatureRow(
                    title = "Cloud AI Svuotafrigo Illimitato",
                    desc = "Accedi a Gemini 3.5 Flash per ricette di upcycling ad alta precisione.",
                    isLast = true
                )
            }
        }

        item {
            if (isPremiumUnlocked) {
                Column(
                    modifier = Modifier.padding(24.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .background(cupertinoGreen().copy(alpha = 0.1f))
                            .padding(16.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CupertinoText(
                            text = "TASTEAI PREMIUM ATTIVO!\nSei un membro Elite.",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.headline,
                            color = cupertinoGreen(),
                            textAlign = TextAlign.Center
                        )
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                    CupertinoButton(
                        onClick = { viewModel.lockPremiumSimulated() },
                        containerColor = cupertinoRed()
                    ) {
                        CupertinoText("Disattiva Abbonamento (Simulazione)", color = Color.White, style = CupertinoTypography.subhead)
                    }
                }
            } else {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    CupertinoButton(
                        onClick = onTriggerPurchase,
                        containerColor = cupertinoOrange(),
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(54.dp)
                            .testTag("premium_purchase_button")
                    ) {
                        CupertinoText(
                            text = "Unisciti a TasteAI Elite a $19.99/anno",
                            fontWeight = FontWeight.Bold,
                            style = CupertinoTypography.headline,
                            color = Color.White
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    CupertinoText(
                        text = "Oppure sblocca subito come sviluppatore per testare l'app:",
                        style = CupertinoTypography.caption2,
                        color = cupertinoSecondaryLabel()
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    CupertinoButton(
                        onClick = { viewModel.unlockPremiumSimulated() },
                        containerColor = cupertinoBlue()
                    ) {
                        CupertinoText("Sblocca Istantaneamente", fontWeight = FontWeight.SemiBold, color = Color.White)
                    }
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
fun PremiumFeatureRow(title: String, desc: String, isLast: Boolean) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalAlignment = Alignment.Top
    ) {
        CupertinoIcon(
            imageVector = Icons.Filled.Check,
            contentDescription = "Sbloccato",
            tint = cupertinoOrange(),
            modifier = Modifier.size(20.dp)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            CupertinoText(
                text = title,
                fontWeight = FontWeight.Bold,
                style = CupertinoTypography.headline,
                color = cupertinoLabel()
            )
            Spacer(modifier = Modifier.height(2.dp))
            CupertinoText(
                text = desc,
                style = CupertinoTypography.footnote,
                color = cupertinoSecondaryLabel()
            )
        }
    }
    if (!isLast) {
        CupertinoSeparator()
    }
}

// ==========================================
// HIGH-FIDELITY SHARED RECIPE CARD
// ==========================================
@Composable
fun RecipeCard(
    recipe: Recipe,
    onRecipeClick: () -> Unit,
    onToggleFavorite: () -> Unit,
    isFavorite: Boolean,
    isPremiumUnlocked: Boolean,
    onUnlockClick: () -> Unit
) {
    val isLocked = recipe.isPremium && !isPremiumUnlocked

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(cupertinoBgRow())
            .border(
                0.5.dp, 
                if (isLocked) cupertinoOrange().copy(alpha = 0.4f) else cupertinoSeparator(), 
                RoundedCornerShape(16.dp)
            )
            .clickable {
                if (isLocked) onUnlockClick() 
                else onRecipeClick()
            }
            .testTag("recipe_item_card")
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(120.dp)
                .background(
                    Brush.verticalGradient(
                        colors = listOf(cupertinoBlue().copy(alpha = 0.12f), cupertinoBlue().copy(alpha = 0.04f))
                    )
                )
        ) {
            // Background initials decorative banner
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                CupertinoText(
                    text = recipe.titleItalian.take(2).uppercase(),
                    fontWeight = FontWeight.ExtraBold,
                    style = CupertinoTypography.largeTitle.copy(fontSize = 58.sp),
                    color = cupertinoBlue().copy(alpha = 0.08f)
                )
            }

            // Overlay Badges & Favorite button
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(6.dp))
                        .background(if (isDark()) Color(0xFF3A3A3C) else Color(0xFFFFFFFF).copy(alpha = 0.9f))
                        .padding(horizontal = 8.dp, vertical = 4.dp)
                ) {
                    CupertinoText(
                        text = recipe.category.uppercase(),
                        fontWeight = FontWeight.Bold,
                        style = CupertinoTypography.caption2,
                        color = cupertinoBlue()
                    )
                }

                if (isLocked) {
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(6.dp))
                            .background(cupertinoOrange())
                            .padding(horizontal = 8.dp, vertical = 4.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            CupertinoIcon(imageVector = Icons.Filled.Lock, contentDescription = "Locked", tint = Color.Black, modifier = Modifier.size(11.dp))
                            Spacer(modifier = Modifier.width(3.dp))
                            CupertinoText("ELITE", fontWeight = FontWeight.Bold, style = CupertinoTypography.caption2, color = Color.Black)
                        }
                    }
                } else {
                    CupertinoButton(
                        onClick = onToggleFavorite,
                        containerColor = if (isDark()) Color(0xFF3A3A3C) else Color(0xFFFFFFFF).copy(alpha = 0.9f),
                        contentPadding = PaddingValues(0.dp),
                        shape = RoundedCornerShape(16.dp),
                        modifier = Modifier.size(32.dp)
                    ) {
                        CupertinoIcon(
                            imageVector = Icons.Filled.Favorite,
                            contentDescription = "Salva",
                            tint = if (isFavorite) cupertinoBlue() else cupertinoSecondaryLabel().copy(alpha = 0.5f),
                            modifier = Modifier.size(16.dp)
                        )
                    }
                }
            }

            // Subcategory bottom label
            Box(
                modifier = Modifier
                    .align(Alignment.BottomStart)
                    .padding(12.dp)
                    .clip(RoundedCornerShape(6.dp))
                    .background(cupertinoBlue())
                    .padding(horizontal = 8.dp, vertical = 3.dp)
            ) {
                CupertinoText(
                    text = recipe.subcategory,
                    fontWeight = FontWeight.Bold,
                    style = CupertinoTypography.caption2,
                    color = Color.White
                )
            }
        }

        Column(modifier = Modifier.padding(16.dp)) {
            CupertinoText(
                text = recipe.titleItalian,
                fontWeight = FontWeight.Bold,
                style = CupertinoTypography.headline,
                color = cupertinoLabel(),
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            
            Spacer(modifier = Modifier.height(4.dp))

            CupertinoText(
                text = recipe.chefTips,
                style = CupertinoTypography.footnote,
                color = cupertinoSecondaryLabel(),
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Timers & Eco tagging row
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    CupertinoIcon(imageVector = Icons.Filled.Refresh, contentDescription = "Tempo", tint = cupertinoSecondaryLabel(), modifier = Modifier.size(14.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    CupertinoText(
                        text = "Prep: ${recipe.prepTime}m | Cott: ${recipe.cookTime}m",
                        style = CupertinoTypography.caption2,
                        color = cupertinoSecondaryLabel()
                    )
                }

                if (recipe.isWasteUpcycling) {
                    CupertinoBadge(
                        text = "UPCYCLING",
                        color = cupertinoGreen().copy(alpha = 0.15f),
                        textColor = cupertinoGreen()
                    )
                }
            }
        }
    }
}

// ==========================================
// DETAILED RECIPE OVERLAY SHEET
// ==========================================
@Composable
fun RecipeDetailDialog(
    recipe: Recipe,
    onDismiss: () -> Unit,
    viewModel: RecipeViewModel
) {
    val isMetric by viewModel.isMetric.collectAsStateWithLifecycle()
    val favorites by viewModel.favorites.collectAsStateWithLifecycle()
    val isFav = favorites.any { it.recipeId == recipe.id }

    var currentLanguage by remember { mutableStateOf("IT") } // IT, EN, ES, FR, DE

    var displayedTitle by remember { mutableStateOf(recipe.titleItalian) }
    var displayedInstructions by remember { mutableStateOf(recipe.instructionsItalian) }
    var displayedIngredients by remember { mutableStateOf(if (isMetric) recipe.ingredientsMetric else recipe.ingredientsImperial) }
    var displayedChefTips by remember { mutableStateOf(recipe.chefTips) }
    var displayedEcoBenefit by remember { mutableStateOf(recipe.upcyclingBenefit) }
    var isLoadingTranslation by remember { mutableStateOf(false) }

    LaunchedEffect(recipe.id, currentLanguage, isMetric) {
        val offlineTranslation = RecipeTranslations.getTranslation(recipe.id, currentLanguage)
        if (offlineTranslation != null) {
            displayedTitle = offlineTranslation.title
            displayedInstructions = offlineTranslation.instructions
            displayedIngredients = if (isMetric) offlineTranslation.ingredientsMetric else offlineTranslation.ingredientsImperial
            displayedChefTips = offlineTranslation.chefTips
            displayedEcoBenefit = offlineTranslation.upcyclingBenefit
            isLoadingTranslation = false
        } else {
            val englishTranslation = RecipeTranslations.getTranslation(recipe.id, "EN")
            val defaultTitle = when (currentLanguage) {
                "EN" -> recipe.titleEnglish.ifEmpty { englishTranslation?.title ?: recipe.titleItalian }
                "ES" -> recipe.titleSpanish.ifEmpty { englishTranslation?.title ?: recipe.titleItalian }
                "FR" -> recipe.titleFrench.ifEmpty { englishTranslation?.title ?: recipe.titleItalian }
                "DE" -> recipe.titleGerman.ifEmpty { englishTranslation?.title ?: recipe.titleItalian }
                else -> recipe.titleItalian
            }
            val defaultInstructions = englishTranslation?.instructions ?: recipe.instructionsEnglish.ifEmpty { recipe.instructionsItalian }
            val defaultIngredients = if (isMetric) {
                englishTranslation?.ingredientsMetric ?: recipe.ingredientsMetric
            } else {
                englishTranslation?.ingredientsImperial ?: recipe.ingredientsImperial
            }
            val defaultChefTips = englishTranslation?.chefTips ?: recipe.chefTips
            val defaultEcoBenefit = englishTranslation?.upcyclingBenefit ?: recipe.upcyclingBenefit

            displayedTitle = defaultTitle
            displayedInstructions = defaultInstructions
            displayedIngredients = defaultIngredients
            displayedChefTips = defaultChefTips
            displayedEcoBenefit = defaultEcoBenefit

            val apiKeyAvailable = viewModel.userApiKey.value.trim().isNotEmpty() || 
                (BuildConfig.GEMINI_API_KEY.trim().isNotEmpty() && BuildConfig.GEMINI_API_KEY.trim() != "MY_GEMINI_API_KEY")

            if (currentLanguage != "IT" && apiKeyAvailable) {
                isLoadingTranslation = true
                viewModel.translateText(defaultTitle, currentLanguage) { displayedTitle = it }
                viewModel.translateText(defaultInstructions, currentLanguage) { displayedInstructions = it }
                viewModel.translateText(defaultIngredients, currentLanguage) { displayedIngredients = it }
                viewModel.translateText(defaultChefTips, currentLanguage) { displayedChefTips = it }
                viewModel.translateText(defaultEcoBenefit, currentLanguage) {
                    displayedEcoBenefit = it
                    isLoadingTranslation = false
                }
            } else {
                isLoadingTranslation = false
            }
        }
    }

    val labelClose = when (currentLanguage) {
        "EN" -> "Close"
        "ES" -> "Cerrar"
        "FR" -> "Fermer"
        "DE" -> "Schließen"
        else -> "Chiudi"
    }
    val labelPrep = when (currentLanguage) {
        "EN" -> "Prep"
        "ES" -> "Prep"
        "FR" -> "Prép."
        "DE" -> "Zubereitung"
        else -> "Preparazione"
    }
    val labelCook = when (currentLanguage) {
        "EN" -> "Cook"
        "ES" -> "Cocción"
        "FR" -> "Cuisson"
        "DE" -> "Backzeit"
        else -> "Cottura"
    }
    val labelRest = when (currentLanguage) {
        "EN" -> "Rest"
        "ES" -> "Reposo"
        "FR" -> "Repos"
        "DE" -> "Ruhezeit"
        else -> "Riposo"
    }
    val labelIngredientsHeader = when (currentLanguage) {
        "EN" -> "Ingredients & Portions"
        "ES" -> "Ingredientes y Porciones"
        "FR" -> "Ingrédients & Doses"
        "DE" -> "Zutaten & Dosierung"
        else -> "Ingredienti & Dosi"
    }
    val labelMetric = when (currentLanguage) {
        "EN" -> "METRIC"
        "ES" -> "MÉTRICO"
        "FR" -> "MÉTRIQUE"
        "DE" -> "METRISCH"
        else -> "METRICO"
    }
    val labelImperial = when (currentLanguage) {
        "EN" -> "IMPERIAL"
        "ES" -> "IMPERIAL"
        "FR" -> "IMPÉRIAL"
        "DE" -> "IMPERIAL"
        else -> "IMPERIALE"
    }
    val labelInstructionsHeader = when (currentLanguage) {
        "EN" -> "Step-by-Step Preparation"
        "ES" -> "Preparación Paso a Paso"
        "FR" -> "Préparation Étape par Étape"
        "DE" -> "Schritt-für-Schritt-Zubereitung"
        else -> "Preparazione Passo-Passo"
    }
    val labelChefTipsHeader = when (currentLanguage) {
        "EN" -> "Michelin Chef's Secret"
        "ES" -> "El Secreto del Chef de Estrellas"
        "FR" -> "Le Secret du Chef Étoilé"
        "DE" -> "Das Geheimnis des Sternekochs"
        else -> "Il Segreto dello Chef Stellato"
    }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(cupertinoBgGrouped())
                .statusBarsPadding()
                .navigationBarsPadding()
        ) {
            Column(modifier = Modifier.fillMaxSize()) {
                // Translucent iOS Action bar header
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(cupertinoTranslucentBg())
                        .padding(horizontal = 16.dp, vertical = 10.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Left blue text "Chiudi" action button
                    CupertinoButton(
                        onClick = onDismiss,
                        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 6.dp)
                    ) {
                        CupertinoText(labelClose, color = cupertinoBlue(), style = CupertinoTypography.body, fontWeight = FontWeight.Medium)
                    }

                    // Translucent segmented language switcher with translation spinner
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        CupertinoSegmentedControl(
                            options = listOf("IT", "EN", "ES", "FR", "DE"),
                            selectedIndex = listOf("IT", "EN", "ES", "FR", "DE").indexOf(currentLanguage),
                            onSelectedIndexChange = { idx ->
                                currentLanguage = listOf("IT", "EN", "ES", "FR", "DE")[idx]
                            },
                            modifier = Modifier.width(180.dp)
                        )
                        if (isLoadingTranslation) {
                            CupertinoActivityIndicator(size = 14.dp)
                        }
                    }

                    // Right Favorite toggle button
                    CupertinoButton(
                        onClick = { viewModel.toggleFavorite(recipe) },
                        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 6.dp)
                    ) {
                        CupertinoIcon(
                            imageVector = Icons.Filled.Favorite,
                            contentDescription = "Salva",
                            tint = if (isFav) cupertinoBlue() else cupertinoSecondaryLabel()
                        )
                    }
                }

                Box(modifier = Modifier.fillMaxWidth().height(0.5.dp).background(cupertinoSeparator()))

                // Main sheet content list
                LazyColumn(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(horizontal = 20.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    item {
                        Spacer(modifier = Modifier.height(16.dp))
                        CupertinoText(
                            text = displayedTitle,
                            fontWeight = FontWeight.Black,
                            style = CupertinoTypography.title2,
                            color = cupertinoLabel(),
                            modifier = Modifier.alpha(if (isLoadingTranslation) 0.6f else 1f)
                        )
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            CupertinoBadge(text = recipe.category.uppercase(), color = cupertinoBlue())
                            CupertinoBadge(text = "DIFFICOLTÀ: ${recipe.difficulty.uppercase()}", color = cupertinoOrange())
                        }
                    }

                    // Cooking grid times
                    item {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .background(cupertinoBgRow())
                                .border(0.5.dp, cupertinoSeparator(), RoundedCornerShape(12.dp))
                                .padding(12.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceAround
                            ) {
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    CupertinoText(labelPrep, style = CupertinoTypography.caption2, color = cupertinoSecondaryLabel())
                                    CupertinoText("${recipe.prepTime} min", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                                }
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    CupertinoText(labelCook, style = CupertinoTypography.caption2, color = cupertinoSecondaryLabel())
                                    CupertinoText("${recipe.cookTime} min", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                                }
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    CupertinoText(labelRest, style = CupertinoTypography.caption2, color = cupertinoSecondaryLabel())
                                    CupertinoText("${recipe.restTime} min", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                                }
                            }
                        }
                    }

                    // Green eco-upcycling benefit banner
                    if (recipe.isWasteUpcycling) {
                        item {
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(cupertinoGreen().copy(alpha = 0.08f))
                                    .border(0.5.dp, cupertinoGreen().copy(alpha = 0.2f), RoundedCornerShape(12.dp))
                                    .padding(12.dp)
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    CupertinoIcon(imageVector = Icons.Filled.Check, contentDescription = "Eco", tint = cupertinoGreen())
                                    Spacer(modifier = Modifier.width(10.dp))
                                    CupertinoText(
                                        text = displayedEcoBenefit,
                                        style = CupertinoTypography.footnote,
                                        fontWeight = FontWeight.Medium,
                                        color = cupertinoGreen(),
                                        modifier = Modifier.alpha(if (isLoadingTranslation) 0.6f else 1f)
                                    )
                                }
                            }
                        }
                    }

                    // Metric / Imperial selector
                    item {
                        Column {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                CupertinoText(labelIngredientsHeader, fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                                
                                // iOS outline action button for switcher units
                                CupertinoButton(
                                    onClick = { viewModel.toggleMetric() },
                                    containerColor = if (isDark()) Color(0xFF2C2C2E) else Color(0xFFE5E5EA),
                                    contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                                    shape = RoundedCornerShape(8.dp)
                                ) {
                                    CupertinoText(
                                        text = if (isMetric) labelMetric else labelImperial,
                                        fontWeight = FontWeight.Bold,
                                        style = CupertinoTypography.caption2,
                                        color = cupertinoBlue()
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(8.dp))

                            CupertinoText(
                                text = displayedIngredients,
                                style = CupertinoTypography.body,
                                color = cupertinoLabel(),
                                modifier = Modifier.alpha(if (isLoadingTranslation) 0.6f else 1f)
                            )
                        }
                    }

                    // Step-by-Step cooking instructions
                    item {
                        Column {
                            CupertinoText(labelInstructionsHeader, fontWeight = FontWeight.Bold, style = CupertinoTypography.headline)
                            Spacer(modifier = Modifier.height(8.dp))
                            CupertinoText(
                                text = displayedInstructions,
                                style = CupertinoTypography.body,
                                color = cupertinoLabel(),
                                modifier = Modifier.alpha(if (isLoadingTranslation) 0.6f else 1f)
                            )
                        }
                    }

                    // Chef's Secrets elite card
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(14.dp))
                                .background(cupertinoOrange().copy(alpha = 0.08f))
                                .border(0.5.dp, cupertinoOrange().copy(alpha = 0.2f), RoundedCornerShape(14.dp))
                                .padding(16.dp)
                        ) {
                            Column {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    CupertinoIcon(imageVector = Icons.Filled.Star, contentDescription = "Chef", tint = cupertinoOrange())
                                    Spacer(modifier = Modifier.width(8.dp))
                                    CupertinoText(labelChefTipsHeader, fontWeight = FontWeight.Bold, style = CupertinoTypography.subhead, color = cupertinoOrange())
                                }
                                Spacer(modifier = Modifier.height(6.dp))
                                CupertinoText(
                                    text = displayedChefTips,
                                    style = CupertinoTypography.footnote,
                                    color = cupertinoLabel(),
                                    modifier = Modifier.alpha(if (isLoadingTranslation) 0.6f else 1f)
                                )
                            }
                        }
                    }

                    item {
                        Spacer(modifier = Modifier.height(32.dp))
                    }
                }
            }
        }
    }
}

// ==========================================
// CONFIGURATION / SETTINGS DIALOG
// ==========================================
@Composable
fun SettingsDialog(
    viewModel: RecipeViewModel,
    onDismiss: () -> Unit
) {
    val apiKey by viewModel.userApiKey.collectAsStateWithLifecycle()
    var tempKey by remember { mutableStateOf(apiKey) }
    val context = LocalContext.current

    CupertinoDialog(
        onDismissRequest = onDismiss,
        title = "Configurazione AI Cloud",
        message = "TasteAI supporta l'assistente locale offline intelligente. Se desideri sbloccare la modalità Cloud avanzata powered by Gemini, inserisci qui la tua API Key di Google AI Studio.",
        confirmButtonText = "Salva",
        onConfirm = {
            viewModel.saveUserApiKey(tempKey)
            Toast.makeText(context, "API Key salvata correttamente!", Toast.LENGTH_SHORT).show()
            onDismiss()
        },
        dismissButtonText = "Annulla",
        onDismiss = onDismiss
    ) {
        // Safe input slot inside dialog
        CupertinoTextField(
            value = tempKey,
            onValueChange = { tempKey = it },
            placeholder = "AIzaSy... (Gemini API Key)"
        )
    }
}

// ==========================================
// APP STORE SIMULATED PURCHASE DIALOG
// ==========================================
@Composable
fun SimulatedPurchaseDialog(
    onDismiss: () -> Unit,
    onConfirm: () -> Unit
) {
    val context = LocalContext.current
    Dialog(onDismissRequest = onDismiss) {
        Column(
            modifier = Modifier
                .width(280.dp)
                .clip(RoundedCornerShape(14.dp))
                .background(if (isDark()) Color(0xEC1E1E1E) else Color(0xF2F2F2F7))
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // App Store purchase mock logo
            Row(verticalAlignment = Alignment.CenterVertically) {
                CupertinoIcon(imageVector = Icons.Filled.Star, contentDescription = "App Store", tint = cupertinoOrange(), modifier = Modifier.size(24.dp))
                Spacer(modifier = Modifier.width(8.dp))
                CupertinoText("App Store Sandbox", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline, color = cupertinoLabel())
            }

            Spacer(modifier = Modifier.height(16.dp))

            CupertinoText(
                text = "Abbonamento TasteAI Elite",
                fontWeight = FontWeight.Black,
                style = CupertinoTypography.headline,
                color = cupertinoLabel()
            )
            Spacer(modifier = Modifier.height(2.dp))
            CupertinoText(
                text = "Accesso Premium Completo",
                style = CupertinoTypography.footnote,
                color = cupertinoBlue()
            )

            Spacer(modifier = Modifier.height(16.dp))

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(10.dp))
                    .background(cupertinoBgRow())
                    .padding(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        CupertinoText("Prezzo Annuale", style = CupertinoTypography.caption2, color = cupertinoSecondaryLabel())
                        CupertinoText("$19.99 / anno", fontWeight = FontWeight.Bold, style = CupertinoTypography.subhead)
                    }
                    CupertinoText("Annulla quando vuoi", style = CupertinoTypography.caption2, color = cupertinoBlue())
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // iOS Apple Pay style one click checkout button
            CupertinoButton(
                onClick = {
                    Toast.makeText(context, "Acquisto simulato completato con successo!", Toast.LENGTH_LONG).show()
                    onConfirm()
                },
                containerColor = cupertinoBlue(),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(44.dp)
                    .testTag("billing_confirm_button")
            ) {
                CupertinoText("Paga con 1-Click", fontWeight = FontWeight.Bold, style = CupertinoTypography.headline, color = Color.White)
            }

            Spacer(modifier = Modifier.height(8.dp))

            CupertinoButton(
                onClick = onDismiss,
                contentPadding = PaddingValues(6.dp)
            ) {
                CupertinoText("Annulla", color = cupertinoSecondaryLabel(), style = CupertinoTypography.body)
            }
        }
    }
}
