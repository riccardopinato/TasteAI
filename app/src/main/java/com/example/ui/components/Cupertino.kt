package com.example.ui.components

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.*
import androidx.compose.foundation.interaction.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.*
import androidx.compose.foundation.text.*
import androidx.compose.runtime.*
import androidx.compose.ui.*
import androidx.compose.ui.draw.*
import androidx.compose.ui.geometry.*
import androidx.compose.ui.graphics.*
import androidx.compose.ui.graphics.drawscope.*
import androidx.compose.ui.graphics.vector.*
import androidx.compose.ui.platform.*
import androidx.compose.ui.text.*
import androidx.compose.ui.text.font.*
import androidx.compose.ui.text.style.*
import androidx.compose.ui.unit.*
import androidx.compose.ui.window.*
import com.example.ui.theme.*

// ==========================================
// iOS SYSTEM COLOR PALETTE (HIG COMPLIANT)
// ==========================================
object CupertinoColors {
    // Light Palette
    val lightSystemBlue = SagePrimary
    val lightSystemGreen = SagePrimary
    val lightSystemOrange = ApricotAccent
    val lightSystemRed = Color(0xFFFF3B30)
    val lightSystemGray = SageSecondary
    val lightSystemGray2 = Color(0xFFAEAEB2)
    val lightSystemGray3 = Color(0xFFC7C7CC)
    val lightSystemGray4 = Color(0xFFD1D1D6)
    val lightSystemGray5 = SurfaceWarm
    val lightSystemGray6 = CreamBackground // Grouped list background
    val lightLabel = DarkSlate
    val lightSecondaryLabel = SageSecondary.copy(alpha = 0.8f)
    val lightBackground = SurfaceWarm // Row / Page background
    val lightSeparator = OutlineNatural
    val lightTranslucentBg = CreamBackground.copy(alpha = 0.94f)

    // Dark Palette
    val darkSystemBlue = Color(0xFF0A84FF)
    val darkSystemGreen = Color(0xFF30D158)
    val darkSystemOrange = Color(0xFFFF9F0A)
    val darkSystemRed = Color(0xFFFF453A)
    val darkSystemGray = Color(0xFF8E8E93)
    val darkSystemGray2 = Color(0xFF636366)
    val darkSystemGray3 = Color(0xFF48484A)
    val darkSystemGray4 = Color(0xFF3A3A3C)
    val darkSystemGray5 = Color(0xFF2C2C2E) // Row / Inner card background
    val darkSystemGray6 = Color(0xFF1C1C1E) // Grouped list background
    val darkLabel = Color(0xFFFFFFFF)
    val darkSecondaryLabel = Color(0xFFEBEBF5).copy(alpha = 0.6f)
    val darkBackground = Color(0xFF000000) // Page background
    val darkSeparator = Color(0xFF545458).copy(alpha = 0.35f)
    val darkTranslucentBg = Color(0xFF151515).copy(alpha = 0.92f)
}

@Composable
fun isDark(): Boolean = isSystemInDarkTheme()

@Composable
fun cupertinoBgGrouped(): Color = if (isDark()) CupertinoColors.darkSystemGray6 else CupertinoColors.lightSystemGray6

@Composable
fun cupertinoBgRow(): Color = if (isDark()) CupertinoColors.darkSystemGray5 else CupertinoColors.lightBackground

@Composable
fun cupertinoBgPrimary(): Color = if (isDark()) CupertinoColors.darkBackground else CupertinoColors.lightBackground

@Composable
fun cupertinoLabel(): Color = if (isDark()) CupertinoColors.darkLabel else CupertinoColors.lightLabel

@Composable
fun cupertinoSecondaryLabel(): Color = if (isDark()) CupertinoColors.darkSecondaryLabel else CupertinoColors.lightSecondaryLabel

@Composable
fun cupertinoBlue(): Color = if (isDark()) CupertinoColors.darkSystemBlue else CupertinoColors.lightSystemBlue

@Composable
fun cupertinoGreen(): Color = if (isDark()) CupertinoColors.darkSystemGreen else CupertinoColors.lightSystemGreen

