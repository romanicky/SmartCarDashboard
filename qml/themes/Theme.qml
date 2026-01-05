pragma Singleton
import QtQuick 2.15

Item {
    property bool isDark: true

    readonly property QtObject light: LightTheme {}
    readonly property QtObject dark: DarkTheme {}

    readonly property QtObject colors: isDark ? dark : light

    function toggle() {
        isDark = !isDark
    }
}
