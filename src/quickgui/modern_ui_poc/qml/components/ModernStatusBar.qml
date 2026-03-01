import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Status bar showing coordinates, CRS, scale, and rendering status.
 */
Rectangle {
    id: root
    height: Theme.Theme.statusBarHeight
    color: Theme.Theme.statusBar

    property string coordinateText: "0.000000, 0.000000"
    property string crsText: "EPSG:4326"
    property bool isRendering: false
    property real scale: 0

    // Top border
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: Theme.Theme.surfaceBorder
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.Theme.spacingMedium
        anchors.rightMargin: Theme.Theme.spacingMedium
        spacing: Theme.Theme.spacingLarge

        // ── Coordinate display ───────────────────────────────────────────
        StatusItem {
            label: "XY"
            value: root.coordinateText
            Layout.preferredWidth: 280
        }

        StatusSeparator {}

        // ── Scale ────────────────────────────────────────────────────────
        StatusItem {
            label: "Scale"
            value: root.scale > 0
                ? "1:" + Math.round(1.0 / root.scale).toLocaleString()
                : "--"
        }

        StatusSeparator {}

        // ── CRS ──────────────────────────────────────────────────────────
        StatusItem {
            label: "CRS"
            value: root.crsText
            clickable: true
        }

        Item { Layout.fillWidth: true }

        // ── Render status ────────────────────────────────────────────────
        Row {
            spacing: Theme.Theme.spacingSmall
            visible: root.isRendering

            // Animated spinner
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: Theme.Theme.accent
                anchors.verticalCenter: parent.verticalCenter

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    running: root.isRendering
                    NumberAnimation { to: 0.3; duration: 400 }
                    NumberAnimation { to: 1.0; duration: 400 }
                }
            }

            Text {
                text: "Rendering"
                color: Theme.Theme.accent
                font.pixelSize: Theme.Theme.fontSizeSmall
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