@Composable
fun cupertinoOrange(): Color = if (isDark()) CupertinoColors.darkSystemOrange else CupertinoColors.lightSystemOrange

@Composable
fun cupertinoRed(): Color = if (isDark()) CupertinoColors.darkSystemRed else CupertinoColors.lightSystemRed

@Composable
fun cupertinoSeparator(): Color = if (isDark()) CupertinoColors.darkSeparator else CupertinoColors.lightSeparator

@Composable
fun cupertinoTranslucentBg(): Color = if (isDark()) CupertinoColors.darkTranslucentBg else CupertinoColors.lightTranslucentBg

// ==========================================
// iOS SYSTEM TYPOGRAPHY (SF PRO STYLE)
// ==========================================
object CupertinoTypography {
    private val SFProFamily = FontFamily.SansSerif

    val largeTitle = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Bold, fontSize = 34.sp, letterSpacing = 0.37.sp)
    val title1 = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.SemiBold, fontSize = 28.sp, letterSpacing = 0.36.sp)
    val title2 = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.SemiBold, fontSize = 22.sp, letterSpacing = 0.35.sp)
    val title3 = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Medium, fontSize = 20.sp, letterSpacing = 0.38.sp)
    val headline = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Bold, fontSize = 17.sp, letterSpacing = (-0.41).sp)
    val body = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Normal, fontSize = 17.sp, letterSpacing = (-0.41).sp)
    val callout = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Normal, fontSize = 16.sp, letterSpacing = (-0.32).sp)
    val subhead = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Medium, fontSize = 15.sp, letterSpacing = (-0.24).sp)
    val footnote = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Normal, fontSize = 13.sp, letterSpacing = (-0.08).sp)
    val caption1 = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Normal, fontSize = 12.sp, letterSpacing = 0.sp)
    val caption2 = TextStyle(fontFamily = SFProFamily, fontWeight = FontWeight.Normal, fontSize = 11.sp, letterSpacing = 0.07.sp)
}

// ==========================================
// CupertinoText Component (replaces Material Text)
// ==========================================
@Composable
fun CupertinoText(
    text: String,
    modifier: Modifier = Modifier,
    color: Color = cupertinoLabel(),
    style: TextStyle = CupertinoTypography.body,
    fontWeight: FontWeight? = null,
    textAlign: TextAlign? = null,
    fontStyle: FontStyle? = null,
    maxLines: Int = Int.MAX_VALUE,
    overflow: TextOverflow = TextOverflow.Clip
) {
    val mergedStyle = style.copy(
        color = color,
        fontWeight = fontWeight ?: style.fontWeight,
        textAlign = textAlign ?: style.textAlign,
        fontStyle = fontStyle ?: style.fontStyle
    )
    BasicText(
        text = text,
        modifier = modifier,
        style = mergedStyle,
        maxLines = maxLines,
        overflow = overflow
    )
}

// ==========================================
// CupertinoIcon (replaces Material Icon)
// ==========================================
@Composable
fun CupertinoIcon(
    imageVector: ImageVector,
    contentDescription: String?,
    modifier: Modifier = Modifier,
    tint: Color = cupertinoBlue()
) {
    Image(
        imageVector = imageVector,
        contentDescription = contentDescription,
        modifier = modifier.size(24.dp),
        colorFilter = ColorFilter.tint(tint)
    )
}

// ==========================================
// CupertinoButton (Tap to fade alpha, iOS style)
// ==========================================
@Composable
fun CupertinoButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    containerColor: Color? = null, // if null -> plain text button
    textColor: Color = Color.White,
    shape: Shape = RoundedCornerShape(12.dp),
    contentPadding: PaddingValues = PaddingValues(horizontal = 16.dp, vertical = 14.dp),
    content: @Composable RowScope.() -> Unit
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    
    val animatedAlpha by animateFloatAsState(
        targetValue = if (isPressed) 0.45f else 1f,
        animationSpec = spring(stiffness = Spring.StiffnessMediumLow),
        label = "button_press_alpha"
    )
    val animatedScale by animateFloatAsState(
        targetValue = if (isPressed) 0.98f else 1f,
        animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy),
        label = "button_press_scale"
    )

    val isPlain = containerColor == null
    val finalBg = containerColor ?: Color.Transparent

    Box(
        modifier = modifier
            .scale(animatedScale)
            .graphicsLayer(alpha = if (enabled) animatedAlpha else 0.4f)
            .clip(shape)
            .background(finalBg)
            .clickable(
                interactionSource = interactionSource,
                indication = null, // Remove Material Ripple completely
                enabled = enabled,
                onClick = onClick
            )
            .padding(contentPadding),
        contentAlignment = Alignment.Center
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            content()
        }
    }
}

