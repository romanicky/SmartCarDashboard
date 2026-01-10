import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

RowLayout {
    id: topBar
    Layout.fillWidth: true
    spacing: 8

    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: topBar.currentTime = new Date()
    }

    RowLayout {
        spacing: 12

        Text {
            text: Qt.formatDateTime(topBar.currentTime, "MMM dd")
            color: Theme.colors.textSecondary
            font.pixelSize: 18
        }

        Text {
            text: Qt.formatTime(topBar.currentTime, "hh:mm")
            color: Theme.colors.textMain
            font.pixelSize: 20
            font.bold: true
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Text {
        text: "5G 🔋 MobiFone"
        color: Theme.colors.textMain
    }
}
