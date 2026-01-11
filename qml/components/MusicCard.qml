import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import MusicPlayerlib 1.0
import RadiusImagelib 1.0
import "../themes"

Rectangle {
    id: musicCard
    color: "#121212"  // Dark background like Spotify
    radius: 0
    implicitHeight: 90

    MusicPlayer {
        id: musicPlayer
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 16
        spacing: 12

        // Left side: Thumbnail with heart icon
        Item {
            Layout.preferredWidth: 74
            Layout.preferredHeight: 74
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: rectThumbnail
                anchors.fill: parent
                color: "transparent"
                radius: 4

                RadiusImage {
                    id: musicThumbnail
                    anchors.fill: parent
                    image: musicPlayer.albumArt
                }
            }

            // Heart/favorite icon overlay
            Rectangle {
                width: 24
                height: 24
                color: "transparent"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 4

                Text {
                    anchors.centerIn: parent
                    text: "♡"
                    color: "white"
                    font.pixelSize: 18
                    opacity: 0.8
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Favorite toggled")
                }
            }
        }

        // Song info (title and artist)
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            Text {
                id: songTitle
                text: musicPlayer.title || "Mia & Sebastian's Theme"
                color: "white"
                font.pixelSize: 14
                font.family: "Arial"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                id: artistName
                text: musicPlayer.artist || "Justin Hurwitz"
                color: "#B3B3B3"
                font.pixelSize: 12
                font.family: "Arial"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Center: Control buttons
        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 16

            Button {
                id: previousButton
                text: "⏮"
                font.pixelSize: 20
                implicitWidth: 32
                implicitHeight: 32

                onClicked: {
                    if (musicPlayer.previous) {
                        musicPlayer.previous()
                    }
                    console.log("Previous")
                }

                background: Rectangle {
                    color: "transparent"
                    radius: 16
                }

                contentItem: Text {
                    text: previousButton.text
                    font: previousButton.font
                    color: previousButton.hovered ? "white" : "#B3B3B3"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: previousButton.clicked()
                }
            }

            Button {
                id: playButton
                text: musicPlayer.isPlaying ? "⏸" : "▶"
                font.pixelSize: 16
                implicitWidth: 32
                implicitHeight: 32

                onClicked: {
                    if (musicPlayer.togglePlayPause) {
                        musicPlayer.togglePlayPause()
                    }
                    console.log("Play/Pause")
                }

                background: Rectangle {
                    color: playButton.hovered ? "white" : "#B3B3B3"
                    radius: 16
                }

                contentItem: Text {
                    text: playButton.text
                    font: playButton.font
                    color: "#121212"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: playButton.clicked()
                }
                onButtonClicked {

                }
            }

            Button {
                id: nextButton
                text: "⏭"
                font.pixelSize: 20
                implicitWidth: 32
                implicitHeight: 32

                onClicked: {
                    if (musicPlayer.next) {
                        musicPlayer.next()
                    }
                    console.log("Next")
                }

                background: Rectangle {
                    color: "transparent"
                    radius: 16
                }

                contentItem: Text {
                    text: nextButton.text
                    font: nextButton.font
                    color: nextButton.hovered ? "white" : "#B3B3B3"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: nextButton.clicked()
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Right side: Additional controls (search, queue, etc)
        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Button {
                id: searchButton
                text: "🔍"
                font.pixelSize: 18
                implicitWidth: 32
                implicitHeight: 32

                background: Rectangle {
                    color: "transparent"
                }

                contentItem: Text {
                    text: searchButton.text
                    font: searchButton.font
                    color: searchButton.hovered ? "white" : "#B3B3B3"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Search")
                }
            }

            Button {
                id: queueButton
                text: "≡"
                font.pixelSize: 20
                implicitWidth: 32
                implicitHeight: 32

                background: Rectangle {
                    color: "transparent"
                }

                contentItem: Text {
                    text: queueButton.text
                    font: queueButton.font
                    color: queueButton.hovered ? "white" : "#B3B3B3"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Queue")
                }
            }
        }
    }

    // Progress bar at the bottom
    Rectangle {
        id: progressBarBackground
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 4
        color: "#404040"

        Rectangle {
            id: progressBarFill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * (musicPlayer.position / musicPlayer.duration || 0)
            color: "#1DB954"

            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 12
                height: 12
                radius: 6
                color: "white"
                visible: progressBarMouseArea.containsMouse
            }
        }

        MouseArea {
            id: progressBarMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                var newPosition = (mouse.x / width) * musicPlayer.duration
                if (musicPlayer.seek) {
                    musicPlayer.seek(newPosition)
                }
            }
        }
    }
}
