import QtQuick
import QtQuick.Controls
import "../theme" as Theme

/**
 * A single toolbar button with hover/press states and optional tooltip.
 */
AbstractButton {
    id: root
    implicitWidth: 36
    implicitHeight: 36

    property string icon: ""
    property string tooltip: ""
    property bool highlighted: false

    hoverEnabled: enabled

    ToolTip.visible: hovered && tooltip.length > 0
    ToolTip.text: tooltip
    ToolTip.delay: 600

    background: Rectangle {
        radius: Theme.Theme.radiusMedium
        color: {
            if (!root.enabled)
                return "transparent"
            if (root.pressed)
                return Theme.Theme.surfaceActive
            if (root.highlighted)
                return Theme.Theme.primaryDim
            if (root.hovered)
                return Theme.Theme.surfaceHover
            return "transparent"
        }

        Behavior on color {
            ColorAnimation { duration: Theme.Theme.animFast }
        }
    }

    contentItem: Text {
        text: root.icon
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.Theme.fontSizeMedium
        color: {
            if (!root.enabled)
                return Theme.Theme.textDim
            if (root.highlighted)
                return Theme.Theme.primary
            return Theme.Theme.textPrimary
        }

        Behavior on color {
            ColorAnimation { duration: Theme.Theme.animFast }
        }
    }
}
