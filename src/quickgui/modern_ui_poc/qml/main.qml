import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import QgsQuick 0.1 as QgsQuick
import "theme" as Theme
import "components"

/**
 * Main application window for the QGIS Modern UI proof-of-concept.
 *
 * Layout:
 *  ┌──────────────────────────────────────────────────┐
 *  │  Toolbar                                         │
 *  ├────────┬─────────────────────────────────────────┤
 *  │        │                                         │
 *  │ Side-  │         Map Canvas                      │
 *  │  bar   │     (QgsQuickMapCanvasMap)               │
 *  │        │                                         │
 *  │        │                                         │
 *  ├────────┴─────────────────────────────────────────┤
 *  │  Status Bar                                      │
 *  └──────────────────────────────────────────────────┘
 */
ApplicationWindow {
    id: window
    visible: true
    width: 1440
    height: 900
    title: "QGIS Modern UI — " + appBridge.projectTitle
    color: Theme.Theme.background

    // ── File dialog for opening projects ──────────────────────────────────
    FileDialog {
        id: openProjectDialog
        title: "Open QGIS Project"
        nameFilters: ["QGIS Projects (*.qgs *.qgz)", "All files (*)"]
        onAccepted: {
            appBridge.openProject(selectedFile)
        }
    }

    // ── Toolbar ──────────────────────────────────────────────────────────
    header: ModernToolbar {
        id: toolbar
        projectTitle: appBridge.projectTitle
        hasProject: appBridge.hasProject

        onOpenProjectClicked: openProjectDialog.open()
        onToggleSidebar: sidebar.toggle()
        onZoomInClicked: mapCanvas.zoomIn(Qt.point(mapCanvas.width / 2, mapCanvas.height / 2))
        onZoomOutClicked: mapCanvas.zoomOut(Qt.point(mapCanvas.width / 2, mapCanvas.height / 2))
        onZoomFullClicked: {
            if (appBridge.hasProject) {
                mapCanvas.mapSettings.extent = mapCanvas.mapSettings.project.nonSpatialLayersExtent
                    ? mapCanvas.mapSettings.extent
                    : mapCanvas.mapSettings.extent
            }
        }
    }

    // ── Main content ─────────────────────────────────────────────────────
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar with layer panel
        ModernSidebar {
            id: sidebar
            Layout.fillHeight: true
            layerModel: appBridge.layerModel
        }

        // Separator line
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: Theme.Theme.surfaceBorder
        }

        // Map canvas area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // The actual QGIS map canvas — rendered by qgis_core, displayed via QML
            QgsQuick.MapCanvas {
                id: mapCanvas
                anchors.fill: parent
                incrementalRendering: true

                Component.onCompleted: {
                    mapSettings.project = qgisProject
                }

                // Rendering indicator
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: Theme.Theme.spacingMedium
                    width: renderingLabel.implicitWidth + Theme.Theme.spacingLarge
                    height: 28
                    radius: Theme.Theme.radiusFull
                    color: Theme.Theme.primary
                    opacity: mapCanvas.isRendering ? 1.0 : 0.0
                    visible: opacity > 0

                    Behavior on opacity {
                        NumberAnimation { duration: Theme.Theme.animNormal }
                    }

                    Text {
                        id: renderingLabel
                        anchors.centerIn: parent
                        text: "Rendering..."
                        color: Theme.Theme.textOnPrimary
                        font.pixelSize: Theme.Theme.fontSizeSmall
                        font.weight: Theme.Theme.fontWeightMedium
                    }
                }

                // Zoom controls overlay
                MapZoomControls {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: Theme.Theme.spacingLarge

                    onZoomIn: mapCanvas.zoomIn(Qt.point(mapCanvas.width / 2, mapCanvas.height / 2))
                    onZoomOut: mapCanvas.zoomOut(Qt.point(mapCanvas.width / 2, mapCanvas.height / 2))
                }

                // Welcome overlay when no project is loaded
                WelcomeOverlay {
                    anchors.fill: parent
                    visible: !appBridge.hasProject
                    onOpenProjectClicked: openProjectDialog.open()
                }

                // Track mouse position for status bar
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                    onPositionChanged: function(mouse) {
                        let mapPoint = mapCanvas.mapSettings.screenToCoordinate(
                            Qt.point(mouse.x, mouse.y))
                        statusBar.coordinateText = appBridge.formatCoordinate(
                            mapPoint.x, mapPoint.y)
                    }
                }
            }
        }
    }

    // ── Status bar ───────────────────────────────────────────────────────
    footer: ModernStatusBar {
        id: statusBar
        crsText: appBridge.crsDescription
        isRendering: mapCanvas.isRendering
        scale: mapCanvas.mapSettings ? mapCanvas.mapSettings.mapUnitsPerPixel : 0
    }
}
