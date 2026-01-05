import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: carInfo
    color: Theme.colors.card
    radius: 15

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        RowLayout {
            spacing: 12
            // Placeholder image box
            Rectangle {
                width: 80
                height: 60
                radius: 8
                color: Theme.colors.background
            }

            ColumnLayout {
                spacing: 4
                Text {
                    text: "Octavia"
                    color: Theme.colors.textMain
                    font.pixelSize: 18
                }
                Text {
                    text: "VIN: XXXX-YYYY"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 12
                }
            }
        }

        // Speed / status area
        RowLayout {
            anchors.margins: 4
            spacing: 16
            Text {
                text: "Speed"
                color: Theme.colors.textSecondary
            }
            Text {
                text: "0 km/h"
                color: Theme.colors.textMain
                font.pixelSize: 28
            }
        }
    }
}
