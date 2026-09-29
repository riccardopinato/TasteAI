package com.example.data.repository

import com.example.data.local.RecipeDao
import com.example.data.model.Recipe
import com.example.data.model.Favorite
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first

class RecipeRepository(
    private val recipeDao: RecipeDao
) {
    val allRecipes: Flow<List<Recipe>> = recipeDao.getAllRecipes()
    val allFavorites: Flow<List<Favorite>> = recipeDao.getAllFavorites()

    suspend fun getRecipeById(id: String): Recipe? {
        return recipeDao.getRecipeById(id)
    }

    suspend fun insertRecipes(recipes: List<Recipe>) {
        recipeDao.insertRecipes(recipes)
    }

    suspend fun toggleFavorite(recipeId: String, category: String) {
        if (recipeDao.isFavorite(recipeId)) {
            recipeDao.deleteFavorite(recipeId)
        } else {
            recipeDao.insertFavorite(Favorite(recipeId = recipeId, folder = category))
        }
    }

    suspend fun prepopulateIfNeeded() {
        val current = recipeDao.getAllRecipes().first()
        if (current.isNotEmpty()) return
        
        // This is a placeholder; real recipes should be loaded from assets or other source
        // For now, it just initializes the database if empty
    }
}
