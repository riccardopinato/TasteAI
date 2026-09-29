package com.example.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "favorites")
data class Favorite(
    @PrimaryKey val recipeId: String,
    val folder: String, // "Antipasto", "Primo", "Secondo", "Dessert", "CBT" or custom
    val addedAt: Long = System.currentTimeMillis()
)
