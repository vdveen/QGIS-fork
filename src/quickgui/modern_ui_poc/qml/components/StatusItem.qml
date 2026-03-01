import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

/**
 * A labeled value display for the status bar.
 */
Item {
    id: root
    implicitHeight: parent ? parent.height : 24
    implicitWidth: row.implicitWidth

    property string label: ""
    property string value: ""
    property bool clickable: false

    RowLayout {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.Theme.spacingSmall

        Text {
            text: root.label
            color: Theme.Theme.textDim
            font.pixelSize: Theme.Theme.fontSizeSmall
            font.weight: Theme.Theme.fontWeightMedium
        }

        Text {
            text: root.value
            color: root.clickable && itemMouse.containsMouse
                ? Theme.Theme.primary
                : Theme.Theme.textSecondary
            font.pixelSize: Theme.Theme.fontSizeSmall
            font.family: "monospace"

            MouseArea {
                id: itemMouse
                anchors.fill: parent
                hoverEnabled: root.clickable
                cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
        }
    }
}
