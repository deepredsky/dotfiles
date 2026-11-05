import QtQuick
import Quickshell.Io
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    // Same script as the waybar module: text = hottest, tooltip = all sensors.
    property string summary: "--"
    property var sensors: []
    property bool critical: false

    Process {
        id: proc
        command: ["sh", "-c", "~/.bin/temps.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const out = JSON.parse(text);
                    root.summary = out.text;
                    root.sensors = out.tooltip.split("\n");
                    root.critical = out["class"] === "critical";
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS
            DIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: "thermostat"
                size: root.iconSize
                color: root.critical ? Theme.error : Theme.widgetIconColor
            }
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: root.summary
                font.pixelSize: Theme.fontSizeSmall
                color: root.critical ? Theme.error : Theme.widgetTextColor
            }
        }
    }
    verticalBarPill: horizontalBarPill

    popoutWidth: 240
    popoutHeight: 320
    popoutContent: Component {
        PopoutComponent {
            headerText: "Temperatures"
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Repeater {
                    model: root.sensors
                    StyledText {
                        text: modelData
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceText
                    }
                }
            }
        }
    }
}
