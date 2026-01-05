import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

RowLayout {
    id: topBar
    Layout.fillWidth: true
    spacing: 8

    Text {
        text: "09:42"
        color: Theme.colors.textMain
        font.pixelSize: 20
    }

    Item {
        Layout.fillWidth: true
    }

    Text {
        text: "4G 🔋 Octavia Phone"
        color: Theme.colors.textMain
    }
}
