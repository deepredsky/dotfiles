#!/bin/sh
# Picks the card with the most VRAM so the dGPU is used even if card indices shift.
for d in /sys/class/drm/card*/device; do
    [ -f "$d/mem_info_vram_total" ] && echo "$(cat "$d/mem_info_vram_total") $(cat "$d/mem_info_vram_used")"
done | sort -n | tail -1 | awk '{ printf "%d%%\n%.1fGB / %.1fGB used\n", $2*100/$1, $2/2^30, $1/2^30 }'
