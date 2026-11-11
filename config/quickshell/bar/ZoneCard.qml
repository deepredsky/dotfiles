import QtQuick
import qs.components
import qs.services

// Time, offset and sunrise/sunset for a city, computed locally with the sunrise equation.
Column {
    id: root

    property string title
    property real lat
    property real lon
    // "ist" (fixed UTC+5:30) or "cet" (EU rules); QML's JS has no Intl time zones
    property string zone: "ist"
    property date now

    readonly property int offsetMinutes: offsetAt(now)
    readonly property var zoneNow: new Date(now.getTime() + offsetMinutes * 60000)
    readonly property var today: sunTimes(0)
    readonly property bool daylight: now >= today.rise && now < today.set
    readonly property var nextEvent: daylight ? {
        "name": "Sunset",
        "at": today.set
    } : {
        "name": "Sunrise",
        "at": now < today.rise ? today.rise : sunTimes(1).rise
    }
    readonly property real dayProgress: (now - today.rise) / (today.set - today.rise)

    readonly property string diffText: {
        const diff = offsetMinutes + now.getTimezoneOffset();
        if (diff === 0)
            return "same time";
        return duration(Math.abs(diff)) + (diff > 0 ? " ahead" : " behind");
    }
    readonly property string dateText: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][zoneNow.getUTCDay()] + ", " + zoneNow.getUTCDate() + " " + ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][zoneNow.getUTCMonth()]

    width: 240
    spacing: 2

    function offsetAt(date) {
        if (zone !== "cet")
            return 330;
        // EU summer time: last Sunday of March to last Sunday of October, switching at 01:00 UTC
        const y = date.getUTCFullYear();
        const lastSunday = month => {
            const d = new Date(Date.UTC(y, month + 1, 0, 1));
            return d.getTime() - d.getUTCDay() * 86400000;
        };
        const t = date.getTime();
        return t >= lastSunday(2) && t < lastSunday(9) ? 120 : 60;
    }

    function zoneTime(date) {
        const t = new Date(date.getTime() + offsetAt(date) * 60000);
        return String(t.getUTCHours()).padStart(2, "0") + ":" + String(t.getUTCMinutes()).padStart(2, "0");
    }

    function duration(minutes) {
        const h = Math.floor(minutes / 60);
        const m = Math.round(minutes % 60);
        return h === 0 ? m + " min" : h + "h" + (m ? " " + m + "m" : "");
    }

    // Sunrise equation (en.wikipedia.org/wiki/Sunrise_equation), accurate to about a minute
    function sunTimes(dayOffset) {
        const rad = Math.PI / 180;
        const midnight = Date.UTC(zoneNow.getUTCFullYear(), zoneNow.getUTCMonth(), zoneNow.getUTCDate() + dayOffset);
        const n = Math.round(midnight / 86400000 + 2440587.5 - 2451545 + 0.0008);
        const j = n - lon / 360;
        const m = (357.5291 + 0.98560028 * j) % 360;
        const c = 1.9148 * Math.sin(m * rad) + 0.02 * Math.sin(2 * m * rad) + 0.0003 * Math.sin(3 * m * rad);
        const l = (m + c + 180 + 102.9372) % 360;
        const transit = 2451545 + j + 0.0053 * Math.sin(m * rad) - 0.0069 * Math.sin(2 * l * rad);
        const sinDec = Math.sin(l * rad) * Math.sin(23.4397 * rad);
        const cosDec = Math.cos(Math.asin(sinDec));
        const w = Math.acos(Math.max(-1, Math.min(1, (Math.sin(-0.833 * rad) - Math.sin(lat * rad) * sinDec) / (Math.cos(lat * rad) * cosDec)))) / rad;
        const toDate = jd => new Date((jd - 2440587.5) * 86400000);
        return {
            "rise": toDate(transit - w / 360),
            "set": toDate(transit + w / 360),
            "noon": toDate(transit),
            "length": w / 180 * 24 * 60
        };
    }

    Label {
        text: root.title
        color: Theme.subtext0
        font.pixelSize: Theme.smallSize
    }

    Label {
        text: root.zoneTime(root.now)
        color: Theme.mauve
        font.pixelSize: 40
    }

    Label {
        text: root.dateText + " · " + root.diffText
        color: Theme.subtext0
        font.pixelSize: Theme.smallSize
        font.weight: Font.Normal
    }

    Canvas {
        id: arc

        property real progress: root.dayProgress

        width: parent.width
        height: 80
        onProgressChanged: requestPaint()

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const dot = 7;
            const r = Math.min(width / 2 - dot, height - dot * 2);
            const cx = width / 2, cy = height - dot;
            ctx.lineWidth = 3;
            ctx.lineCap = "round";
            ctx.strokeStyle = Theme.surface1;
            ctx.beginPath();
            ctx.moveTo(cx - r - dot, cy);
            ctx.lineTo(cx + r + dot, cy);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(cx, cy, r, Math.PI, 2 * Math.PI);
            ctx.stroke();
            if (progress < 0 || progress > 1)
                return;
            const a = Math.PI + progress * Math.PI;
            ctx.strokeStyle = Theme.yellow;
            ctx.beginPath();
            ctx.arc(cx, cy, r, Math.PI, a);
            ctx.stroke();
            ctx.fillStyle = Theme.yellow;
            ctx.beginPath();
            ctx.arc(cx + r * Math.cos(a), cy + r * Math.sin(a), dot, 0, 2 * Math.PI);
            ctx.fill();
        }
    }

    Item {
        width: 1
        height: 6
    }

    Field {
        label: "Sunrise"
        value: root.zoneTime(root.today.rise)
    }
    Field {
        label: "Solar noon"
        value: root.zoneTime(root.today.noon)
    }
    Field {
        label: "Sunset"
        value: root.zoneTime(root.today.set)
    }
    Field {
        label: "Daylight"
        value: root.duration(root.today.length)
    }
    Field {
        label: root.nextEvent.name + " in"
        value: root.duration((root.nextEvent.at - root.now) / 60000)
    }
}
