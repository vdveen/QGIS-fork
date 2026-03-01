import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Modern search box with rounded corners and subtle styling.
 */
Rectangle {
    id: root
    implicitHeight: 32
    radius: Theme.Theme.radiusFull
    color: Theme.Theme.surfaceHover
    border.color: searchField.activeFocus ? Theme.Theme.primary : "transparent"
    border.width: 1.5

    Behavior on border.color {
        ColorAnimation { duration: Theme.Theme.animNormal }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.Theme.spacingMedium
        anchors.rightMargin: Theme.Theme.spacingSmall
        spacing: Theme.Theme.spacingSmall

        Text {
            text: "\uD83D\uDD0D"
            font.pixelSize: Theme.Theme.fontSizeSmall
            color: Theme.Theme.textDim
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "Search layers, tools..."
            color: Theme.Theme.textPrimary
            placeholderTextColor: Theme.Theme.textDim
            font.pixelSize: Theme.Theme.fontSizeBody
            background: Item {}
            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0
        }

        // Keyboard shortcut hint
        Rectangle {
            implicitWidth: shortcutLabel.implicitWidth + 8
            implicitHeight: 20
            radius: Theme.Theme.radiusSmall
            color: Theme.Theme.surfaceActive
            visible: !searchField.activeFocus

            Text {
                id: shortcutLabel
                anchors.centerIn: parent
                text: "\u2318K"   // Cmd+K
                font.pixelSize: Theme.Theme.fontSizeSmall
                color: Theme.Theme.textDim
            }
        }
    }
}
