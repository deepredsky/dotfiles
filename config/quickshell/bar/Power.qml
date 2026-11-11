import QtQuick
import Quickshell
import qs.components
import qs.services

// Session menu; log out / restart / shut down need a second click to confirm.
BarButton {
    Label {
        text: Theme.glyph(0xf011)
        color: Theme.overlay0
        rightPadding: 4
    }

    popout: Column {
        id: menu

        property string armed: ""

        width: 200
        spacing: 2

        Repeater {
            model: [
                {
                    "name": "Lock",
                    "icon": 0xf033e,
                    "cmd": ["swaylock"]
                },
                {
                    "name": "Suspend",
                    "icon": 0xf04b2,
                    "cmd": ["sh", "-c", "swaylock -f && systemctl suspend"]
                },
                {
                    "name": "Log out",
                    "icon": 0xf0343,
                    "cmd": ["niri", "msg", "action", "quit", "--skip-confirmation"],
                    "confirm": true
                },
                {
                    "name": "Restart",
                    "icon": 0xf0709,
                    "cmd": ["systemctl", "reboot"],
                    "confirm": true
                },
                {
                    "name": "Shut down",
                    "icon": 0xf0425,
                    "cmd": ["systemctl", "poweroff"],
                    "confirm": true
                }
            ]

            MouseArea {
                id: entry

                required property var modelData
                readonly property bool armed: menu.armed === modelData.name

                width: parent.width
                height: 32
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (modelData.confirm && !armed) {
                        menu.armed = modelData.name;
                        return;
                    }
                    Popouts.close();
                    Quickshell.execDetached(modelData.cmd);
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: entry.armed ? Theme.red : entry.containsMouse ? Theme.surface0 : "transparent"
                }
                Label {
                    anchors.fill: parent
                    leftPadding: 10
                    text: Theme.glyph(entry.modelData.icon) + "   " + (entry.armed ? "Click to confirm" : entry.modelData.name)
                    color: entry.armed ? Theme.crust : Theme.text
                    font.pixelSize: Theme.smallSize
                }
            }
        }
    }
}
