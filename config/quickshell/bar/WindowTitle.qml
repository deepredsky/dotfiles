import QtQuick
import qs.components
import qs.services

Label {
    width: Math.min(implicitWidth, 600)
    text: Niri.focusedWindow?.title ?? ""
    color: Theme.overlay1
    elide: Text.ElideRight
}
