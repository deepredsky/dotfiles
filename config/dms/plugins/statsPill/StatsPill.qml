import QtQuick
import Quickshell.Io
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Services

PluginComponent {
    id: root

    // dGPU = the card with the most VRAM, same rule as ~/.bin/vram.sh.
    property real vramUsed: 0
    property real vramTotal: 0
    property int gpuBusy: 0
    readonly property string vramPct: vramTotal > 0 ? Math.round(vramUsed * 100 / vramTotal) + "%" : "--"

    Component.onCompleted: DgopService.addRef(["cpu", "memory", "system"])
    Component.onDestruction: DgopService.removeRef(["cpu", "memory", "system"])

    function gb(bytes) {
        return (bytes / 1073741824).toFixed(1) + " GB";
    }

    Process {
        id: gpuProc
        command: ["sh", "-c", "for d in /sys/class/drm/card*/device; do [ -f $d/mem_info_vram_total ] && echo $(cat $d/mem_info_vram_total) $(cat $d/mem_info_vram_used) $(cat $d/gpu_busy_percent 2>/dev/null || echo 0); done | sort -n | tail -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const f = text.trim().split(" ");
                if (f.length < 3)
                    return;
                root.vramTotal = Number(f[0]);
                root.vramUsed = Number(f[1]);
                root.gpuBusy = Number(f[2]);
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: gpuProc.running = true
    }

    component Stat: Row {
        property string icon
        property string value
        spacing: Theme.spacingXS
        DIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: parent.icon
            size: root.iconSize
            color: Theme.widgetIconColor
        }
        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: parent.value
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.widgetTextColor
        }
    }

    component Section: StyledText {
        topPadding: Theme.spacingS
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Bold
        color: Theme.primary
    }

    component Line: Row {
        property string label
        property string value
        width: parent.width
        StyledText {
            width: parent.width * 0.4
            text: parent.label
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }
        StyledText {
            width: parent.width * 0.6
            text: parent.value
            elide: Text.ElideRight
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingM
            Stat { icon: "memory"; value: DgopService.cpuUsage.toFixed(0) + "%" }
            Stat { icon: "developer_board"; value: DgopService.memoryUsage.toFixed(0) + "%" }
            Stat { icon: "videogame_asset"; value: root.vramPct }
        }
    }
    verticalBarPill: horizontalBarPill

    popoutWidth: 320
    popoutHeight: 360
    popoutContent: Component {
        PopoutComponent {
            headerText: "System"
            Column {
                width: parent.width
                spacing: Theme.spacingXS

                Section { text: "CPU" }
                Line { label: "Model"; value: DgopService.cpuModel || "--" }
                Line { label: "Usage"; value: DgopService.cpuUsage.toFixed(0) + "%" }
                Line { label: "Clock"; value: (DgopService.cpuFrequency / 1000).toFixed(2) + " GHz" }
                Line { label: "Cores"; value: DgopService.cpuCores }
                Line { label: "Load"; value: DgopService.loadAverage || "--" }

                Section { text: "Memory" }
                Line { label: "Used"; value: root.gb(DgopService.usedMemoryMB * 1048576) + " / " + root.gb(DgopService.totalMemoryMB * 1048576) }
                Line { label: "Available"; value: root.gb(DgopService.availableMemoryMB * 1048576) }
                Line { label: "Swap"; value: root.gb(DgopService.usedSwapKB * 1024) + " / " + root.gb(DgopService.totalSwapKB * 1024) }

                Section { text: "GPU" }
                Line { label: "VRAM"; value: root.gb(root.vramUsed) + " / " + root.gb(root.vramTotal) }
                Line { label: "Busy"; value: root.gpuBusy + "%" }
            }
        }
    }
}
