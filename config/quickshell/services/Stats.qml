pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// CPU, memory, GPU, network and temperatures, polled from /proc, /sys and ~/.bin/temps.sh.
Singleton {
    id: root

    property real cpu: 0
    property real cpuMhz: 0
    property string cpuModel: "--"
    property int cores: 0
    property string load: "--"

    property real memTotal: 0
    property real memAvailable: 0
    readonly property real memUsed: memTotal - memAvailable
    readonly property real mem: memTotal > 0 ? memUsed * 100 / memTotal : 0
    property real swapTotal: 0
    property real swapUsed: 0

    // dGPU = the card with the most VRAM, same rule as ~/.bin/vram.sh.
    property real vramTotal: 0
    property real vramUsed: 0
    readonly property real vram: vramTotal > 0 ? vramUsed * 100 / vramTotal : 0
    property int gpuBusy: 0

    property real rxRate: 0
    property real txRate: 0

    property string tempSummary: "--"
    property var temps: []
    property bool tempCritical: false

    property var prev: null

    function parse(text) {
        const now = Date.now();
        const s = {
            "rx": 0,
            "tx": 0
        };
        const kb = {};
        let vramBest = null;
        for (const line of text.split("\n")) {
            const f = line.trim().split(/\s+/);
            if (f[0] === "cpu") {
                const n = f.slice(1).map(Number);
                s.idle = n[3] + n[4];
                s.total = n.reduce((a, b) => a + b, 0);
            } else if (f[0].endsWith(":") && f.length === 3) {
                kb[f[0].slice(0, -1)] = Number(f[1]) * 1024;
            } else if (f[0] === "net") {
                s.rx += Number(f[1]);
                s.tx += Number(f[2]);
            } else if (f[0] === "vram") {
                if (!vramBest || Number(f[1]) > vramBest[1])
                    vramBest = f.map(Number);
            } else if (f[0] === "load") {
                load = f.slice(1).join("  ");
            } else if (f[0] === "mhz") {
                cpuMhz = Number(f[1]);
            }
        }
        memTotal = kb.MemTotal ?? 0;
        memAvailable = kb.MemAvailable ?? 0;
        swapTotal = kb.SwapTotal ?? 0;
        swapUsed = swapTotal - (kb.SwapFree ?? 0);
        if (vramBest) {
            vramTotal = vramBest[1];
            vramUsed = vramBest[2];
            gpuBusy = vramBest[3];
        }
        if (prev) {
            const dt = (now - prev.time) / 1000;
            const total = s.total - prev.total;
            cpu = total > 0 ? (1 - (s.idle - prev.idle) / total) * 100 : 0;
            rxRate = Math.max(0, (s.rx - prev.rx) / dt);
            txRate = Math.max(0, (s.tx - prev.tx) / dt);
        }
        s.time = now;
        prev = s;
    }

    Process {
        id: poll
        // Virtual interfaces (docker, tailscale, bridges) would double-count traffic.
        command: ["sh", "-c", `
            head -1 /proc/stat
            grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo
            echo load $(cut -d' ' -f1-3 /proc/loadavg)
            awk '/MHz/ { s += $4; n++ } END { print "mhz", s / n }' /proc/cpuinfo
            awk 'NR > 2 { sub(/:/, " ") } NR > 2 && $1 !~ /^(lo|docker|br-|veth|virbr|tailscale)/ { print "net", $2, $10 }' /proc/net/dev
            for d in /sys/class/drm/card*/device; do
                [ -f $d/mem_info_vram_total ] && echo vram $(cat $d/mem_info_vram_total $d/mem_info_vram_used) $(cat $d/gpu_busy_percent 2>/dev/null || echo 0)
            done`]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: poll.running = true
    }

    Process {
        running: true
        command: ["sh", "-c", "grep -m1 'model name' /proc/cpuinfo | cut -d: -f2; nproc"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                root.cpuModel = lines[0].trim();
                root.cores = Number(lines[1]);
            }
        }
    }

    Process {
        id: tempsProc
        command: ["sh", "-c", "~/.bin/temps.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const out = JSON.parse(text);
                    root.tempSummary = out.text;
                    root.temps = out.tooltip.split("\n");
                    root.tempCritical = out["class"] === "critical";
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: tempsProc.running = true
    }
}
