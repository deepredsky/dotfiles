import QtQuick
import Quickshell.Services.Pipewire
import qs.components
import qs.services

// Scroll to change volume, middle click to mute, click for slider + output devices.
BarButton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && n.audio && !n.isStream)

    function setVolume(v) {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1.5, v));
    }

    function nodeName(n) {
        return n.description || n.nickname || n.name;
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    onWheel: wheel => setVolume(volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    onClicked: mouse => {
        if (mouse.button === Qt.MiddleButton && sink?.audio)
            sink.audio.muted = !muted;
    }

    Label {
        text: root.muted ? Theme.glyph(0xf026) : Theme.glyph(root.volume < 0.34 ? 0xf026 : root.volume < 0.67 ? 0xf027 : 0xf028) + "  " + Math.round(root.volume * 100) + "%"
        color: Theme.blue
    }

    popout: Column {
        width: 340
        spacing: 8

        Heading {
            text: "Sound"
            topPadding: 0
        }

        Row {
            width: parent.width
            spacing: 12

            Label {
                id: muteIcon
                text: Theme.glyph(root.muted ? 0xf026 : 0xf028)
                color: root.muted ? Theme.overlay0 : Theme.blue
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.sink.audio.muted = !root.muted
                }
            }
            Slider {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - muteIcon.width - pct.width - 24
                value: root.volume
                to: 1.5
                accent: root.muted ? Theme.overlay0 : Theme.blue
                onMoved: v => root.setVolume(v)
            }
            Label {
                id: pct
                width: 48
                text: Math.round(root.volume * 100) + "%"
                horizontalAlignment: Text.AlignRight
            }
        }

        Heading {
            text: "Output"
        }

        Repeater {
            model: root.sinks

            MouseArea {
                id: dev

                required property PwNode modelData
                readonly property bool current: modelData === root.sink

                width: parent.width
                height: 28
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Pipewire.preferredDefaultAudioSink = modelData

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: dev.containsMouse ? Theme.surface0 : "transparent"
                }
                Label {
                    anchors.fill: parent
                    leftPadding: 8
                    text: (dev.current ? Theme.glyph(0xf00c) + "  " : "    ") + root.nodeName(dev.modelData)
                    color: dev.current ? Theme.blue : Theme.text
                    font.pixelSize: Theme.smallSize
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                }
            }
        }
    }
}
