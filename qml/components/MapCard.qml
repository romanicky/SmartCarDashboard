import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtLocation
import QtPositioning
import "../themes"

Rectangle {
    id: mapCard
    color: Theme.colors.card
    border.color: Theme.colors.cardBorder
    border.width: 1
    radius: 15
    clip: true

    // Map properties - configure as needed
    property double latitude: 10.8231    // Ho Chi Minh City
    property double longitude: 106.6297
    property int zoomLevel: 14
    property string mapPluginName: "osm"   // use OSM plugin to avoid HERE dependency

    Plugin {
        id: mapPlugin
        name: mapCard.mapPluginName
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(mapCard.latitude, mapCard.longitude)
        zoomLevel: mapCard.zoomLevel
        copyrightsVisible: false

        // Enable pan and zoom gestures
        PinchHandler {
            target: null
            onActiveChanged: if (active)
                map.zoomLevel = Math.max(map.minimumZoomLevel, Math.min(map.maximumZoomLevel, map.zoomLevel + centroid.scale - 1))
        }

        DragHandler {
            target: null
            onTranslationChanged: map.pan(-translation.x, -translation.y)
        }

        // Ensure a map type is selected when available
        Component.onCompleted: {
            if (supportedMapTypes.length > 0)
                activeMapType = supportedMapTypes[0];
        }

        // Optional: Add a marker at center
        MapQuickItem {
            coordinate: map.center
            anchorPoint.x: marker.width / 2
            anchorPoint.y: marker.height

            sourceItem: Rectangle {
                id: marker
                width: 12
                height: 12
                radius: 6
                color: Theme.colors.accent
                border.color: "white"
                border.width: 2
            }
        }
    }

    // Fallback warning when no API key is set
    Rectangle {
        anchors.fill: parent
        color: "#66000000"
        visible: map.status === Map.Error
        Text {
            anchors.centerIn: parent
            text: map.errorString || "Map unavailable"
            color: "white"
            font.pixelSize: 16
        }
    }

    // Zoom controls overlay
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        spacing: 8

        RoundButton {
            text: "+"
            width: 36
            height: 36
            onClicked: map.zoomLevel = Math.min(map.maximumZoomLevel, map.zoomLevel + 1)
        }

        RoundButton {
            text: "−"
            width: 36
            height: 36
            onClicked: map.zoomLevel = Math.max(map.minimumZoomLevel, map.zoomLevel - 1)
        }
    }
}
