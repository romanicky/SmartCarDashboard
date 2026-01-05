import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../themes"

DashboardCard {
    id: root
    implicitWidth: 480
    implicitHeight: 600

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        // 1. Image & Model Name
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5
            Image {
                source: "qrc:/qt/qml/SmartCarDashboard/asset/images/car_left.png" // use PNG once converted and bundled
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "Vinfast"
                color: Theme.colors.textSecondary
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 2. Battery Progress Bar
        Rectangle {
            Layout.fillWidth: true
            height: 8
            color: Theme.colors.card
            radius: 4
            Rectangle {
                width: parent.width * 0.65 // Giả lập 65% pin
                height: parent.height
                color: Theme.colors.accent
                radius: 4
            }
        }

        // 3. Stats Row (Range, Average, Capacity)
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Reusable Stat Component
            StatItem {
                value: "204"
                unit: "km"
                label: "Remaining"
            }
            StatItem {
                value: "128"
                unit: "Wh/km"
                label: "Average"
            }
            StatItem {
                value: "35.5"
                unit: "kWh"
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
                    anchors.centerIn: parent
                    Text {
                        text: "84"
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
                    isActive: true
                }
                GearButton {
                    text: "D"
                } // Active state
                GearButton {
                    text: "R"
                }
                GearButton {
                    text: "P"
                }
            }
        }
    }
}
