import QtQuick
import qs.components
import qs.services

// Numbered pills; the active workspace is filled mauve.
Row {
    id: root

    property string output

    leftPadding: 8
    spacing: 6

    Repeater {
        model: Niri.workspaces.filter(w => w.output === root.output)

        MouseArea {
            id: ws

            required property var modelData
            readonly property bool active: modelData.is_active

            anchors.verticalCenter: parent.verticalCenter
            width: 34
            height: 22
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Niri.action(["focus-workspace", String(modelData.idx)])

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: ws.modelData.is_urgent ? Theme.red : ws.active ? Theme.mauve : ws.containsMouse ? Theme.surface1 : Theme.surface0
            }

            Label {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -1 // extra room on the right
                text: ws.modelData.name || ws.modelData.idx
                color: ws.active || ws.modelData.is_urgent ? Theme.crust : Theme.subtext0
                font.pixelSize: Theme.smallSize
            }
        }
    }
}
