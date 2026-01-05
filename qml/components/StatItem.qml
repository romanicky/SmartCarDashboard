import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../themes"

Column {
    id: root
    property string value: ""
    property string unit: ""
    property string label: ""
    Layout.fillWidth: true

    Row {
        spacing: 4
        Text {
            text: root.value
            color: Theme.colors.textMain
            font.pixelSize: 22
            font.bold: true
        }
        Text {
            text: root.unit
            color: Theme.colors.textSecondary
            font.pixelSize: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
        }
    }
    Text {
        text: root.label
        color: Theme.colors.textSecondary
        font.pixelSize: 11
    }
}
