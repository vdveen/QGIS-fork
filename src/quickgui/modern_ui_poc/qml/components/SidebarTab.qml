import QtQuick
import QtQuick.Controls
import "../theme" as Theme

/**
 * A tab button for the sidebar tab bar.
 */
AbstractButton {
    id: root
    implicitHeight: 32
    implicitWidth: Math.max(80, label.implicitWidth + Theme.Theme.spacingLarge)

    property bool active: false

    hoverEnabled: true

    background: Rectangle {
        radius: Theme.Theme.radiusMedium
        color: {
            if (root.active)
                return Theme.Theme.surfaceActive
            if (root.hovered)
                return Theme.Theme.sidebarHover
            return "transparent"
        }

        Behavior on color {
            ColorAnimation { duration: Theme.Theme.animFast }
        }
    }

    contentItem: Text {
        id: label
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.Theme.fontSizeBody
        font.weight: root.active ? Theme.Theme.fontWeightMedium : Theme.Theme.fontWeightNormal
        color: root.active ? Theme.Theme.textPrimary : Theme.Theme.textSecondary
    }
}
