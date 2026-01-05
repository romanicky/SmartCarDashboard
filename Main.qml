import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
// import "Theme" 1.0

Window {
    width: 1280; height: 720
    color: "#121216"
    visible: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        // --- 1. TOP BAR ---
        RowLayout {
            Layout.fillWidth: true
            Text { text: "09:42"; color: "white"; font.pixelSize: 20 }
            Item { Layout.fillWidth: true } // Spacer
            Text { text: "4G 🔋 Octavia Phone"; color: "white" }
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
                color: "#1c1c24"; radius: 15
                // Nội dung: Image xe, Speed text...
            }

            // Thẻ Bản đồ (Chiếm cột giữa, hàng trên)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#1c1c24"; radius: 15
                clip: true
                Text { anchors.centerIn: parent; text: "Map View"; color: "gray" }
            }

            // Thẻ Thời tiết (Cột phải, hàng trên)
            Rectangle {
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                color: "#5eb1f3"; radius: 15 // Màu xanh thời tiết
            }

            // Thẻ Âm nhạc (Cột giữa + phải, hàng dưới)
            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                color: "#1c1c24"; radius: 15
            }
        }

        // --- 3. BOTTOM NAV ---
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 30
            // Thêm các biểu tượng Home, Map, Car, Settings ở đây
            Repeater {
                model: ["Home", "Nav", "Car", "Menu"]
                Button { text: modelData; implicitWidth: 60 }
            }
        }
    }

    Component.onCompleted: {
        // console.log("Theme:", Theme.current);
    }
}
