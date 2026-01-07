import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: weatherCard
    color: Theme.colors.accent
    border.color: Theme.colors.cardBorder
    radius: 15

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        Text {
            text: "San Francisco"
            color: Theme.colors.textMain
            font.pixelSize: 16
        }

        RowLayout {
            spacing: 8
            Text {
                text: "22°C"
                color: Theme.colors.textMain
                font.pixelSize: 28
            }
            Text {
                text: "☀︎"
                color: Theme.colors.textMain
                font.pixelSize: 28
            }
        }

        Text {
            text: "Sunny"
            color: Theme.colors.textSecondary
        }
    }
}
