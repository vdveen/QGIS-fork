# QGIS Modern UI Overhaul — Feasibility Analysis

## Executive Summary

**Yes, it is possible** to give QGIS a modern, aesthetically pleasing UI while keeping all its functionality — and there is already a working proof of this in the QGIS ecosystem.

The key insight is that QGIS already has a **three-layer architecture** where the core engine (`qgis_core`) is cleanly separated from the widget-based UI (`qgis_gui`). Furthermore, QGIS already ships a QML-based map canvas (`src/quickgui/`) that links only to `qgis_core` and renders maps identically — this is the same technology that powers **QField**, a production-quality mobile GIS app built on QGIS's core.

A modern UI built with **Qt Quick / QML** would:
- Look and feel like a contemporary desktop application (think VS Code, Figma, Arc Browser)
- Render maps at identical speed (same QPainter engine, background threads, raster output)
- Run on **Mac, Windows, and Linux** from a single codebase
- Be GPU-accelerated for the UI chrome (animations, transitions, compositing)
- Require **zero changes** to the rendering pipeline or data processing engine

The difficulty lies in scale: QGIS has 624 UI form files, 256+ widget classes, and an 18,000-line main window class. A full migration is a multi-year effort, but a **usable hybrid prototype** can be built in 3-6 months.

---

## Architecture Analysis

### How QGIS is Structured

```
┌─────────────────────────────────────────────────────────┐
│  src/app/           QgisApp (main window, 18K lines)    │  ← Qt Widgets
├─────────────────────────────────────────────────────────┤
│  src/gui/           256+ widgets, 624 .ui forms         │  ← Qt Widgets
├─────────────────────────────────────────────────────────┤
│  src/quickgui/      QML map canvas (already exists!)    │  ← Qt Quick ✓
├─────────────────────────────────────────────────────────┤
│  src/core/          Rendering, data, processing, CRS    │  ← Qt Core only*
└─────────────────────────────────────────────────────────┘
     * qgis_core links Qt::Widgets but uses it minimally (~33 files)
```

Dependencies flow **upward only**: `core` → `gui` → `app`. This means `qgis_core` can be used without `qgis_gui` — exactly what `src/quickgui/` already does.

### What the Proof-of-Concept Demonstrates

This prototype (`src/quickgui/modern_ui_poc/`) shows a complete modern UI shell that:

1. **Links only to `qgis_core` and `qgis_quick`** — no Qt Widgets dependency
2. Uses `QgsQuickMapCanvasMap` to display the map — same rendering engine as desktop QGIS
3. Provides a modern dark-themed UI with:
   - Toolbar with tool buttons, search, and project controls
   - Collapsible sidebar with layers, browser, and processing tabs
   - Layer panel with visibility toggles and type indicators
   - Status bar with coordinates, CRS, and scale display
   - Welcome screen with quick-start actions
   - Floating zoom controls
4. All UI components use GPU-accelerated QML rendering
5. Smooth animations on all interactive elements

### Map Rendering: How It Works

The rendering pipeline is the critical piece — and it stays **completely unchanged**:

```
Project layers → QgsMapRendererParallelJob → QPainter renders to QImage
                                                       ↓
                                               Background thread(s)
                                                       ↓
                                               QImage pixel buffer
                                                       ↓
                                  ┌──────────────────────┴──────────────────────┐
                                  │                                             │
                          Qt Widgets path:                              Qt Quick path:
                     QgsMapCanvas (QGraphicsView)              QgsQuickMapCanvasMap (QQuickItem)
                     Blits QImage to widget                    Uploads QImage as GPU texture
                                  │                                             │
                              CPU compositing                          GPU compositing ✓
```

Both paths receive the same `QImage`. The QML path is actually **faster** for the UI chrome because QML uses hardware-accelerated compositing via the scene graph, while Qt Widgets uses CPU painting.

---

## Scale of the Challenge

| Component | Count | Migration Effort |
|-----------|-------|------------------|
| `.ui` form files | 624 | Each needs a QML equivalent |
| GUI widget classes (`src/gui/`) | 256+ | Many can be simplified in QML |
| Main app class lines | 18,000+ | Needs complete redesign |
| Plugin interface methods | 100+ | Needs QML-native adapter |
| Map tools | 30+ | Need event system bridge |
| Processing algorithms | 1,000+ | UI-independent (no change) |
| Data providers | 50+ | UI-independent (no change) |
| Python plugins (ecosystem) | 1,000+ | Need compatibility layer |

**What doesn't change:** The entire `src/core/` library (~2,035 source files), all processing algorithms, all data providers, all rendering code, projection handling, and coordinate transforms. This is the vast majority of QGIS's value.

**What changes:** The presentation layer — toolbars, dialogs, panels, and the main window.

---

## Recommended Approach: Hybrid QML Migration

