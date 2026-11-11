import QtQuick
import Quickshell
import Quickshell.Io
import qs.components
import qs.services

// swaync status; click toggles its panel, right click toggles do-not-disturb.
BarButton {
    id: root

    property int count: 0
    property bool dnd: false

    onClicked: mouse => Quickshell.execDetached(["swaync-client", mouse.button === Qt.RightButton ? "-d" : "-t", "-sw"])

    Label {
        text: Theme.glyph(root.dnd ? 0xf1f6 : 0xf0f3)
        color: Theme.overlay0
    }
    Label {
        visible: root.count > 0
        text: root.count
        color: Theme.red
        font.pixelSize: Theme.smallSize
    }

    Process {
        id: watch
        running: true
        command: ["swaync-client", "-swb"]
        stdout: SplitParser {
            onRead: line => {
                try {
                    const s = JSON.parse(line);
                    root.count = Number(s.text) || 0;
                    root.dnd = s.alt.includes("dnd");
                } catch (e) {}
            }
        }
        // swaync may start after us or restart; keep reconnecting.
        onExited: retry.start()
    }

    Timer {
        id: retry
        interval: 2000
        onTriggered: watch.running = true
    }
}
