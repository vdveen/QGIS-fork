import QtQuick
import QtQuick.Controls
import "../theme" as Theme

AbstractButton {
    id: root
    implicitWidth: 32
    implicitHeight: 32

    property string icon: ""

    hoverEnabled: true

    background: Rectangle {
        radius: Theme.Theme.radiusMedium
        color: root.pressed ? Theme.Theme.surfaceActive
             : root.hovered ? Theme.Theme.surfaceHover
             : "transparent"
    }

    contentItem: Text {
        text: root.icon
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Theme.Theme.fontSizeLarge
        font.weight: Theme.Theme.fontWeightMedium
        color: root.hovered ? Theme.Theme.textPrimary : Theme.Theme.textSecondary
    }
}
