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
    property string weatherCondition:"Storm"
    property double presentTemp: 25

    function iconfutureCondition(hour){
        let diff = (hour - currentHour + 24) % 24;
        if(weatherCondition === "Storm" || weatherCondition === "ThunderStorm"){
            if(diff === 1) return "Rain_Heavy";
            if(diff === 2) return "Rain_Light";
        }
        return "Clear";
    }

    function iconweatherChanged(weatherCondition , currentHour){
        let path = "../../asset/wea/";
        // special weather
        if(weatherCondition === "Rain_Light")
            return path + "rainlighticon.svg";
        if(weatherCondition === "Rain_Heavy")
            return path + "rainheavyicon.svg";
        if(weatherCondition === "Storm")
            return path + "stormicon.svg";
        if(weatherCondition === "ThunderStorm")
            return path + "thunderstorm.svg";
        if (weatherCondition === "Cloudy")
            return path + "cloudyicon.svg";
        //morning
        if(currentHour >= 5 && currentHour < 7)
            return path + "suongmuicon.svg"
        if(currentHour >= 7 && currentHour < 9)
            return path + "sunnycloudicon.svg";
        if(currentHour >= 9 && currentHour < 15)
            return path + "sunny.svg";
        if(currentHour >= 15 && currentHour < 18)
            return path + "sunnycloudicon.svg";
        //night
        if(currentHour >= 18 && currentHour < 21)
            return path + "nightcloudicon.svg";
        if(currentHour >= 21 && currentHour < 23)
            return path + "nightclearicon.svg";
        return path + "moonlighticon.svg";
    }

    function iconweatherChanged(weatherCondition, currentHour) {
        if (weatherCondition === "Rain") {
            return "../../asset/icons/rainny.svg";
        }
        if (weatherCondition === "Cloudy") {
            return "../../asset/icons/cloudy.svg";
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

    function fu_1h_wea_background(currentHour){
        return (currentHour >=6 && currentHour < 18 ) ? "#FFFFFF" : "#1C1F26"
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

                Emitter{
                    id: startRainMode
                    width: parent.width +600
                    x: -300
                    height: 10
                    anchors.top: parent.top

                    emitRate: (weatherCondition === "ThunderStorm") ? 250:
                              (weatherCondition === "Storm") ? 200 :
                              (weatherCondition ==="Rain_Heavy") ? 150 : 50

                    lifeSpan: 2000

                    velocity: AngleDirection{
                        // case Storm: raindrops fall 70degree else raindrops fall 90degree
                        angle: (weatherCondition === "ThunderStorm") ? 50:
                               (weatherCondition === "Storm") ? 70 : 90
                        angleVariation: 5

                        //fall speed
                        magnitude: (weatherCondition === "ThunderStorm") ? 200:
                                    (weatherCondition === "Storm") ? 150 : 100
                        magnitudeVariation: 100
                    }
                }
                //WindMode On in case Storm
                Wander{
                    anchors.fill: parent
                    enabled: weatherCondition === "Storm" || weatherCondition ==="ThunderStorm"
                    xVariance: 150
                    pace: 100
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

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                text: futurehour + "h"
                                font.bold: true
                                color: weatherCard.textcolor(currentHour)
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Image{
                                source: weatherCard.iconweatherChanged(weatherCard.iconfutureCondition(futurehour),futurehour)
                                Layout.preferredWidth: 45
                                Layout.preferredHeight: 45
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "25℃"
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
