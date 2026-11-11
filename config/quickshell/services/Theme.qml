pragma Singleton
import QtQuick
import Quickshell

// Catppuccin Mocha, same palette as the waybar config.
Singleton {
    readonly property color rosewater: "#f5e0dc"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color text: "#cdd6f4"
    readonly property color subtext0: "#a6adc8"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay0: "#6c7086"
    readonly property color surface1: "#45475a"
    readonly property color surface0: "#313244"
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"

    readonly property string font: "Iosevka Nerd Font"
    readonly property int fontSize: 16
    readonly property int smallSize: 14
    readonly property int barHeight: 32

    // Nerd Font glyphs live above the BMP, so build them from code points.
    function glyph(cp) {
        return String.fromCodePoint(cp);
    }

    function bytes(b) {
        if (b < 1024)
            return b.toFixed(0) + " B";
        if (b < 1048576)
            return (b / 1024).toFixed(1) + " KB";
        if (b < 1073741824)
            return (b / 1048576).toFixed(1) + " MB";
        return (b / 1073741824).toFixed(1) + " GB";
    }
}
