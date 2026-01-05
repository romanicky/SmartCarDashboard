import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../themes"

Rectangle {
    id: root
    property string text: ""
    property bool isActive: false

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 25
    color: isActive ? Theme.colors.accent : "transparent"

    Text {
        anchors.centerIn: parent
        text: root.text
        color: isActive ? "white" : Theme.colors.textSecondary
        font.pixelSize: 18
        font.bold: isActive
    }
}
