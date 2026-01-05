import QtQuick 2.15
import "." // Import thư mục chứa Theme

Rectangle {
    width: 200; height: 150
    radius: 15

    // Tự động cập nhật khi Theme.isDark thay đổi
    color: Theme.colors.card

    border.color: Theme.isDark ? "#2a2d35" : "#E0E0E0"

    Text {
        anchors.centerIn: parent
        text: "Speed: 84 km/h"
        color: Theme.colors.textMain
    }
}
