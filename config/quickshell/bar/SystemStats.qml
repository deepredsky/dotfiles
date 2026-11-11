import QtQuick
import qs.components
import qs.services

// CPU / RAM / VRAM in waybar's colours; click for the System popout.
BarButton {
    Label {
        text: Theme.glyph(0xf2db) + " " + Stats.cpu.toFixed(0) + "%"
        color: Theme.teal
    }
    Label {
        leftPadding: 8
        text: Theme.glyph(0xf035b) + " " + Stats.mem.toFixed(0) + "%"
        color: Theme.sky
    }
    Label {
        leftPadding: 8
        text: Theme.glyph(0xf08ae) + " " + Stats.vram.toFixed(0) + "%"
        color: Theme.sapphire
    }

    popout: Column {
        width: 320
        spacing: 2

        Heading {
            text: "CPU"
            topPadding: 0
        }
        Field {
            label: "Model"
            value: Stats.cpuModel
        }
        Field {
            label: "Usage"
            value: Stats.cpu.toFixed(0) + "%"
        }
        Field {
            label: "Clock"
            value: (Stats.cpuMhz / 1000).toFixed(2) + " GHz"
        }
        Field {
            label: "Cores"
            value: Stats.cores
        }
        Field {
            label: "Load"
            value: Stats.load
        }

        Heading {
            text: "Memory"
        }
        Field {
            label: "Used"
            value: Theme.bytes(Stats.memUsed) + " / " + Theme.bytes(Stats.memTotal)
        }
        Field {
            label: "Available"
            value: Theme.bytes(Stats.memAvailable)
        }
        Field {
            label: "Swap"
            value: Theme.bytes(Stats.swapUsed) + " / " + Theme.bytes(Stats.swapTotal)
        }

        Heading {
            text: "GPU"
        }
        Field {
            label: "VRAM"
            value: Theme.bytes(Stats.vramUsed) + " / " + Theme.bytes(Stats.vramTotal)
        }
        Field {
            label: "Busy"
            value: Stats.gpuBusy + "%"
        }
    }
}
