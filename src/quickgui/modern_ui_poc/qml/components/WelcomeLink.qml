import QtQuick
import QtQuick.Controls
import "../theme" as Theme

/**
 * Small text link for secondary actions on the welcome screen.
 */
AbstractButton {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: 28

    property string icon: ""

    hoverEnabled: true

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Theme.Theme.spacingTiny

        Text {
            text: root.icon
            font.pixelSize: Theme.Theme.fontSizeSmall
            color: root.hovered ? Theme.Theme.primary : Theme.Theme.textDim
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.text
            font.pixelSize: Theme.Theme.fontSizeBody
            color: root.hovered ? Theme.Theme.primary : Theme.Theme.textSecondary
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: Theme.Theme.animFast }
            }
        }
    }
}
