import QtQuick
import QtQuick.Controls

Item {
    property string buttonColor :"lightgray"
    property real btnRadius: 0
    property string iconsource :""
    property string btnText :""
    property bool btnEnabled : false
    signal btnclicked ()

    Rectangle {
        id: btnBackground
        anchors.fill: parent
        color: btnEnabled ? buttonColor : "gray"
        radius: btnRadius

        Image {
            id:btnIcon
            anchors.fill: parent
            source: iconSource
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            opacity: btnEnabled ? 1.0 : 0.5
        }

        Text {
            id: btnLabel
            anchors.left: btnIcon.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: btnText
        }

        MouseArea {
            anchors.fill: parent
            enabled: btnEnabled
            onClicked: {
                btnclicked()
            }
        }
    }
}
