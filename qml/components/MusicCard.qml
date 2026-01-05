import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: musicCard
    color: Theme.colors.card
    radius: 15

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12

        Text {
            text: "Music Player"
            color: Theme.colors.textMain
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            text: "▶"
            onClicked: console.log("MusicCard: Play")
        }
    }
}
