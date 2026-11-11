import QtQuick
import qs.services

// A bar cell: content in a row, waybar-style mauve top border on hover,
// and an optional popout toggled by left click.
MouseArea {
    id: root

    default property alias content: row.data
    property Component popout: null
    readonly property bool open: Popouts.item === root

    implicitWidth: row.implicitWidth + 16
    implicitHeight: Theme.barHeight
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    cursorShape: Qt.PointingHandCursor

    onClicked: mouse => {
        if (popout && mouse.button === Qt.LeftButton)
            Popouts.toggle(root, popout);
    }

    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 2
        color: Theme.mauve
        visible: root.containsMouse || root.open
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
    }
}
