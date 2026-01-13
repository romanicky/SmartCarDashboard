import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qml/themes"
import "qml/components"

Window {
    width: 1280
    height: 720
    color: Theme.colors.background
    visible: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 20

        // Top bar
        TopBar {}

        // Main content
        GridLayout {
            columns: 3
            rows: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            columnSpacing: 15
            rowSpacing: 15

            CarInfoCard {
                Layout.rowSpan: 2
                Layout.preferredWidth: 300
                Layout.fillHeight: true
            }

            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: CarInfo.gear === "R" ? cameraComponent : mapComponent

                Component {
                    id: mapComponent
                    MapCard {}
                }

                Component {
                    id: cameraComponent
                    CameraCard {}
                }
            }

            WeatherCard {
                Layout.preferredWidth: 250
                Layout.fillHeight: true
            }

            MusicCard {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 150
            }
        }

        // Bottom bar
        BottomBar {}
    }

    Component.onCompleted: {
        // console.log("Theme isDark:", Theme.isDark);
    }
}