// ==========================================
// CupertinoSwitch (Classic iOS animated toggle)
// ==========================================
@Composable
fun CupertinoSwitch(
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()

    // Smooth switch animations
    val activeTrackColor = cupertinoGreen()
    val inactiveTrackColor = if (isDark()) Color(0xFF3E3E42) else Color(0xFFE5E5EA)
    
    val trackBgColor by animateColorAsState(
        targetValue = if (checked) activeTrackColor else inactiveTrackColor,
        animationSpec = tween(durationMillis = 200),
        label = "switch_track_color"
    )
    
    // Knobs offset (track length is 51dp, height 31dp, knob 27dp)
    // Travel is (51 - 27 - 4) = 20dp
    val knobTravel = 20.dp
    val targetOffset = if (checked) knobTravel else 2.dp
    
    val knobOffset by animateDpAsState(
        targetValue = targetOffset,
        animationSpec = spring(dampingRatio = Spring.DampingRatioHighBouncy, stiffness = Spring.StiffnessMedium),
        label = "switch_knob_offset"
    )

    val scaleKnobWidth by animateDpAsState(
        targetValue = if (isPressed) 32.dp else 27.dp,
        animationSpec = tween(150),
        label = "switch_knob_stretch"
    )

    Box(
        modifier = modifier
            .size(width = 51.dp, height = 31.dp)
            .clip(CircleShape)
            .background(trackBgColor)
            .clickable(
                interactionSource = interactionSource,
                indication = null,
                enabled = enabled,
                onClick = { onCheckedChange(!checked) }
            ),
        contentAlignment = Alignment.CenterStart
    ) {
        Box(
            modifier = Modifier
                .offset(x = knobOffset)
                .size(width = scaleKnobWidth, height = 27.dp)
                .clip(CircleShape)
                .background(Color.White)
                .shadow(elevation = 1.dp, shape = CircleShape)
        )
    }
}

// ==========================================
// CupertinoActivityIndicator (iOS Spinner)
// ==========================================
@Composable
fun CupertinoActivityIndicator(
    modifier: Modifier = Modifier,
    color: Color = cupertinoLabel(),
    size: Dp = 24.dp
) {
    // 8 spinning ticks
    val tickCount = 8
    val infiniteTransition = rememberInfiniteTransition(label = "spinner")
    val currentFrame by infiniteTransition.animateValue(
        initialValue = 0,
        targetValue = tickCount - 1,
        typeConverter = Int.VectorConverter,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 800, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "spinner_tick"
    )

    Canvas(modifier = modifier.size(size)) {
        val radius = this.size.width / 2
        val strokeWidthPx = (size.toPx() * 0.09f).coerceAtLeast(1.5f.dp.toPx())
        val innerRadius = radius * 0.45f
        val outerRadius = radius * 0.9f

        val center = Offset(radius, radius)

        for (i in 0 until tickCount) {
            val angleDegrees = i * (360f / tickCount)
            val angleRad = Math.toRadians(angleDegrees.toDouble())

            val startX = center.x + innerRadius * Math.cos(angleRad).toFloat()
            val startY = center.y + innerRadius * Math.sin(angleRad).toFloat()
            val endX = center.x + outerRadius * Math.cos(angleRad).toFloat()
            val endY = center.y + outerRadius * Math.sin(angleRad).toFloat()

            // Translucent fade order
            val tickIndexDiff = (i - currentFrame + tickCount) % tickCount
            val alpha = (1f - (tickIndexDiff.toFloat() / tickCount)).coerceIn(0.15f, 1f)

            drawLine(
                color = color,
                start = Offset(startX, startY),
                end = Offset(endX, endY),
                strokeWidth = strokeWidthPx,
                cap = StrokeCap.Round,
                alpha = alpha
            )
        }
    }
}

