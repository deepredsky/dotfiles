import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.services

Row {
    height: parent.height
    leftPadding: 8
    rightPadding: 8
    spacing: 8

    Repeater {
        model: SystemTray.items

        MouseArea {
            id: item

            required property SystemTrayItem modelData

            width: 16
            height: parent.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton && !modelData.onlyMenu)
                    modelData.activate();
                else if (mouse.button === Qt.MiddleButton)
                    modelData.secondaryActivate();
                else if (modelData.hasMenu)
                    modelData.display(QsWindow.window, mapToItem(null, 0, 0).x, Theme.barHeight);
            }

            IconImage {
                anchors.centerIn: parent
                source: item.modelData.icon
                implicitSize: 16
            }
        }
    }
}
