import QtQuick
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Services

PluginComponent {
    id: root

    Component.onCompleted: DgopService.addRef(["network"])
    Component.onDestruction: DgopService.removeRef(["network"])

    function rate(b) {
        if (b < 1024)
            return b.toFixed(0) + " B/s";
        if (b < 1024 * 1024)
            return (b / 1024).toFixed(1) + " KB/s";
        return (b / (1024 * 1024)).toFixed(1) + " MB/s";
    }

    component Rate: Row {
        property string arrow
        property real value
        spacing: Theme.spacingXS
        StyledText {
            text: parent.arrow
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.info
        }
        StyledText {
            text: root.rate(parent.value)
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.widgetTextColor
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS
            Rate { arrow: "↓"; value: DgopService.networkRxRate }
            Rate { arrow: "↑"; value: DgopService.networkTxRate }
        }
    }
    verticalBarPill: horizontalBarPill
}
