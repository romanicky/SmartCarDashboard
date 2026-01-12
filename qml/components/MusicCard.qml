import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtMultimedia
import MusicPlayerlib 1.0
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

    // Playlist
    property int currentIndex: 0
    readonly property var currentTrack: playlist.count > 0 ? playlist.get(currentIndex) : null

    // Allow changing expand menu icon color externally
    property color expandMenuColor: Theme.colors.textMain
    property int iconSize: 20

    signal play
    signal pause
    signal next
    signal previous
    signal search
    signal collapse

    MusicPlayer {
        id: musicPlayer
    }

    // ListModel {
    //     id: playlist
    //     ListElement {
    //         title: "Luon Yeu Doi"
    //         artist: "Den"
    //         album: "Singles"
    //         source: "qrc:/asset/musics/LuonYeuDoi-Den-8692742.mp3"
    //     }
    //     ListElement {
    //         title: "Muon Ngan Giac Mo"
    //         artist: "Kha"
    //         album: "Singles"
    //         source: "qrc:/asset/musics/MuonNganGiacMo-Kha-35861436.mp3"
    //     }
    //     ListElement {
    //         title: "Thuc Giac"
    //         artist: "Da LAB"
    //         album: "Singles"
    //         source: "qrc:/asset/musics/ThucGiac-DaLAB-7048212.mp3"
    //     }
    //     ListElement {
    //         title: "Tung Ngay Yeu Em (Acoustic)"
    //         artist: "Bui Truong Linh"
    //         album: "Acoustic"
    //         source: "qrc:/asset/musics/TungNgayYeuEmAcoustic-buitruonglinh-16952808.mp3"
    //     }
    //     ListElement {
    //         title: "Instrumental"
    //         artist: "Unknown"
    //         album: "Sample"
    //         source: "qrc:/asset/musics/przwye8p0e.mp3"
    //     }
    // }

    MediaPlayer {
        // id: musicPlayer
        audioOutput: AudioOutput {
            id: audioOutput
        }
        source: musicCard.currentTrack ? musicCard.currentTrack.source : ""

        onPlaybackStateChanged: musicCard.playing = (playbackState === MediaPlayer.PlayingState)
        onPositionChanged: musicCard.position = Math.floor(position / 1000)
        onDurationChanged: musicCard.duration = Math.max(1, Math.floor(duration / 1000))
    }

    function playCurrent() {
        if (playlist.count === 0)
            return;
        musicPlayer.source = musicCard.currentTrack.source;
        musicPlayer.play();
    }

    function playPause() {
        if (playlist.count === 0)
            return;
        if (musicPlayer.source === "")
            musicPlayer.source = musicCard.currentTrack.source;

        if (musicPlayer.playbackState === MediaPlayer.PlayingState)
            musicPlayer.pause();
        else
            musicPlayer.play();
    }

    function playNextTrack() {
        if (playlist.count === 0)
            return;
        musicCard.currentIndex = (musicCard.currentIndex + 1) % playlist.count;
        musicCard.position = 0;
        playCurrent();
    }

    function playPreviousTrack() {
        if (playlist.count === 0)
            return;
        musicCard.currentIndex = (musicCard.currentIndex - 1 + playlist.count) % playlist.count;
        musicCard.position = 0;
        playCurrent();
    }

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
                source: musicPlayer.thumbailSource || musicCard.coverSource
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
                    text: musicPlayer.albumTitle || musicCard.album
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // Remaining time (negative like in screenshot)
                Text {
                    text: "-" + formatTime(musicPlayer.duration / 1000 - musicPlayer.position / 1000)
                    color: Theme.colors.textSecondary
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }

            ProgressBar {
                id: progress
                from: 0
                to: Math.max(1, musicPlayer.duration / 1000)
                value: Math.min(musicPlayer.duration / 1000, Math.max(0, musicPlayer.position / 1000))
                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var newPosition = (mouse.x / width) * musicPlayer.duration;
                        musicPlayer.seek(newPosition);
                    }
                }
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
                background: Rectangle {
                    color: Theme.colors.buttonBackground
                    radius: 6
                }
                onClicked: musicPlayer.previousTrack()
            }

            ToolButton {
                id: playMusic
                icon.source: musicPlayer.isPlaying ? "../../asset/icons/pause.svg" : "../../asset/icons/play.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                background: Rectangle {
                    color: Theme.colors.buttonBackground
                    radius: 6
                }
                onClicked: {
                    // musicCard.playPause();
                    musicPlayer.playMusic();
                }
            }

            ToolButton {
                id: nextMusic
                icon.source: "../../asset/icons/next.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                background: Rectangle {
                    color: Theme.colors.buttonBackground
                    radius: 6
                }
                onClicked: musicPlayer.nextTrack()
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
                background: Rectangle {
                    color: Theme.colors.buttonBackground
                    radius: 6
                }
                onClicked: musicCard.search()
            }

            ToolButton {
                id: expandMenu
                icon.source: "../../asset/icons/expand_music.svg"
                icon.color: Theme.colors.textMain
                icon.width: musicCard.iconSize
                icon.height: musicCard.iconSize
                background: Rectangle {
                    color: Theme.colors.buttonBackground
                    radius: 6
                }
                onClicked: musicCard.collapse()
            }
        }
    }
}
