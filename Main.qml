import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qml/themes"

Window {
    width: 1280
    height: 720
    color: Theme.colors.background
    visible: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        // --- 1. TOP BAR ---
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "09:42"
                color: Theme.colors.textMain
                font.pixelSize: 20
            }
            Item {
                Layout.fillWidth: true
            } // Spacer
            Text {
                text: "4G 🔋 Octavia Phone"
                color: Theme.colors.textMain
            }
        }

        // --- 2. MAIN CONTENT (GRID) ---
        GridLayout {
            columns: 3
            rows: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            columnSpacing: 15
            rowSpacing: 15

            // Thẻ Thông tin xe (Chiếm 2 hàng)
            Rectangle {
                Layout.rowSpan: 2
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                color: Theme.colors.card
                radius: 15
                // Nội dung: Image xe, Speed text...
            }

            // Thẻ Bản đồ (Chiếm cột giữa, hàng trên)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.colors.card
                radius: 15
                clip: true
                Text {
                    anchors.centerIn: parent
                    text: "Map View"
                    color: Theme.colors.textSecondary
                }
            }

            // Thẻ Thời tiết (Cột phải, hàng trên)
            Rectangle {
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                color: Theme.colors.accent
                radius: 15 // Màu xanh thời tiết
            }

            // Thẻ Âm nhạc (Cột giữa + phải, hàng dưới)
            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                color: Theme.colors.card
                radius: 15
            }
        }

        // --- 3. BOTTOM NAV ---
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 30
            // Thêm các biểu tượng Home, Map, Car, Settings ở đây
            Repeater {
                model: ["Home", "Nav", "Car", "Menu"]
                Button {
                    text: modelData
                    implicitWidth: 60
                    onClicked: {
                        if (modelData === "Car") {
                            Theme.toggle();
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // console.log("Theme isDark:", Theme.isDark);
    }
}
