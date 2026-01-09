pragma Singleton

import QtQuick
import QtMultimedia

QtObject {
    id: soundManager

    // ===== Global settings =====
    property bool enabled: true
    property real volume: 0.4

    // ===== UI Sounds =====
    SoundEffect {
        id: clickSound
        source: "qrc:/asset/sounds/beep.mp3"
        volume: soundManager.volume
    }

    // ===== Public APIs =====
    function playClick() {
        if (enabled)
            clickSound.play();
    }
}
