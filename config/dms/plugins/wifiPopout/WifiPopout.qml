import QtQuick
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Modules.ControlCenter.Details
import qs.Services

PluginComponent {
    id: root

    function networkIcon() {
        if (NetworkService.wifiToggling)
            return "sync";
        switch (NetworkService.networkStatus) {
        case "ethernet":
            return "lan";
        case "cellular":
            return "network_cell";
        default:
            return NetworkService.ethernetConnected ? "lan" : NetworkService.wifiSignalIcon;
        }
    }

    horizontalBarPill: Component {
        DIcon {
            name: root.networkIcon()
            size: root.iconSize
            color: Theme.widgetIconColor
        }
    }
    verticalBarPill: horizontalBarPill

    popoutWidth: 420
    popoutHeight: 480
    popoutContent: Component {
        PopoutComponent {
            headerText: "Network"
            NetworkDetail {
                width: parent.width
                height: 420
            }
        }
    }
}
