package com.example.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val DarkColorScheme = darkColorScheme(
    primary = SagePrimaryDark,
    primaryContainer = SagePrimaryDark,
    onPrimaryContainer = DarkBackground,
    secondary = SageSecondaryDark,
    secondaryContainer = DarkSurface,
    onSecondaryContainer = TextLight,
    tertiary = ApricotAccentDark,
    tertiaryContainer = ApricotAccentDark,
    onTertiaryContainer = DarkBackground,
    background = DarkBackground,
    surface = DarkSurface,
    onPrimary = DarkBackground,
    onSecondary = TextLight,
    onTertiary = DarkBackground,
    onBackground = TextLight,
    onSurface = TextLight,
    outlineVariant = androidx.compose.ui.graphics.Color(0xFF323D36)
)

private val LightColorScheme = lightColorScheme(
    primary = SagePrimary,
    primaryContainer = SagePrimary,
    onPrimaryContainer = androidx.compose.ui.graphics.Color.White,
    secondary = SageSecondary,
    secondaryContainer = LightChipBg,
    onSecondaryContainer = TextDark,
    tertiary = ApricotAccent,
    tertiaryContainer = ApricotAccent,
    onTertiaryContainer = TextDark,
    background = CreamBackground,
    surface = SurfaceWarm,
    onPrimary = androidx.compose.ui.graphics.Color.White,
    onSecondary = TextDark,
    onTertiary = TextDark,
    onBackground = TextDark,
    onSurface = TextDark,
    outlineVariant = OutlineNatural
)

@Composable
fun MyApplicationTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // Keep dynamic color true if desired, but we want our custom colors to shine!
    dynamicColor: Boolean = false, 
    content: @Composable () -> Unit,
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
