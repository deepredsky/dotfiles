import QtQuick
import Quickshell.Networking
import qs.components
import qs.services

// Connection icon + up/down rate; click for the Wi-Fi list.
BarButton {
    id: root

    readonly property var devices: Networking.devices.values
    readonly property var wired: devices.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wifiNetworks: wifi ? wifi.networks.values : []
    readonly property var active: wifiNetworks.find(n => n.connected) ?? null

    function signalGlyph(strength) {
        return Theme.glyph([0xf092f, 0xf091f, 0xf0922, 0xf0925, 0xf0928][Math.min(4, Math.floor(strength * 5))]);
    }

    // At most 4 chars ("1.2K", "45K", "999M") so the fixed width stays tight.
    function rate(b) {
        const units = ["B", "K", "M", "G"];
        let i = 0;
        while (b >= 1000 && i < units.length - 1) {
            b /= 1024;
            i++;
        }
        return (i > 0 && b < 10 ? b.toFixed(1) : b.toFixed(0)) + units[i];
    }

    TextMetrics {
        id: rateWidth
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        font.weight: Font.Bold
        text: "999M"
    }

    Label {
        text: root.wired ? Theme.glyph(0xf0200) : root.active ? root.signalGlyph(root.active.signalStrength) : Theme.glyph(0xf092e)
        color: Theme.yellow
    }
    // Fixed width so changing rates don't shift the rest of the bar.
    Label {
        text: Theme.glyph(0xf063)
        color: Theme.yellow
    }
    Label {
        width: rateWidth.advanceWidth
        horizontalAlignment: Text.AlignRight
        text: root.rate(Stats.rxRate)
        color: Theme.yellow
    }
    Label {
        leftPadding: 8
        text: Theme.glyph(0xf062)
        color: Theme.yellow
    }
    Label {
        width: rateWidth.advanceWidth
        horizontalAlignment: Text.AlignRight
        text: root.rate(Stats.txRate)
        color: Theme.yellow
    }

    popout: Column {
        id: pop

        property string error: ""
        property var asking: null // network waiting for a password

        width: 340
        spacing: 4

        Component.onCompleted: if (root.wifi) root.wifi.scannerEnabled = true
        Component.onDestruction: if (root.wifi) root.wifi.scannerEnabled = false

        Item {
            width: parent.width
            height: title.height

            Heading {
                id: title
                text: "Wi-Fi"
                topPadding: 0
            }
            Label {
                anchors.right: parent.right
                text: Networking.wifiEnabled ? Theme.glyph(0xf0a19) : Theme.glyph(0xf0a1a)
                color: Networking.wifiEnabled ? Theme.mauve : Theme.overlay0
                font.pixelSize: 22
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }
        }

        Field {
            visible: root.wired !== null
            label: "Ethernet"
            value: root.wired?.name ?? ""
        }

        Label {
            visible: pop.error !== ""
            width: parent.width
            text: pop.error
            color: Theme.red
            font.pixelSize: Theme.smallSize
            wrapMode: Text.Wrap
        }

        Repeater {
            model: root.wifiNetworks.filter(n => n.name).sort((a, b) => b.connected - a.connected || b.signalStrength - a.signalStrength)

            Column {
                id: net

                required property var modelData

                width: parent.width

                Connections {
                    target: net.modelData
                    function onConnectionFailed(reason) {
                        pop.error = net.modelData.name + ": " + ConnectionFailReason.toString(reason);
                    }
                }

                MouseArea {
                    id: rowArea
                    width: parent.width
                    height: 28
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        pop.error = "";
                        const n = net.modelData;
                        if (n.connected)
                            return;
                        if (n.known || n.security === WifiSecurityType.Open)
                            n.connect();
                        else
                            pop.asking = pop.asking === n ? null : n;
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: rowArea.containsMouse ? Theme.surface0 : "transparent"
                    }
                    Label {
                        anchors.fill: parent
                        leftPadding: 8
                        rightPadding: 8
                        text: root.signalGlyph(net.modelData.signalStrength) + "  " + net.modelData.name
                        color: net.modelData.connected ? Theme.mauve : Theme.text
                        font.pixelSize: Theme.smallSize
                        font.weight: net.modelData.connected ? Font.Bold : Font.Normal
                        elide: Text.ElideRight
                    }
                    Label {
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: net.modelData.stateChanging ? "…" : net.modelData.security === WifiSecurityType.Open ? "" : Theme.glyph(0xf033e)
                        color: Theme.overlay1
                        font.pixelSize: Theme.smallSize
                    }
                }

                Rectangle {
                    visible: pop.asking === net.modelData
                    width: parent.width
                    height: 30
                    radius: 6
                    color: Theme.surface0

                    TextInput {
                        id: psk
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: Theme.smallSize
                        onVisibleChanged: if (visible) forceActiveFocus()
                        onAccepted: {
                            net.modelData.connectWithPsk(text);
                            pop.asking = null;
                        }
                    }
                    Label {
                        visible: psk.text === ""
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        text: "Password, then Enter"
                        color: Theme.overlay0
                        font.pixelSize: Theme.smallSize
                        font.weight: Font.Normal
                    }
                }
            }
        }
    }
}
