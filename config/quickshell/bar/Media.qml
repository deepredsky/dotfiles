import QtQuick
import Quickshell.Services.Mpris
import qs.components
import qs.services

// Current track; click toggles play/pause, scroll skips.
BarButton {
    id: root

    readonly property var player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null

    visible: player !== null && player.trackTitle !== ""
    onClicked: player.togglePlaying()
    onWheel: wheel => wheel.angleDelta.y > 0 ? player.previous() : player.next()

    Label {
        text: Theme.glyph(root.player?.isPlaying ? 0xf04b : 0xf04c)
        color: Theme.green
        font.pixelSize: Theme.smallSize
    }

    Label {
        width: Math.min(implicitWidth, 500)
        text: [root.player?.trackArtist, root.player?.trackTitle].filter(s => s).join(" – ")
        color: Theme.subtext0
        elide: Text.ElideRight
    }
}
