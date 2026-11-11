import QtQuick
import qs.services

// "Label    value" row for popouts.
Row {
    property string label
    property string value

    width: parent.width

    Label {
        width: parent.width * 0.35
        text: parent.label
        color: Theme.subtext0
        font.pixelSize: Theme.smallSize
        font.weight: Font.Normal
    }

    Label {
        width: parent.width * 0.65
        text: parent.value
        elide: Text.ElideRight
        font.pixelSize: Theme.smallSize
        font.weight: Font.Normal
    }
}
