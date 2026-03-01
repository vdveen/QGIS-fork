import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Layer list panel with visibility toggles, drag-to-reorder placeholders,
 * and modern list styling.
 */
Item {
    id: root
    property var layerModel: null

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.Theme.spacingSmall
        spacing: Theme.Theme.spacingSmall

        // ── Layer toolbar ────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.Theme.spacingTiny

            Text {
                text: "Layers"
                font.pixelSize: Theme.Theme.fontSizeMedium
                font.weight: Theme.Theme.fontWeightSemiBold
                color: Theme.Theme.textPrimary
                Layout.fillWidth: true
            }

            SmallButton {
                icon: "\u002B"   // +
                tooltip: "Add layer"
            }

            SmallButton {
                icon: "\u2212"   // −
                tooltip: "Remove layer"
            }

            SmallButton {
                icon: "\u2699"   // Gear
                tooltip: "Layer options"
            }
        }

        // ── Layer filter ─────────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 28
            radius: Theme.Theme.radiusMedium
            color: Theme.Theme.surfaceHover

            TextField {
                anchors.fill: parent
                anchors.leftMargin: Theme.Theme.spacingSmall
                placeholderText: "Filter layers..."
                color: Theme.Theme.textPrimary
                placeholderTextColor: Theme.Theme.textDim
                font.pixelSize: Theme.Theme.fontSizeSmall
                background: Item {}
                leftPadding: 0
                verticalAlignment: Text.AlignVCenter
            }
        }

        // ── Layer list ───────────────────────────────────────────────────
        ListView {
            id: layerListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.layerModel
            clip: true
            spacing: 2

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: 2
                    color: Theme.Theme.textDim
                    opacity: 0.5
                }
            }

            delegate: LayerListItem {
                width: layerListView.width
                layerName: model.name
                layerType: model.layerType
                layerVisible: model.isVisible
                layerIcon: model.iconName

                onVisibilityToggled: {
                    root.layerModel.toggleVisibility(index)
                }
            }

            // Empty state
            Text {
                anchors.centerIn: parent
                visible: layerListView.count === 0
                text: "No layers\nOpen a project to get started"
                horizontalAlignment: Text.AlignHCenter
                color: Theme.Theme.textDim
                font.pixelSize: Theme.Theme.fontSizeBody
                lineHeight: 1.5
            }
        }
    }
}