### Phase 1: QML Application Shell (3-6 months, 2-3 developers)
- Modern QML main window (this prototype)
- Embed `QgsQuickMapCanvasMap` as the central map view
- Implement core toolbar, sidebar, and status bar
- Use `QQuickWidget` to embed critical legacy dialogs temporarily
- **Deliverable:** A runnable app that opens projects and displays maps

### Phase 2: High-Impact Dialog Migration (6-12 months, 3-5 developers)
- Rewrite the 20 most-used dialogs in QML:
  - Layer properties / Style editor
  - Processing toolbox + algorithm dialogs
  - Settings / Options
  - Data source manager
  - Print layout (separate challenge)
- Create QML versions of common widgets: color picker, CRS selector, expression builder

### Phase 3: Plugin System Adaptation (3-6 months, 2-3 developers)
- New `QgisQuickInterface` for QML-native plugin APIs
- Python plugin adapter layer for backward compatibility
- Plugin Manager in QML

### Phase 4: Long Tail (12+ months)
- Migrate remaining ~500 dialogs
- Remove Qt Widgets dependency from application layer
- `qgis_gui` becomes a legacy compatibility library

---

## Why Qt Quick/QML (Not Electron, SwiftUI, etc.)

| Framework | Performance | Cross-platform | QGIS Integration | Effort |
|-----------|-------------|----------------|-------------------|--------|
| **Qt Quick/QML** | Excellent (GPU) | Mac + Win + Linux | Direct (same Qt) | High |
| Electron/Web | Poor (IPC overhead) | Mac + Win + Linux | Complex (bridge) | Extreme |
| SwiftUI + WinUI | Good (native) | Separate codebases | Complex (bridge) | Extreme |
| Qt Stylesheets | Unchanged | Same | Trivial | Low |

Qt Quick/QML is the clear winner because:
- It's the **same Qt ecosystem** — no foreign function interface needed
- `qgis_core` already links Qt, so there's no additional dependency
- It has been **proven by QField** to work with the QGIS rendering engine
- It's GPU-accelerated and supports modern UI paradigms (animations, gestures, responsive layout)
- It runs natively on Mac, Windows, Linux, iOS, and Android

---

## Real-World Precedent: QField

[QField](https://qfield.org/) by OPENGIS.ch is a production-quality mobile GIS application that does exactly what this analysis proposes:

- Uses `qgis_core` for all GIS operations
- Uses `QgsQuickMapCanvasMap` for map rendering
- Has a complete QML-based UI
- Runs on Android, iOS, Windows, macOS, and Linux
- Supports offline editing, GPS, camera integration, and cloud sync
- Has been in production since 2016

QField proves that a QML frontend over `qgis_core` is not only feasible but commercially viable.

---

## Files in This Prototype

```
modern_ui_poc/
├── CMakeLists.txt                    Build configuration
├── main.cpp                          App entry point (QGIS core + QML init)
├── qgsmodernuiapplication.h/cpp      Bridge between qgis_core and QML
├── qgslayerlistmodel.h/cpp           QML-friendly layer list model
├── resources.qrc                     Qt resource file
├── FEASIBILITY.md                    This document
└── qml/
    ├── main.qml                      Application window layout
    ├── theme/
    │   ├── Theme.qml                 Colors, typography, spacing, animations
    │   └── qmldir                    QML module definition
    └── components/
        ├── ModernToolbar.qml         Top toolbar with tools and search
        ├── ModernSidebar.qml         Collapsible sidebar with tabs
        ├── ModernStatusBar.qml       Bottom status bar
        ├── LayerPanel.qml            Layer list with visibility toggles
        ├── LayerListItem.qml         Individual layer entry
        ├── MapZoomControls.qml       Floating zoom buttons
        ├── WelcomeOverlay.qml        Welcome screen when no project loaded
        ├── SearchBox.qml             Toolbar search input
        ├── ToolbarButton.qml         Toolbar icon button
        ├── SmallButton.qml           Panel header button
        ├── SidebarTab.qml            Sidebar tab button
        ├── StatusItem.qml            Status bar value display
        ├── PlaceholderPanel.qml      Empty panel placeholder
        └── ...                       Supporting components
```

## How to Build and Run

```bash
# Prerequisites: Qt 6.5+, QGIS 3.x installed from source or packages

# Option A: Build inside the QGIS source tree
cd build && cmake .. -DWITH_QUICK=ON && make qgis_modern_ui

# Option B: Build standalone
cd src/quickgui/modern_ui_poc
mkdir build && cd build
cmake .. -DQGIS_PREFIX_PATH=/usr/local
make
QGIS_PREFIX_PATH=/usr/local ./qgis_modern_ui
```

---

## Conclusion

A modern UI for QGIS is **architecturally feasible, performance-neutral for map rendering, and proven by QField**. The challenge is purely one of scale — there are hundreds of dialogs to rebuild. But the core question of "can the engine work without the old UI?" is definitively answered: **yes, it already does**.
