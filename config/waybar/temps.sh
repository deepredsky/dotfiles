#!/bin/sh
# Bar shows the hottest sensor; tooltip lists every hwmon sensor, hottest first.
for h in /sys/class/hwmon/hwmon*; do
    [ -f "$h/temp1_input" ] || continue
    case $(cat "$h/name") in
        k10temp) label=CPU ;;
        amdgpu) if [ "$(cat "$h/device/mem_info_vram_total")" -gt 4294967296 ]; then label=GPU; else label=iGPU; fi ;;
        nvme) ssd=$((ssd + 1)); label="SSD $ssd" ;;
        spd5118) ram=$((ram + 1)); label="RAM $ram" ;;
        mt7925*) label=Wi-Fi ;;
        *) label=$(cat "$h/name") ;;
    esac
    echo "$(( $(cat "$h/temp1_input") / 1000 )) $label"
done | sort -rn | awk '
    NR == 1 { top = $1; name = substr($0, index($0, " ") + 1) }
    { tip = tip sep $1 "°C  " substr($0, index($0, " ") + 1); sep = "\\n" }
    END {
        pct = int(top * 100 / 80); if (pct > 100) pct = 100
        printf "{\"text\": \"%d°C %s\", \"tooltip\": \"%s\", \"percentage\": %d, \"class\": \"%s\"}\n", top, name, tip, pct, top >= 80 ? "critical" : ""
    }'
