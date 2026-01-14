import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../themes"

DashboardCard {
    id: root
    implicitWidth: 480
    implicitHeight: 600

    property color batteryColor: CarInfo.capacity >= 80 ? "#25CB55" : (CarInfo.capacity >= 56 ? "#FFA500" : (CarInfo.capacity >= 30 ? "#FFFF00" : "#FF0000"))

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        // 1. Image & Model Name
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            Image {
                source: CarInfo.imageSource
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: CarInfo.vehicleName
                color: Theme.colors.textSecondary
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 2. Battery Progress Bar
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

        // 3. Stats Row (Range, Average, Capacity)
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Reusable Stat Component
            StatItem {
                value: Math.round(CarInfo.capacity * 5)
                unit: "km"
                label: "Remaining"
            }

            StatItem {
                value: String(CarInfo.capacity)
                unit: "%"
                label: "Full Capacity"
            }
        }

        // 4. Speed & Status Section
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            spacing: 15

            // Speed Display
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.colors.card
                radius: 20
                border.color: Theme.colors.textSecondary
                Column {
                    id: speedColumn
                    anchors.centerIn: parent
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
                        font.pixelSize: 48
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: "km/h"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Status Icons (Giả lập các icon cảnh báo)
            GridLayout {
                columns: 3
                Layout.fillWidth: true
                // Bạn có thể thêm các Icon SVG ở đây
            }
        }

        // 5. Gear Selector (N D R P)
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