// ==========================================
// CupertinoNavigationBar (iOS Title Bar)
// ==========================================
@Composable
fun CupertinoNavigationBar(
    title: String,
    modifier: Modifier = Modifier,
    leftAction: (@Composable BoxScope.() -> Unit)? = null,
    rightAction: (@Composable BoxScope.() -> Unit)? = null
) {
    val statusBarHeight = WindowInsets.statusBars.asPaddingValues().calculateTopPadding()
    
    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(cupertinoTranslucentBg())
    ) {
        Spacer(modifier = Modifier.height(statusBarHeight))
        
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp)
                .padding(horizontal = 16.dp),
            contentAlignment = Alignment.Center
        ) {
            // Left Item
            if (leftAction != null) {
                Box(
                    modifier = Modifier.align(Alignment.CenterStart),
                    contentAlignment = Alignment.CenterStart
                ) {
                    leftAction()
                }
            }
            
            // Centered Small Title with Editorial Serif Italic + Monospace Subtitle pairing
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                BasicText(
                    text = title,
                    style = TextStyle(
                        fontFamily = FontFamily.Serif,
                        fontStyle = FontStyle.Italic,
                        fontWeight = FontWeight.Bold,
                        fontSize = 19.sp,
                        color = cupertinoLabel()
                    ),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Spacer(modifier = Modifier.height(1.dp))
                BasicText(
                    text = "ANTI-WASTE LAB",
                    style = TextStyle(
                        fontFamily = FontFamily.Monospace,
                        fontSize = 8.5.sp,
                        fontWeight = FontWeight.Bold,
                        color = cupertinoSecondaryLabel(),
                        letterSpacing = 2.5.sp
                    ),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }

            // Right Item
            if (rightAction != null) {
                Box(
                    modifier = Modifier.align(Alignment.CenterEnd),
                    contentAlignment = Alignment.CenterEnd
                ) {
                    rightAction()
                }
            }
        }
        
        // Border bottom separator
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(1.dp)
                .background(cupertinoSeparator())
        )
    }
}

// ==========================================
// CupertinoTabBar (iOS Bottom Navigation)
// ==========================================
@Composable
fun CupertinoTabBar(
    modifier: Modifier = Modifier,
    content: @Composable RowScope.() -> Unit
) {
    val bottomInset = WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding()
    
    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(cupertinoTranslucentBg())
    ) {
        // Thin top border separator
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(1.dp)
                .background(cupertinoSeparator())
        )
        
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(49.dp)
                .padding(horizontal = 4.dp),
            horizontalArrangement = Arrangement.SpaceAround,
            verticalAlignment = Alignment.CenterVertically
        ) {
            content()
        }
        
        Spacer(modifier = Modifier.height(bottomInset))
    }
}

@Composable
fun RowScope.CupertinoTabItem(
    selected: Boolean,
    onClick: () -> Unit,
    icon: ImageVector,
    label: String
) {
    val tint = if (selected) cupertinoBlue() else CupertinoColors.lightSystemGray
    
    // Fluid modern active background pill highlight (an 8% opacity tint of Sage green with rounded corners)
    val pillBgColor by animateColorAsState(
        targetValue = if (selected) SagePrimary.copy(alpha = 0.08f) else Color.Transparent,
        animationSpec = tween(durationMillis = 200),
        label = "tab_pill_bg"
    )
    
    Box(
        modifier = Modifier
            .weight(1f)
            .fillMaxHeight()
            .clickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = null,
                onClick = onClick
            ),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .padding(vertical = 4.dp, horizontal = 8.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(pillBgColor)
                .padding(vertical = 6.dp, horizontal = 12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            CupertinoIcon(
                imageVector = icon,
                contentDescription = label,
                modifier = Modifier.size(23.dp),
                tint = tint
            )
            Spacer(modifier = Modifier.height(2.dp))
            CupertinoText(
                text = label,
                style = CupertinoTypography.caption2,
                color = tint,
                fontWeight = if (selected) FontWeight.Medium else FontWeight.Normal
            )
        }
    }
}

