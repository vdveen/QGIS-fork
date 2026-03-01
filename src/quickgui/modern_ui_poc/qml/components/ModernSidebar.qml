import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Collapsible sidebar with layer tree, bookmarks, and data browser tabs.
 *
 * The sidebar smoothly animates between expanded and collapsed states.
 */
Rectangle {
    id: root
    color: Theme.Theme.sidebar
    implicitWidth: expanded ? Theme.Theme.sidebarWidth : 0
    clip: true

    property bool expanded: true
    property var layerModel: null

    function toggle() {
        expanded = !expanded
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Theme.Theme.animSlow
            easing.type: Easing.OutCubic
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: Theme.Theme.spacingSmall
        spacing: 0
        visible: root.expanded
        opacity: root.expanded ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.Theme.animNormal }
        }

        // ── Tab bar ──────────────────────────────────────────────────────
        Row {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.Theme.spacingSmall
            Layout.rightMargin: Theme.Theme.spacingSmall
            spacing: Theme.Theme.spacingTiny

            SidebarTab {
                text: "Layers"
                active: tabStack.currentIndex === 0
                onClicked: tabStack.currentIndex = 0
            }
            SidebarTab {
                text: "Browser"
                active: tabStack.currentIndex === 1
                onClicked: tabStack.currentIndex = 1
            }
            SidebarTab {
                text: "Processing"
                active: tabStack.currentIndex === 2
                onClicked: tabStack.currentIndex = 2
            }
        }

        // ── Tab content ──────────────────────────────────────────────────
        StackLayout {
            id: tabStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            // Tab 0: Layers
            LayerPanel {
                layerModel: root.layerModel
            }

            // Tab 1: Browser (placeholder)
            PlaceholderPanel {
                title: "Data Browser"
                description: "Browse and add data sources"
                icon: "\uD83D\uDCC1"
            }

            // Tab 2: Processing (placeholder)
            PlaceholderPanel {
                title: "Processing Toolbox"
                description: "Geoprocessing algorithms"
                icon: "\u2699"
            }
        }
    }
}
