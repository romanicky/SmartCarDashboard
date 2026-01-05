import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: mapCard
    color: Theme.colors.card
    radius: 15

    // Placeholder map content — replace with MapItem or WebEngine as needed
    Text {
        anchors.centerIn: parent
        text: "Map View"
        color: Theme.colors.textSecondary
    }
}
