import QtQuick 2.15
import "../themes"

Rectangle {
    implicitWidth: 200
    implicitHeight: 150
    radius: 15

    color: Theme.colors.card

    border.color: Theme.colors.cardBorder
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: ""
        color: Theme.colors.textMain
    }
}
