import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"

Rectangle {
    id: musicCard
    width: 1200
    height: 100
    radius: 15
    color: Theme.colors.card

    property url coverSource: "qrc:/qt/qml/SmartCarDashboard/asset/images/album_cover.png"
    property string title: "Mia & Sebastian's Theme"
    property string artist: "Justin Hurwitz"
    property string album: "La La Land (Original Motion Pi...)"

    property bool playing: false
    property int position: 0        // seconds
    property int duration: 123      // seconds

    // Allow changing expand menu icon color externally
    property color expandMenuColor: Theme.colors.textMain
    property int iconSize: 20

    signal play
    signal pause
    signal next
    signal previous
    signal search
    signal collapse

    function formatTime(seconds) {
        var s = Math.max(0, Math.floor(seconds));
        var m = Math.floor(s / 60);
        var r = s % 60;
        return (m < 10 ? "" + m : m) + ":" + (r < 10 ? "0" + r : r);
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 24

        // Cover art
        Rectangle {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            radius: 8
            clip: true
            color: "transparent"

            Image {
                id: cover
                clip: true
                fillMode: Image.Stretch
                smooth: true
                anchors.fill: parent
                source: "../../asset/images/album_cover.png"
            }
        }

        // Track info + progress
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: musicCard.title
                color: Theme.colors.textMain
                font.pixelSize: 26
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: musicCard.artist
                color: Theme.colors.textMain
                font.pixelSize: 18
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: musicCard.album
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // Remaining time (negative like in screenshot)
                Text {
                    text: "-" + formatTime(musicCard.duration - musicCard.position)
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }

            ProgressBar {
                id: progress
                from: 0
                to: Math.max(1, musicCard.duration)
                value: Math.min(musicCard.duration, Math.max(0, musicCard.position))
                Layout.fillWidth: true
            }
        }

        // Transport controls centered
        RowLayout {
            spacing: 28
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ToolButton {
                id: prevMusic
                icon.source: "../../asset/icons/prev.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicCard.previous()
            }

            ToolButton {
                id: playMusic
                icon.source: musicCard.playing ? "../../asset/icons/pause.svg" : "../../asset/icons/play.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize

                onClicked: {
                    if (musicCard.playing)
                        musicCard.pause();
                    else
                        musicCard.play();
                    musicCard.playing = !musicCard.playing;
                }
            }


            ToolButton {
                id: nextMusic
                icon.source: "../../asset/icons/next.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicCard.next
            }
        }

        // Right-side tools
        RowLayout {
            spacing: 24
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            ToolButton {
                id: searchMusic
                icon.source: "../../asset/icons/search.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicCard.search()
            }

            ToolButton {
                id: expandMenu
                icon.source: "../../asset/icons/expand_music.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicCard.collapse()
            }
        }
    }
}