// ==========================================
// CupertinoGroupedList (TableView Section)
// ==========================================
@Composable
fun CupertinoFormSection(
    modifier: Modifier = Modifier,
    title: String? = null,
    footer: String? = null,
    content: @Composable ColumnScope.() -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        if (title != null) {
            CupertinoText(
                text = title.uppercase(),
                style = CupertinoTypography.footnote,
                color = cupertinoSecondaryLabel(),
                modifier = Modifier.padding(start = 12.dp, bottom = 6.dp)
            )
        }
        
        // Group Container Card
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(10.dp))
                .background(cupertinoBgRow())
        ) {
            content()
        }
        
        if (footer != null) {
            CupertinoText(
                text = footer,
                style = CupertinoTypography.footnote,
                color = cupertinoSecondaryLabel(),
                modifier = Modifier.padding(start = 12.dp, top = 6.dp, end = 12.dp)
            )
        }
    }
}

@Composable
fun CupertinoFormRow(
    label: String,
    modifier: Modifier = Modifier,
    icon: (@Composable () -> Unit)? = null,
    detail: String? = null,
    showChevron: Boolean = false,
    onClick: (() -> Unit)? = null,
    trailing: (@Composable RowScope.() -> Unit)? = null
) {
    val clickableModifier = if (onClick != null) {
        val interactionSource = remember { MutableInteractionSource() }
        val isPressed by interactionSource.collectIsPressedAsState()
        val rowBg = if (isPressed) {
            if (isDark()) Color(0xFF3A3A3C) else Color(0xFFE5E5EA)
        } else {
            Color.Transparent
        }
        Modifier
            .background(rowBg)
            .clickable(
                interactionSource = interactionSource,
                indication = null,
                onClick = onClick
            )
    } else {
        Modifier
    }

    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            modifier = clickableModifier
                .fillMaxWidth()
                .heightIn(min = 44.dp)
                .padding(horizontal = 16.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.weight(1f)
            ) {
                if (icon != null) {
                    Box(modifier = Modifier.padding(end = 12.dp)) {
                        icon()
                    }
                }
                CupertinoText(
                    text = label,
                    style = CupertinoTypography.body,
                    color = cupertinoLabel()
                )
            }
            
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.End
            ) {
                if (detail != null) {
                    CupertinoText(
                        text = detail,
                        style = CupertinoTypography.body,
                        color = cupertinoSecondaryLabel(),
                        modifier = Modifier.padding(end = 6.dp)
                    )
                }
                
                if (trailing != null) {
                    trailing()
                }
                
                if (showChevron) {
                    // Clean iOS-style right chevron draw
                    Canvas(modifier = Modifier.size(width = 8.dp, height = 13.dp)) {
                        val strokeWidth = 2.dp.toPx()
                        val color = Color(0xFFC7C7CC)
                        val path = Path().apply {
                            moveTo(1.dp.toPx(), 1.dp.toPx())
                            lineTo(7.dp.toPx(), 6.5f.dp.toPx())
                            lineTo(1.dp.toPx(), 12.dp.toPx())
                        }
                        drawPath(
                            path = path,
                            color = color,
                            style = Stroke(width = strokeWidth, cap = StrokeCap.Round, join = StrokeJoin.Round)
                        )
                    }
                }
            }
        }
    }
}

// Renders an iOS grouped separator line (to place manually between CupertinoFormRows)
@Composable
fun CupertinoSeparator() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = 16.dp)
            .height(0.6.dp)
            .background(cupertinoSeparator())
    )
}

