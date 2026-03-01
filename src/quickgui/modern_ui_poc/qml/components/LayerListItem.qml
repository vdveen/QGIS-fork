import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * A single layer entry in the layer panel.
 * Shows visibility toggle, type icon, name, and context menu trigger.
 */
Rectangle {
    id: root
    implicitHeight: 36
    radius: Theme.Theme.radiusMedium
    color: mouseArea.containsMouse ? Theme.Theme.surfaceHover : "transparent"

    property string layerName: ""
    property string layerType: ""
    property bool layerVisible: true
    property string layerIcon: ""

    signal visibilityToggled()

    Behavior on color {
        ColorAnimation { duration: Theme.Theme.animFast }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.Theme.spacingSmall
        anchors.rightMargin: Theme.Theme.spacingSmall
        spacing: Theme.Theme.spacingSmall

        // ── Visibility checkbox ──────────────────────────────────────────
        AbstractButton {
            implicitWidth: 20
            implicitHeight: 20
            onClicked: root.visibilityToggled()

            contentItem: Rectangle {
                radius: Theme.Theme.radiusSmall
                border.width: 1.5
                border.color: root.layerVisible ? Theme.Theme.primary : Theme.Theme.textDim
                color: root.layerVisible ? Theme.Theme.primary : "transparent"

                Behavior on border.color { ColorAnimation { duration: Theme.Theme.animFast } }
                Behavior on color { ColorAnimation { duration: Theme.Theme.animFast } }

                Text {
                    anchors.centerIn: parent
                    text: "\u2713"   // Checkmark
                    color: Theme.Theme.textOnPrimary
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    visible: root.layerVisible
                }
            }
        }

        // ── Layer type indicator ─────────────────────────────────────────
        Rectangle {
            implicitWidth: 6
            implicitHeight: 6
            radius: 3
            color: {
                switch (root.layerType) {
                    case "vector": return Theme.Theme.primary
                    case "raster": return Theme.Theme.accent
                    case "mesh":   return Theme.Theme.warning
                    default:       return Theme.Theme.textDim
                }
            }
        }

        // ── Layer name ───────────────────────────────────────────────────
        Text {
            text: root.layerName
            color: root.layerVisible ? Theme.Theme.textPrimary : Theme.Theme.textDim
            font.pixelSize: Theme.Theme.fontSizeBody
            elide: Text.ElideRight
            Layout.fillWidth: true

            Behavior on color {
                ColorAnimation { duration: Theme.Theme.animFast }
            }
        }

        // ── Layer type badge ─────────────────────────────────────────────
        Rectangle {
            implicitWidth: typeLabel.implicitWidth + 8
            implicitHeight: 18
            radius: Theme.Theme.radiusSmall
            color: Theme.Theme.surfaceActive
            visible: mouseArea.containsMouse

            Text {
                id: typeLabel
                anchors.centerIn: parent
                text: root.layerType
                font.pixelSize: 10
                color: Theme.Theme.textSecondary
            }
        }
    }
}
