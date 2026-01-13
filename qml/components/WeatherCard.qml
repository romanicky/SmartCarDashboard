import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: weatherCard
    color: Theme.colors.accent
    border.color: Theme.colors.cardBorder
    radius: 15
    property int currentHour: new Date().getHours()
    property string weatherCondition:"Clear"
    property double presentTemp: 25

    function iconweatherChanged(weatherCondition , currentHour){
        if(weatherCondition === "Rain"){
            return "../../asset/wea/rainicon.png"
        }
        if(weatherCondition  === "Cloudy"){
            return "../../asset/wea/cloudy.png"
        }
        if(weatherCondition === "Clear"){
            if(currentHour >= 6 && currentHour <=18){
                return "../../asset/wea/sun.png"
            }else{
                return "../../asset/wea/moon.png"
            }
        }
    }

    function weatherChanged(weatherCondition, currentHour){
        if(weatherCondition === "Rain"){
            return "../../asset/wea/rain.png"
        }
        if(weatherCondition === "Cloudy"){
            return ".../../asset/wea/cloud.png"
        }
        if(currentHour >= 6 && currentHour < 8){
            return "../../asset/wea/6h_8h.png"
        }
        if(currentHour >= 8 && currentHour < 15){
            return "../../asset/wea/15h_18h.png"
        }
        if(currentHour >= 15 && currentHour < 18){
            return "../../asset/wea/15h_18h.png"
        } else{
            return "../../asset/wea/18h_6h.png"
        }
    }
    function fu_1h_wea_background(currentHour){
        if(currentHour >=6 && currentHour < 18 ){
            return "#FFFFFF"
        } else {
            return "#1C1F26"
        }
    }
    function textcolor(currentHour){
        if(currentHour >=6 &&currentHour < 18){
            return"#1C1F26"
        }else{
            return"#FFFFFF"
        }
    }

    Timer{
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            currentHour = new Date().getHours();
        }
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
                    onSourceChanged: fadeAnim.restart()


                    Behavior on source{
                        SequentialAnimation{
                            NumberAnimation {target: backgroundWeather;property: "opacity"; to:0.5;duration: 300}
                            PropertyAction  {target: backgroundImage; property: "source" }
                            NumberAnimation {target: backgroundImage; property: "opacity"; to: 1.0; duration: 300 }
                            }
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
                                source: weatherCard.iconweatherChanged(weatherCondition,currentHour)
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
