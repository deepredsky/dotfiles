import QtQuick
import qs.services

// Minimal horizontal slider; emits moved(value) while dragging or scrolling.
Item {
    id: root

    property real value: 0
    property real to: 1
    property color accent: Theme.blue
    signal moved(real value)

    implicitHeight: 20

    function set(v) {
        root.moved(Math.max(0, Math.min(to, v)));
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.min(1, root.value / root.to)
            height: parent.height
            radius: 3
            color: root.accent
        }
    }

    Rectangle {
        x: (root.width - width) * Math.min(1, root.value / root.to)
        anchors.verticalCenter: parent.verticalCenter
        width: 14
        height: 14
        radius: 7
        color: root.accent
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => root.set(mouse.x / width * root.to)
        onPositionChanged: mouse => root.set(mouse.x / width * root.to)
        onWheel: wheel => root.set(root.value + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    }
}
