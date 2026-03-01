import QtQuick
import QtQuick.Controls
import "../theme" as Theme

/**
 * Small icon button used in panel headers.
 */
AbstractButton {
    id: root
    implicitWidth: 26
    implicitHeight: 26

    property string icon: ""
    property string tooltip: ""

    hoverEnabled: true

    ToolTip.visible: hovered && tooltip.length > 0
    ToolTip.text: tooltip
    ToolTip.delay: 600

    background: Rectangle {
        radius: Theme.Theme.radiusSmall
        color: root.pressed ? Theme.Theme.surfaceActive
             : root.hovered ? Theme.Theme.surfaceHover
             : "transparent"

        Behavior on color {
            ColorAnimation { duration: Theme.Theme.animFast }
        }
    }

    contentItem: Text {
        text: root.icon
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.Theme.fontSizeBody
        color: root.hovered ? Theme.Theme.textPrimary : Theme.Theme.textSecondary
    }
}
