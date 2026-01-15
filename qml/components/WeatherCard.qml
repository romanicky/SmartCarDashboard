import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: weatherCard
    color: weatherCard.timeBasedBackgroundColor(currentHour)
    border.color: Theme.colors.cardBorder
    radius: 15
    property int currentHour: new Date().getHours()
    property string weatherCondition: CarInfo.weatherCondition || "Clear"
    property double presentTemp: CarInfo.weatherTemperature || (15 + Math.random() * 20)

    Behavior on color {
        ColorAnimation {
            duration: 800
        }
    }

    function iconweatherChanged(weatherCondition, currentHour) {
        if (weatherCondition === "Rain") {
            return "../../asset/icons/rainny.svg";
        }
        if (weatherCondition === "Cloudy") {
            return "../../asset/icons/cloud.svg";
        }
        if (weatherCondition === "Clear") {
            if (currentHour >= 6 && currentHour <= 18) {
                return "../../asset/icons/sunny.svg";
            } else {
                return "../../asset/icons/moon.svg";
            }
        }
    }

    function weatherChanged(weatherCondition, currentHour) {
        if (weatherCondition === "Rain") {
            return "../../asset/wea/rain.png";
        }
        if (weatherCondition === "Cloudy") {
            return ".../../asset/wea/cloud.png";
        }
        if (currentHour >= 6 && currentHour < 8) {
            return "../../asset/wea/6h_8h.png";
        }
        if (currentHour >= 8 && currentHour < 15) {
            return "../../asset/wea/15h_18h.png";
        }
        if (currentHour >= 15 && currentHour < 18) {
            return "../../asset/wea/15h_18h.png";
        } else {
            return "../../asset/wea/18h_6h.png";
        }
    }
    function fu_1h_wea_background(currentHour) {
        return Theme.colors.card;
    }
    function textcolor(currentHour) {
        return Theme.colors.textMain;
    }

    function timeBasedBackgroundColor(currentHour) {
        // Use theme colors to stay consistent with light/dark modes
        // Daytime uses accent, dusk uses cardBorder, night uses card
        if (currentHour >= 6 && currentHour < 17) {
            return Theme.colors.accent;
        } else if (currentHour >= 17 && currentHour < 20) {
            return Theme.colors.cardBorder;
        } else {
            return Theme.colors.card;
        }
    }

    Timer {
        interval: 1000  // Check every second for faster updates
        running: true
        repeat: true
        onTriggered: {
            var newHour = new Date().getHours();
            if (currentHour !== newHour) {
                currentHour = newHour;
            }
        }
    }

    Timer {
        interval: 5000  // Change weather condition every 5 seconds
        running: true
        repeat: true
        onTriggered: {
            var conditions = ["Clear", "Cloudy", "Rain"];
            weatherCondition = conditions[Math.floor(Math.random() * conditions.length)];
            // Random temperature between 15 and 35 degrees
            presentTemp = 15 + Math.random() * 20;
        }
    }

    Timer {
        id: thunderTimer
        interval: 8000
        running: weatherCondition === "Rain"
        repeat: true
        onTriggered: {
            // Random chance of lightning (40%)
            if (Math.random() < 0.4) {
                lightningOverlay.opacity = 0.6;
                flashTimer.restart();
            }
        }
    }

    Timer {
        id: flashTimer
        interval: 150
        onTriggered: {
            lightningOverlay.opacity = 0;
        }
    }

    Component.onCompleted: {
        currentHour = new Date().getHours();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // PresentWeather
        Rectangle {
            id: presentweather
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * (2 / 3)
            clip: true

            //Ảnh giao diện weather
            Image {
                id: backgroundWeather
                source: weatherCard.weatherChanged(weatherCard.weatherCondition, weatherCard.currentHour)
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: 1.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                    }
                }

                onSourceChanged: {
                    // Fade out and in when source changes
                    opacity = 0.5;
                    opacityTimer.restart();
                }

                Timer {
                    id: opacityTimer
                    interval: 50
                    onTriggered: backgroundWeather.opacity = 1.0
                }
            }

            // Rain particles effect container
            Rectangle {
                id: rainContainer
                anchors.fill: parent
                color: "transparent"
                z: 5

                Repeater {
                    id: rainParticles
                    model: weatherCard.weatherCondition === "Rain" ? 30 : 0
                    delegate: Item {
                        id: raindrop
                        width: 2
                        height: 10
                        x: Math.random() * rainContainer.width
                        y: -10

                        property real randomRotation: Math.random() * 60 - 30  // Random rotation between -30 and 30 degrees

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "#A0D8FF"
                            radius: 1
                            opacity: 0.7
                            anchors.centerIn: parent
                            rotation: parent.randomRotation
                        }

                        NumberAnimation {
                            id: fallAnimation
                            target: raindrop
                            property: "y"
                            from: -10
                            to: rainContainer.height
                            duration: 1000 + Math.random() * 500
                            running: weatherCard.weatherCondition === "Rain"
                            loops: Animation.Infinite

                            onFinished: {
                                raindrop.x = Math.random() * rainContainer.width;
                                raindrop.randomRotation = Math.random() * 60 - 30;
                            }
                        }

                        Component.onCompleted: {
                            fallAnimation.start();
                        }
                    }
                }
            }

            // Lightning overlay effect
            Rectangle {
                id: lightningOverlay
                anchors.fill: parent
                color: "#FFFFFF"
                opacity: 0
                z: 6

                Behavior on opacity {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50
                spacing: 10

                Text {
                    text: presentTemp.toFixed(1) + "℃"
                    font.pixelSize: 20
                    font.bold: true
                    color: weatherCard.textcolor(currentHour)
                    style: Text.Outline
                    styleColor: (currentHour >= 6 && currentHour < 18) ? "#FFFFFF" : "#1C1F26"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // WeaFuture
        Rectangle {
            id: future1hweather
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * (1 / 3)
            color: weatherCard.fu_1h_wea_background(currentHour)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 0

                Repeater {
                    model: 4
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        property int futurehour: (currentHour + index + 1) % 24
                        property string futureStatus: "Clear"
                        property double futureTemp: 15 + Math.random() * 20

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                text: futurehour + "h"
                                font.bold: true
                                color: weatherCard.textcolor(currentHour)
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Image {
                                source: weatherCard.iconweatherChanged(weatherCondition, currentHour)
                                Layout.preferredWidth: 45
                                Layout.preferredHeight: 45
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: futureTemp.toFixed(1) + "℃"
                                color: weatherCard.textcolor(currentHour)
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
