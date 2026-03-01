import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Theme

/**
 * Welcome overlay shown when no project is loaded.
 * Features a modern, centered card with quick-start actions.
 */
Rectangle {
    id: root
    color: Theme.Theme.background

    signal openProjectClicked()

    // Subtle gradient background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.10, 0.11, 0.13, 1.0) }
            GradientStop { position: 0.5; color: Qt.rgba(0.08, 0.09, 0.12, 1.0) }
            GradientStop { position: 1.0; color: Qt.rgba(0.10, 0.11, 0.13, 1.0) }
        }
    }

    // Decorative grid pattern
    Canvas {
        anchors.fill: parent
        opacity: 0.04
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = "#ffffff"
            ctx.lineWidth = 0.5
            var step = 40
            for (var x = 0; x < width; x += step) {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
                ctx.stroke()
            }
            for (var y = 0; y < height; y += step) {
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
            }
        }
    }

    // ── Welcome card ─────────────────────────────────────────────────────
    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.Theme.spacingXLarge
        width: 420

        // Logo area
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 72
            implicitHeight: 72
            radius: Theme.Theme.radiusXLarge
            color: Theme.Theme.primaryDim

            Text {
                anchors.centerIn: parent
                text: "Q"
                font.pixelSize: 36
                font.weight: Font.Bold
                color: Theme.Theme.primary
            }
        }

        // Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "QGIS Modern UI"
            font.pixelSize: Theme.Theme.fontSizeHero
            font.weight: Theme.Theme.fontWeightBold
            color: Theme.Theme.textPrimary
        }

        // Subtitle
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "A modern interface for the world's most powerful\nopen-source GIS platform"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.Theme.fontSizeMedium
            color: Theme.Theme.textSecondary
            lineHeight: 1.6
        }

        Item { implicitHeight: Theme.Theme.spacingSmall }

        // ── Action buttons ───────────────────────────────────────────────
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.Theme.spacingMedium

            // Primary CTA
            AbstractButton {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 260
                implicitHeight: 44

                onClicked: root.openProjectClicked()

                background: Rectangle {
                    radius: Theme.Theme.radiusMedium
                    color: parent.pressed ? Qt.darker(Theme.Theme.primary, 1.2)
                         : parent.hovered ? Theme.Theme.primaryHover
                         : Theme.Theme.primary

                    Behavior on color {
                        ColorAnimation { duration: Theme.Theme.animFast }
                    }
                }

                contentItem: Text {
                    text: "Open Project"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.Theme.fontSizeMedium
                    font.weight: Theme.Theme.fontWeightSemiBold
                    color: Theme.Theme.textOnPrimary
                }
            }

            // Secondary actions row
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.Theme.spacingLarge

                WelcomeLink { text: "New Project"; icon: "\u002B" }
                WelcomeLink { text: "Recent Files"; icon: "\uD83D\uDD52" }
                WelcomeLink { text: "Templates"; icon: "\uD83D\uDCC4" }
            }
        }

        Item { implicitHeight: Theme.Theme.spacingXLarge }

        // ── Architecture note ────────────────────────────────────────────
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 380
            implicitHeight: archCol.implicitHeight + Theme.Theme.spacingLarge
            radius: Theme.Theme.radiusMedium
            color: Qt.rgba(1, 1, 1, 0.03)
            border.color: Theme.Theme.surfaceBorder
            border.width: 1

            ColumnLayout {
                id: archCol
                anchors.centerIn: parent
                width: parent.width - Theme.Theme.spacingXLarge
                spacing: Theme.Theme.spacingSmall

                Text {
                    text: "Proof of Concept"
                    font.pixelSize: Theme.Theme.fontSizeSmall
                    font.weight: Theme.Theme.fontWeightSemiBold
                    color: Theme.Theme.accent
                }

                Text {
                    Layout.fillWidth: true
                    text: "This prototype proves QGIS core can drive a modern QML interface. " +
                          "The map canvas uses the same QPainter rendering engine — " +
                          "zero Qt Widgets dependencies."
                    font.pixelSize: Theme.Theme.fontSizeSmall
                    color: Theme.Theme.textDim
                    wrapMode: Text.WordWrap
                    lineHeight: 1.5
                }
            }
        }
    }
}
