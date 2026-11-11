import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.services

Scope {
    id: root

    required property ShellScreen modelData

    component Sep: Label {
        anchors.verticalCenter: parent.verticalCenter
        text: "│"
        color: Theme.overlay0
        opacity: 0.35
        font.pixelSize: Theme.smallSize
    }

    PanelWindow {
        id: bar

        screen: root.modelData
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: Theme.barHeight + 1
        color: Theme.crust

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Theme.overlay1
        }

        Workspaces {
            anchors.left: parent.left
            height: Theme.barHeight
            output: root.modelData.name
        }

        WindowTitle {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.barHeight
        }

        Row {
            anchors.right: parent.right
            height: Theme.barHeight

            Media {
                id: media
            }
            Sep {
                visible: media.visible
            }
            Tray {}
            Sep {}
            SystemStats {}
            Sep {}
            Temps {}
            Sep {}
            Network {}
            Sep {}
            Volume {}
            Sep {}
            Notifications {}
            Sep {}
            Clock {}
            Sep {}
            Power {}
        }
    }

    // Transparent click-catcher below the bar; clicking outside the popout closes it.
    PanelWindow {
        screen: root.modelData
        visible: Popouts.item !== null && Popouts.item.QsWindow.window === bar
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.namespace: "quickshell-popout"

        MouseArea {
            anchors.fill: parent
            onClicked: Popouts.close()
        }

        Rectangle {
            id: panel

            readonly property real itemX: Popouts.item ? Popouts.item.mapToItem(null, 0, 0).x + Popouts.item.width / 2 : 0

            x: Math.max(8, Math.min(parent.width - width - 8, itemX - width / 2))
            y: 6
            width: loader.implicitWidth + 32
            height: loader.implicitHeight + 32
            color: Theme.base
            border.color: Theme.surface1
            radius: 10
            focus: true
            Keys.onEscapePressed: Popouts.close()

            // Swallow clicks so they don't reach the click-catcher.
            MouseArea {
                anchors.fill: parent
            }

            Loader {
                id: loader
                x: 16
                y: 16
                sourceComponent: Popouts.content
            }
        }
    }
}
