import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

DashboardCard {
    id: root
    implicitWidth: 480
    implicitHeight: 600

    property int iconSize: 24
    property color batteryColor: CarInfo.capacity >= 80 ? "#25CB55" : (CarInfo.capacity >= 56 ? "#FFA500" : (CarInfo.capacity >= 30 ? "#FFFF00" : "#FF0000"))

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 10

        // Error icons and light indicators
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            // Example Error Icon
            Image {
                source: "../../asset/icons/tire_pressure.svg"
                visible: true
                width: root.iconSize
                height: root.iconSize
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                fillMode: Image.PreserveAspectFit
            }

            Item {
                Layout.fillWidth: true
            }

            // Example Light Indicator
            Image {
                source: "../../asset/icons/headlights.svg"
                visible: CarInfo.headlightsOn
                width: root.iconSize
                height: root.iconSize
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                fillMode: Image.PreserveAspectFit
            }

            // Add more indicators as needed
        }

        // Speed Status Progress Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 8
            color: "gray"
            radius: 4

            Rectangle {
                width: (CarInfo.speed / 200.0) * parent.width
                height: parent.height
                color: Theme.colors.accent
                radius: 4

                Behavior on width {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // Signal left and right icons
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            spacing: 15

            Image {
                source: "../../asset/icons/left.svg"
                visible: CarInfo.leftSignal
                width: root.iconSize
                height: root.iconSize
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                fillMode: Image.PreserveAspectFit

                SequentialAnimation on opacity {
                    running: CarInfo.leftSignal
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: 1.0
                        to: 0.3
                        duration: 500
                    }
                    NumberAnimation {
                        from: 0.3
                        to: 1.0
                        duration: 500
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Image {
                source: "../../asset/icons/right.svg"
                visible: CarInfo.rightSignal
                width: root.iconSize
                height: root.iconSize
                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize
                fillMode: Image.PreserveAspectFit

                SequentialAnimation on opacity {
                    running: CarInfo.rightSignal
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: 1.0
                        to: 0.3
                        duration: 500
                    }
                    NumberAnimation {
                        from: 0.3
                        to: 1.0
                        duration: 500
                    }
                }
            }
        }

        // Large Speed Display
        Column {
            id: speedColumn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            property int animatedSpeed: CarInfo.speed

            Behavior on animatedSpeed {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            Text {
                text: String(speedColumn.animatedSpeed)
                color: Theme.colors.textMain
                font.pixelSize: 80
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "KM/H"
                color: Theme.colors.textSecondary
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            Image {
                source: CarInfo.headlightsOn ? "../../asset/images/car_light.png" : "../../asset/images/car.png"
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Battery Status
        ColumnLayout {
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 5
                color: "gray"
                radius: 5

                Rectangle {
                    width: CarInfo.capacity / 100 * parent.width
                    height: parent.height
                    color: root.batteryColor
                    radius: 5

                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }

            RowLayout {
                Text {
                    id: rangeText
                    text: Math.round(CarInfo.capacity * 5) + " KM"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 14
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: Math.round(CarInfo.capacity) + "%"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 14
                }
            }
        }

        // Gear Selector
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Theme.colors.card
            radius: 30
            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 0

                GearButton {
                    text: "N"
                    isActive: CarInfo.gear === "N"
                }
                GearButton {
                    text: "D"
                    isActive: CarInfo.gear === "D"
                }
                GearButton {
                    text: "R"
                    isActive: CarInfo.gear === "R"
                }
                GearButton {
                    text: "P"
                    isActive: CarInfo.gear === "P"
                }
            }
        }
    }
}
