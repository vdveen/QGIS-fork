import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Modern toolbar with frosted-glass aesthetic.
 *
 * Contains: hamburger menu, project title, file open, zoom controls,
 * and tool buttons.
 */
Rectangle {
    id: root
    height: Theme.Theme.toolbarHeight
    color: Theme.Theme.toolbar

    property string projectTitle: ""
    property bool hasProject: false

    signal openProjectClicked()
    signal toggleSidebar()
    signal zoomInClicked()
    signal zoomOutClicked()
    signal zoomFullClicked()

    // Bottom border
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.Theme.surfaceBorder
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.Theme.spacingSmall
        anchors.rightMargin: Theme.Theme.spacingSmall
        spacing: Theme.Theme.spacingTiny

        // ── Sidebar toggle ───────────────────────────────────────────────
        ToolbarButton {
            icon: "\u2630"   // Hamburger ☰
            tooltip: "Toggle sidebar"
            onClicked: root.toggleSidebar()
        }

        // ── Separator ────────────────────────────────────────────────────
        ToolbarSeparator {}

        // ── File operations ──────────────────────────────────────────────
        ToolbarButton {
            icon: "\uD83D\uDCC2"   // Open folder
            tooltip: "Open project"
            onClicked: root.openProjectClicked()
        }

        ToolbarButton {
            icon: "\uD83D\uDCBE"   // Save
            tooltip: "Save project"
            enabled: root.hasProject
        }

        ToolbarSeparator {}

        // ── Navigation tools ─────────────────────────────────────────────
        ToolbarButton {
            icon: "\u270B"   // Hand (pan)
            tooltip: "Pan"
            highlighted: true    // Default active tool
        }

        ToolbarButton {
            icon: "\uD83D\uDD0D"   // Magnifier
            tooltip: "Zoom in"
            onClicked: root.zoomInClicked()
        }

        ToolbarButton {
            icon: "\u2296"   // Circled minus
            tooltip: "Zoom out"
            onClicked: root.zoomOutClicked()
        }

        ToolbarButton {
            icon: "\u2922"   // Full extent
            tooltip: "Zoom to full extent"
            onClicked: root.zoomFullClicked()
        }

        ToolbarSeparator {}

        // ── Selection & identify tools ───────────────────────────────────
        ToolbarButton {
            icon: "\u24D8"   // Info
            tooltip: "Identify features"
            enabled: root.hasProject
        }

        ToolbarButton {
            icon: "\u25A1"   // Rectangle select
            tooltip: "Select features"
            enabled: root.hasProject
        }

        ToolbarButton {
            icon: "\uD83D\uDCCF"   // Measure
            tooltip: "Measure distance"
            enabled: root.hasProject
        }

        // ── Spacer ───────────────────────────────────────────────────────
        Item { Layout.fillWidth: true }

        // ── Project title ────────────────────────────────────────────────
        Text {
            text: root.projectTitle
            color: Theme.Theme.textSecondary
            font.pixelSize: Theme.Theme.fontSizeBody
            font.weight: Theme.Theme.fontWeightMedium
            elide: Text.ElideRight
            Layout.maximumWidth: 300
        }

        Item { Layout.preferredWidth: Theme.Theme.spacingSmall }

        // ── Search ───────────────────────────────────────────────────────
        SearchBox {
            Layout.preferredWidth: 220
        }
    }
}
