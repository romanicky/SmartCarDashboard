import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

RowLayout {
    id: bottomBar
    Layout.alignment: Qt.AlignHCenter
    spacing: 30

    Repeater {
        model: ["Home", "Nav", "Theme", "Menu"]
        Button {
            text: modelData
            implicitWidth: 60
            onClicked: {
                if (modelData === "Theme") {
                    Theme.toggle();
                }
            }
        }
    }
}
