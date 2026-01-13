import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Particles 2.15
import "../themes"

Rectangle {
    id: weatherCard
    color: Theme.colors.accent
    border.color: Theme.colors.cardBorder
    radius: 15
    property int currentHour: new Date().getHours()
    property string weatherCondition:"ThunderStorm"
    property double presentTemp: 25



    function iconweatherChanged(weatherCondition , currentHour){
        let path = "../../asset/wea/";
        if(weatherCondition === "Rain_Light")
            return path + "rainlighticon.svg";
        if(weatherCondition === "Rain_Heavy")
            return path + "rainheavyicon.svg";
        if(weatherCondition === "Storm")
            return path + "stormicon.svg";
        if(weatherCondition === "ThunderStorm")
            return path + "thunderstorm.svg";

        if(currentHour >=6 && currentHour <8)
            return path + "suongmuicon.svg";
        if(currentHour >=8 && currentHour < 15)
            return path + "sunny.svg";
        if(currentHour >=15 && currentHour <18)
            return path + "sunnycloudicon.svg";

        if(currentHour >= 23 || currentHour <5)
            return path + "moonlighticon.svg";
        if(currentHour >= 21)
            return path + "nightclearicon.svg";
        if(currentHour >=18 )
            return path + "nightcloudicon.svg";
        return path + "suongmuicon.svg";
        if (weatherCondition === "Cloudy")
            return path + "cloudyicon.svg";
    }

    function weatherChanged(weatherCondition, currentHour){
        let path = "../../asset/wea/";
        switch(weatherCondition){
        case "Rain":
        case "Rain_Light":
        case "Rain_Heavy":
        case "Storm":
        case "ThunderStorm":
            return path + "rainmode.svg"
        case "Cloudy":
        case "Foggy":
            return path + "cloudy.svg"
        }

        if(currentHour >= 6 && currentHour < 8)
            return path + "6-8h.svg";
        if(currentHour >= 8 && currentHour < 15)
            return path + "8h-15h.svg";
        if(currentHour >= 15 && currentHour < 18)
            return path + "15h-18hv2.svg";
        if(currentHour >= 18 || currentHour <6)
            return path + "18h-6h.svg";

    }
    function fu_1h_wea_background(currentHour){
        return (currentHour >=6 && currentHour < 18 ) ? "#FFFFFF" : "#1C1F26"
    }
    function textcolor(currentHour){
        return (currentHour >=6 &&currentHour < 18) ? "#1C1F26" : "#FFFFFF"
    }

    Timer{
        interval: 60000; running: true; repeat: true
        onTriggered: parent.currentHour = new Date().getHours();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // PresentWeather
        Rectangle {
            id: presentweather
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * (2/3)
            clip: true

            //Ảnh giao diện weather
            Image {
                id: backgroundWeather
                source: weatherCard.weatherChanged(weatherCondition,currentHour)
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop

                NumberAnimation{
                    id:fadeAnim
                    target:backgroundWeather
                    property: "opacity"
                    from: 0.2
                    to: 1.0
                    duration: 500
                }

                onSourceChanged: fadeAnim.restart()


                Behavior on source{
                    SequentialAnimation{
                        NumberAnimation {target: backgroundWeather;property: "opacity"; to:0.5;duration: 300}
                        PropertyAction  {target: backgroundWeather; property: "source" }
                        NumberAnimation {target: backgroundWeather; property: "opacity"; to: 1.0; duration: 300 }
                    }
                }
            }

            //ThunderStorm mode
            Rectangle{
                id: lightningFlash
                anchors.fill: parent
                color: "#FFFFFF"
                opacity: 0
                visible: weatherCondition === "ThunderStorm" || weatherCondition === "Storm"
                SequentialAnimation on opacity{
                    id: lightningAnim
                    loops: Animation.Infinite
                    running: weatherCondition === "ThunderStorm" || weatherCondition === "Storm"

                    //Lightning firsttime
                    NumberAnimation{ to: 0.6; duration: 50}
                    NumberAnimation{ to: 0; duration: 100}
                    //Lightning Secondtime faster
                    NumberAnimation{ to: 0.4; duration: 30}
                    NumberAnimation{ to: 0; duration: 80}

                    //Relax 2-5s and BUMP
                    PauseAnimation{duration: Math.random() *3000 + 2000}
                }
            }

            //RainMode
            ParticleSystem{
                id: rainMode
                anchors.fill: parent
                running: weatherCondition.indexOf("Rain") !== -1 ||
                         weatherCondition === "Storm"||
                         weatherCondition ==="ThunderStorm"

                ImageParticle{
                    source: "../../asset/wea/hatmuaicon.svg"
                    alpha: 0.5
                    color:"#E0E0E0"
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
                        magnitude: (weatherCondition === "ThunderStorm") ? 800:
                                    (weatherCondition === "Storm") ? 650 : 500
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
                    text: presentTemp.toFixed(1) +"℃"
                    font.pixelSize: 20
                    font.bold: true
                    color: weatherCard.textcolor(currentHour)
                    style: Text.Outline
                    styleColor: (currentHour >= 6 && currentHour < 18)? "#FFFFFF" : "1C1F26"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }



        // WeaFuture
        Rectangle {
            id: future1hweather
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * (1/3)
            color: weatherCard.fu_1h_wea_background(currentHour)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing:0


                Repeater {
                    model: 4
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        property int futurehour: (currentHour + index + 1)%24
                        property string futureStatus: "Clear"

                        ColumnLayout{
                            anchors.centerIn: parent
                            spacing: 10
                            Text{
                                text: futurehour + "h"
                                font.bold: true
                                color: weatherCard.textcolor(currentHour)
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Image{
                                source: weatherCard.iconweatherChanged(weatherCondition,futurehour)
                                Layout.preferredWidth: 45
                                Layout.preferredHeight: 45
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text{
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