// ==========================================
// CupertinoSegmentedControl (Sliding tabs)
// ==========================================
@Composable
fun CupertinoSegmentedControl(
    options: List<String>,
    selectedIndex: Int,
    onSelectedIndexChange: (Int) -> Unit,
    modifier: Modifier = Modifier
) {
    val bg = if (isDark()) Color(0xFF1C1C1E) else Color(0xFFE5E5EA)
    val selectionBg = if (isDark()) Color(0xFF636366) else Color(0xFFFFFFFF)
    
    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(32.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(bg)
            .padding(2.dp),
        contentAlignment = Alignment.CenterStart
    ) {
        val totalOptions = options.size
        
        // White Sliding indicator
        BoxWithConstraints(modifier = Modifier.fillMaxSize()) {
            val cellWidth = maxWidth / totalOptions
            val targetOffset = cellWidth * selectedIndex
            
            val animatedOffset by animateDpAsState(
                targetValue = targetOffset,
                animationSpec = spring(dampingRatio = Spring.DampingRatioLowBouncy, stiffness = Spring.StiffnessMediumLow),
                label = "segmented_slider"
            )
            
            Box(
                modifier = Modifier
                    .offset(x = animatedOffset)
                    .width(cellWidth)
                    .fillMaxHeight()
                    .shadow(elevation = 1.dp, shape = RoundedCornerShape(7.dp))
                    .clip(RoundedCornerShape(7.dp))
                    .background(selectionBg)
            )
        }
        
        // Titles Row overlay
        Row(modifier = Modifier.fillMaxSize()) {
            options.forEachIndexed { idx, title ->
                val active = idx == selectedIndex
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .fillMaxHeight()
                        .clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                            onClick = { onSelectedIndexChange(idx) }
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    CupertinoText(
                        text = title,
                        style = CupertinoTypography.footnote,
                        fontWeight = if (active) FontWeight.SemiBold else FontWeight.Medium,
                        color = cupertinoLabel()
                    )
                }
            }
        }
    }
}

// ==========================================
// CupertinoTextField (iOS Style TextInput)
// ==========================================
@Composable
fun CupertinoTextField(
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String,
    modifier: Modifier = Modifier,
    leadingIcon: (@Composable () -> Unit)? = null,
    trailingIcon: (@Composable () -> Unit)? = null,
    singleLine: Boolean = true,
    keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
    keyboardActions: KeyboardActions = KeyboardActions.Default
) {
    val bg = if (isDark()) Color(0xFF2C2C2E) else Color(0xFFE5E5EA).copy(alpha = 0.6f)
    
    Row(
        modifier = modifier
            .fillMaxWidth()
            .heightIn(min = 36.dp)
            .clip(RoundedCornerShape(10.dp))
            .background(bg)
            .padding(horizontal = 8.dp, vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        if (leadingIcon != null) {
            Box(modifier = Modifier.padding(end = 6.dp)) {
                leadingIcon()
            }
        }
        
        Box(
            modifier = Modifier.weight(1f),
            contentAlignment = Alignment.CenterStart
        ) {
            if (value.isEmpty()) {
                CupertinoText(
                    text = placeholder,
                    style = CupertinoTypography.body,
                    color = cupertinoSecondaryLabel()
                )
            }
            
            BasicTextField(
                value = value,
                onValueChange = onValueChange,
                singleLine = singleLine,
                textStyle = CupertinoTypography.body.copy(color = cupertinoLabel()),
                keyboardOptions = keyboardOptions,
                keyboardActions = keyboardActions,
                modifier = Modifier.fillMaxWidth(),
                cursorBrush = SolidColor(cupertinoBlue())
            )
        }
        
        if (trailingIcon != null) {
            Box(modifier = Modifier.padding(start = 6.dp)) {
                trailingIcon()
            }
        }
    }
}

// ==========================================
// CupertinoDialog (iOS Centered Alert Popup)
// ==========================================
@Composable
fun CupertinoDialog(
    onDismissRequest: () -> Unit,
    title: String,
    message: String,
    confirmButtonText: String,
    onConfirm: () -> Unit,
    dismissButtonText: String? = null,
    onDismiss: (() -> Unit)? = null,
    content: (@Composable ColumnScope.() -> Unit)? = null
) {
    val bg = if (isDark()) Color(0xEC252525) else Color(0xF2FCFCFC)
    
    Dialog(
        onDismissRequest = onDismissRequest,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black.copy(alpha = 0.4f)),
            contentAlignment = Alignment.Center
        ) {
            Column(
                modifier = Modifier
                    .width(270.dp)
                    .clip(RoundedCornerShape(14.dp))
                    .background(bg)
                    .padding(top = 20.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Title
                CupertinoText(
                    text = title,
                    style = CupertinoTypography.headline,
                    color = cupertinoLabel(),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 16.dp)
                )
                
                Spacer(modifier = Modifier.height(6.dp))
                
                // Message
                CupertinoText(
                    text = message,
                    style = CupertinoTypography.footnote,
                    color = cupertinoLabel(),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 16.dp)
                )

                if (content != null) {
                    Spacer(modifier = Modifier.height(12.dp))
                    Column(
                        modifier = Modifier.padding(horizontal = 16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        content()
                    }
                }
                
                Spacer(modifier = Modifier.height(16.dp))
                
                // Separator above buttons
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(0.5.dp)
                        .background(cupertinoSeparator())
                )
                
                // Buttons row or stack
                if (dismissButtonText != null) {
                    // Two buttons side-by-side
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(44.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Dismiss button
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .fillMaxHeight()
                                .clickable(
                                    interactionSource = remember { MutableInteractionSource() },
                                    indication = null,
                                    onClick = {
                                        onDismiss?.invoke()
                                        onDismissRequest()
                                    }
                                ),
                            contentAlignment = Alignment.Center
                        ) {
                            CupertinoText(
                                text = dismissButtonText,
                                style = CupertinoTypography.body,
                                color = cupertinoBlue()
                            )
                        }
                        
                        // Separator line between buttons
                        Box(
                            modifier = Modifier
                                .width(0.5.dp)
                                .fillMaxHeight()
                                .background(cupertinoSeparator())
                        )
                        
                        // Confirm button
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .fillMaxHeight()
                                .clickable(
                                    interactionSource = remember { MutableInteractionSource() },
                                    indication = null,
                                    onClick = onConfirm
                                ),
                            contentAlignment = Alignment.Center
                        ) {
                            CupertinoText(
                                text = confirmButtonText,
                                style = CupertinoTypography.headline,
                                color = cupertinoBlue()
                            )
                        }
                    }
                } else {
                    // Single confirm button
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(44.dp)
                            .clickable(
                                interactionSource = remember { MutableInteractionSource() },
                                indication = null,
                                onClick = onConfirm
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        CupertinoText(
                            text = confirmButtonText,
                            style = CupertinoTypography.headline,
                            color = cupertinoBlue()
                        )
                    }
                }
            }
        }
    }
}

