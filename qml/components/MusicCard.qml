import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../themes"
import Musicplayer 1.0

Rectangle {
    id: musicCard
    width: 1200
    height: 100
    radius: 15
    color: Theme.colors.card

    // Bind to backend properties
    property var player: null  // Will be set from parent

    property url coverSource: player ? player.coverSource : "qrc:/qt/qml/SmartCarDashboard/asset/images/album_cover.png"
    property string title: player ? player.title : "No Track"
    property string artist: player ? player.artist : "Unknown"
    property string album: player ? player.album : "Unknown"
    property bool playing: player ? player.playing : false
    property int position: player ? player.position : 0
    property int duration: player ? player.duration : 0

    property color expandMenuColor: Theme.colors.textMain
    property int iconSize: 20

    signal search
    signal collapse

    function formatTime(seconds) {
        var s = Math.max(0, Math.floor(seconds));
        var m = Math.floor(s / 60);
        var r = s % 60;
        return (m < 10 ? "" + m : m) + ":" + (r < 10 ? "0" + r : r);
    }

    MusicPlayer {
        id:musicPlayer
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
                fillMode: Image.PreserveAspectCrop
                smooth: true
                anchors.fill: parent
                source: musicPlayer.coverSource
            }
        }

        // Track info + progress
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: musicPlayer.musicTitle
                color: Theme.colors.textMain
                font.pixelSize: 26
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: musicPlayer.singerName
                color: Theme.colors.textMain
                font.pixelSize: 18
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: musicPlayer.album
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: "-" + formatTime(musicPlayer.duration - musicPlayer.position)
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }

            Slider {
                id: progressSlider
                from: 0
                to: Math.max(1, musicPlayer.duration)
                value: musicPlayer.position
                Layout.fillWidth: true

                onMoved: {
                    if (player)
                        player.seek(value)
                }
            }
        }

        // Transport controls
        RowLayout {
            spacing: 28
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            ToolButton {
                icon.source: "../../asset/icons/prev.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: if (player) player.previous()
            }

            ToolButton {
                icon.source: musicPlayer.playing ? "../../asset/icons/pause.svg" : "../../asset/icons/play.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: {
                    if (!player) return;
                    if (musicPlayer.playing)
                        player.pause();
                    else
                        player.play();
                }
            }

            ToolButton {
                icon.source: "../../asset/icons/next.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: if (player) player.next()
            }
        }

        // Right-side tools
        RowLayout {
            spacing: 24
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            ToolButton {
                icon.source: "../../asset/icons/search.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicPlayer.search()
            }

            ToolButton {
                icon.source: "../../asset/icons/expand_music.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                onClicked: musicPlayer.collapse()
            }
        }
    }
}
