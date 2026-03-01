import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Placeholder panel for sidebar tabs not yet implemented.
 */
Item {
    property string title: ""
    property string description: ""
    property string icon: ""

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.Theme.spacingMedium

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: icon
            font.pixelSize: 32
            color: Theme.Theme.textDim
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: title
            font.pixelSize: Theme.Theme.fontSizeMedium
            font.weight: Theme.Theme.fontWeightMedium
            color: Theme.Theme.textSecondary
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: description
            font.pixelSize: Theme.Theme.fontSizeBody
            color: Theme.Theme.textDim
        }
    }
}
