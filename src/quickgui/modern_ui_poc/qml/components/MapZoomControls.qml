import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Floating zoom controls that overlay the map canvas.
 *
 * Positioned in the bottom-right corner with a frosted-glass pill shape.
 */
Rectangle {
    id: root
    implicitWidth: 40
    implicitHeight: col.implicitHeight + Theme.Theme.spacingSmall * 2
    radius: Theme.Theme.radiusXLarge
    color: Qt.rgba(0.12, 0.12, 0.14, 0.85)
    border.color: Theme.Theme.surfaceBorder
    border.width: 1

    signal zoomIn()
    signal zoomOut()

    Column {
        id: col
        anchors.centerIn: parent
        spacing: Theme.Theme.spacingTiny

        // Zoom in
        ZoomButton {
            icon: "\u002B"
            onClicked: root.zoomIn()
        }

        // Separator
        Rectangle {
            width: 24
            height: 1
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.Theme.surfaceBorder
        }

        // Zoom out
        ZoomButton {
            icon: "\u2212"
            onClicked: root.zoomOut()
        }
    }
}
