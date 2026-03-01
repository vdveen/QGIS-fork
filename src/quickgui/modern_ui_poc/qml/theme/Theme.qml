pragma Singleton
import QtQuick

/**
 * Central theme definition for the modern QGIS UI.
 *
 * Inspired by contemporary design systems (Material 3, Fluent, macOS Sonoma).
 * All colors, radii, spacing, and typography are defined here so the entire
 * look can be changed in one place.
 */
QtObject {
    // ── Color palette ────────────────────────────────────────────────────────
    // Dark theme by default — feels professional for GIS work
    readonly property color background:       "#1a1b1e"
    readonly property color surface:          "#242529"
    readonly property color surfaceHover:     "#2e2f34"
    readonly property color surfaceActive:    "#383940"
    readonly property color surfaceBorder:    "#3a3b40"

    readonly property color sidebar:          "#1e1f23"
    readonly property color sidebarHover:     "#2a2b30"

    readonly property color toolbar:          "#242529"
    readonly property color statusBar:        "#1a1b1e"

    readonly property color primary:          "#6c8cff"     // Calm blue
    readonly property color primaryHover:     "#8aa4ff"
    readonly property color primaryDim:       "#3d4f80"
    readonly property color accent:           "#4ecdc4"     // Teal accent
    readonly property color warning:          "#ff8c42"
    readonly property color danger:           "#ff6b6b"
    readonly property color success:          "#51cf66"

    readonly property color textPrimary:      "#e8e9ed"
    readonly property color textSecondary:    "#9b9ca2"
    readonly property color textDim:          "#6b6c72"
    readonly property color textOnPrimary:    "#ffffff"

    // ── Typography ───────────────────────────────────────────────────────────
    readonly property string fontFamily:      "Inter, SF Pro Display, Segoe UI, system-ui, sans-serif"
    readonly property int fontSizeSmall:      11
    readonly property int fontSizeBody:       13
    readonly property int fontSizeMedium:     14
    readonly property int fontSizeLarge:      16
    readonly property int fontSizeTitle:      20
    readonly property int fontSizeHero:       28

    readonly property int fontWeightNormal:   Font.Normal
    readonly property int fontWeightMedium:   Font.Medium
    readonly property int fontWeightSemiBold: Font.DemiBold
    readonly property int fontWeightBold:     Font.Bold

    // ── Spacing & sizing ─────────────────────────────────────────────────────
    readonly property int spacingTiny:        4
    readonly property int spacingSmall:       8
    readonly property int spacingMedium:      12
    readonly property int spacingLarge:       16
    readonly property int spacingXLarge:      24
    readonly property int spacingXXLarge:     32

    readonly property int radiusSmall:        4
    readonly property int radiusMedium:       8
    readonly property int radiusLarge:        12
    readonly property int radiusXLarge:       16
    readonly property int radiusFull:         999   // Pill shape

    readonly property int sidebarWidth:       280
    readonly property int sidebarCollapsed:   56
    readonly property int toolbarHeight:      48
    readonly property int statusBarHeight:    32
    readonly property int iconSize:           20
    readonly property int iconSizeLarge:      24

    // ── Shadows ──────────────────────────────────────────────────────────────
    // QML doesn't have CSS box-shadow, but we use layer effects and overlays
    readonly property real shadowOpacity:     0.3
    readonly property int shadowRadius:       16

    // ── Animation ────────────────────────────────────────────────────────────
    readonly property int animFast:           120
    readonly property int animNormal:         200
    readonly property int animSlow:           350
    readonly property int animEasing:         Easing.OutCubic
}
