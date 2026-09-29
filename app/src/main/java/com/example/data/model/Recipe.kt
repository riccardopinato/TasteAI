package com.example.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "recipes")
data class Recipe(
    @PrimaryKey val id: String,
    val titleOriginal: String,
    val titleItalian: String,
    val titleEnglish: String,
    val titleSpanish: String,
    val titleFrench: String,
    val titleGerman: String,
    val titleChinese: String,
    val titleJapanese: String,
    val category: String, // Antipasto, Primo, Secondo, Dessert, Contorno
    val subcategory: String, // Carne, Pesce, Vegano, Pasta, Risotto, CBT/Sottovuoto, Robot da cucina
    val difficulty: String, // Facile, Medio, Difficile
    val prepTime: Int, // in minutes
    val cookTime: Int, // in minutes
    val restTime: Int, // in minutes
    val ingredientsMetric: String, // Formatted text, e.g., "• 150g Filetto\n• 50g Salsa"
    val ingredientsImperial: String, // Formatted text, e.g., "• 5.3oz Filet\n• 1.7oz Sauce"
    val instructionsItalian: String, // Step-by-step text
    val instructionsEnglish: String,
    val chefTips: String, // Chef secrets (e.g., Maillard, vacuum tips)
    val isWasteUpcycling: Boolean, // Whether it uses leftover or scraps
    val upcyclingBenefit: String, // Eco-saving context (e.g. water/CO2 saved)
    val isPremium: Boolean = false, // Locked behind premium
    val tags: String = "" // "vegetariano", "bimbi", "scarti"
)