// ==========================================
// CupertinoBadge (iOS Rounded label badge)
// ==========================================
@Composable
fun CupertinoBadge(
    text: String,
    modifier: Modifier = Modifier,
    color: Color = cupertinoBlue(),
    textColor: Color = Color.White
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(6.dp))
            .background(color)
            .padding(horizontal = 6.dp, vertical = 2.dp)
    ) {
        CupertinoText(
            text = text,
            style = CupertinoTypography.caption2,
            fontWeight = FontWeight.Bold,
            color = textColor
        )
    }
}

// ==========================================
// CupertinoScaffold (Custom layout)
// ==========================================
@Composable
fun CupertinoScaffold(
    modifier: Modifier = Modifier,
    topBar: (@Composable () -> Unit)? = null,
    bottomBar: (@Composable () -> Unit)? = null,
    content: @Composable (PaddingValues) -> Unit
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(cupertinoBgGrouped())
    ) {
        val topPadding = if (topBar != null) {
            // Estimate based on navigation topbar sizes (44dp + status bar)
            val topInset = WindowInsets.statusBars.asPaddingValues().calculateTopPadding()
            44.dp + topInset
        } else {
            0.dp
        }
        
        val bottomPadding = if (bottomBar != null) {
            val bottomInset = WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding()
            49.dp + bottomInset
        } else {
            0.dp
        }
        
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(top = topPadding, bottom = bottomPadding)
        ) {
            content(PaddingValues(top = 0.dp, bottom = 0.dp))
        }
        
        if (topBar != null) {
            Box(modifier = Modifier.align(Alignment.TopCenter)) {
                topBar()
            }
        }
        
        if (bottomBar != null) {
            Box(modifier = Modifier.align(Alignment.BottomCenter)) {
                bottomBar()
            }
        }
    }
}
