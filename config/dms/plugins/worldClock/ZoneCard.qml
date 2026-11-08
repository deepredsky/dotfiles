import QtQuick
import Quickshell
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Modules.DDash

DashCardComponent {
    id: root

    // set by the wrapper card; cities maps option values to { name, lat, lon }
    property string region
    property var cities: ({})
    property string defaultCity
    // "ist" (fixed UTC+5:30) or "cet" (EU rules); QML's JS has no Intl time zones
    property string zone: "ist"

    readonly property var city: cities[options.city ?? defaultCity] ?? cities[defaultCity]
    readonly property var now: clock.date
    readonly property int offsetMinutes: offsetAt(now)
    readonly property var zoneNow: new Date(now.getTime() + offsetMinutes * 60000)
    readonly property var today: sunTimes(0)
    readonly property bool daylight: now >= today.rise && now < today.set
    readonly property var nextEvent: daylight ? { "name": "Sunset", "at": today.set } : { "name": "Sunrise", "at": now < today.rise ? today.rise : sunTimes(1).rise }

    readonly property real dayProgress: (now - today.rise) / (today.set - today.rise)
    // card heights lose padding and gain gaps, so compare against fractional rows
    readonly property bool tall: height >= DashMetrics.gridRowUnit * 1.5
    readonly property bool roomy: height >= DashMetrics.gridRowUnit * 2.5
    readonly property bool stacked: roomy && height >= width * 0.9
    readonly property bool wide: !stacked && width >= DashMetrics.gridRowUnit * 2
    readonly property string title: city.name === region ? region : region + " · " + city.name

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

    readonly property string diffText: {
        const diff = offsetMinutes + now.getTimezoneOffset();
        if (diff === 0)
            return "same time";
        return duration(Math.abs(diff)) + (diff > 0 ? " ahead" : " behind");
    }
    readonly property string dateText: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][zoneNow.getUTCDay()] + ", " + zoneNow.getUTCDate() + " " + ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][zoneNow.getUTCMonth()]

    function istTime(date) {
        const t = new Date(date.getTime() + offsetAt(date) * 60000);
        const h = t.getUTCHours();
        const m = String(t.getUTCMinutes()).padStart(2, "0");
        if (SettingsData.use24HourClock)
            return String(h).padStart(2, "0") + ":" + m;
        return (h % 12 === 0 ? 12 : h % 12) + ":" + m + (h < 12 ? " AM" : " PM");
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
        const j = n - city.lon / 360;
        const m = (357.5291 + 0.98560028 * j) % 360;
        const c = 1.9148 * Math.sin(m * rad) + 0.02 * Math.sin(2 * m * rad) + 0.0003 * Math.sin(3 * m * rad);
        const l = (m + c + 180 + 102.9372) % 360;
        const transit = 2451545 + j + 0.0053 * Math.sin(m * rad) - 0.0069 * Math.sin(2 * l * rad);
        const sinDec = Math.sin(l * rad) * Math.sin(23.4397 * rad);
        const cosDec = Math.cos(Math.asin(sinDec));
        const w = Math.acos(Math.max(-1, Math.min(1, (Math.sin(-0.833 * rad) - Math.sin(city.lat * rad) * sinDec) / (Math.cos(city.lat * rad) * cosDec)))) / rad;
        const toDate = jd => new Date((jd - 2440587.5) * 86400000);
        return {
            "rise": toDate(transit - w / 360),
            "set": toDate(transit + w / 360),
            "noon": toDate(transit),
            "length": w / 180 * 24 * 60
        };
    }

    SystemClock {
        id: clock
        enabled: root.live
        precision: SystemClock.Minutes
    }

    Column {
        id: header
        anchors.left: parent.left
        anchors.top: parent.top
        width: root.wide && !root.stacked ? parent.width * 0.5 : parent.width

        StyledText {
            width: parent.width
            text: root.wide || root.stacked ? root.title : root.region
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Theme.fontWeightMedium
            color: root.mutedColor
            elide: Text.ElideRight
        }

        StyledText {
            visible: root.stacked
            width: parent.width
            text: root.istTime(root.now)
            font.pixelSize: Theme.fontSizeDisplay
            font.weight: Theme.fontWeightMedium
            color: root.accentColor
            fontSizeMode: Text.HorizontalFit
            minimumPixelSize: Theme.fontSizeMedium
        }

        StyledText {
            visible: root.stacked
            width: parent.width
            text: root.dateText + " · " + root.diffText
            font.pixelSize: Theme.fontSizeSmall
            color: root.mutedColor
            elide: Text.ElideRight
        }
    }

    Column {
        id: timeBlock
        visible: !root.stacked
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: header.width

        StyledText {
            width: parent.width
            text: root.istTime(root.now)
            font.pixelSize: root.tall ? Theme.fontSizeDisplay : Theme.fontSizeXLarge
            font.weight: Theme.fontWeightMedium
            color: root.accentColor
            fontSizeMode: Text.HorizontalFit
            minimumPixelSize: Theme.fontSizeMedium
        }

        StyledText {
            width: parent.width
            text: (root.wide ? root.dateText : root.dateText.slice(0, 3)) + " · " + root.diffText
            font.pixelSize: Theme.fontSizeSmall
            color: root.mutedColor
            elide: Text.ElideRight
        }
    }

    Canvas {
        id: arc
        visible: root.roomy
        anchors.left: parent.left
        anchors.right: root.stacked ? parent.right : undefined
        width: root.stacked ? undefined : header.width
        anchors.top: header.bottom
        anchors.bottom: root.stacked ? sunRows.top : timeBlock.top
        anchors.topMargin: Theme.spacingM
        anchors.bottomMargin: Theme.spacingM

        property real progress: root.dayProgress
        property color track: root.chipColor
        property color fill: root.accentColor
        onProgressChanged: requestPaint()
        onTrackChanged: requestPaint()
        onFillChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const line = 3, dot = 7;
            const r = Math.max(0, Math.min(width / 2 - dot, height - dot * 2));
            const cx = width / 2, cy = height - dot;
            ctx.lineWidth = line;
            ctx.lineCap = "round";
            ctx.strokeStyle = track;
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
            ctx.strokeStyle = fill;
            ctx.beginPath();
            ctx.arc(cx, cy, r, Math.PI, a);
            ctx.stroke();
            ctx.fillStyle = fill;
            ctx.beginPath();
            ctx.arc(cx + r * Math.cos(a), cy + r * Math.sin(a), dot, 0, 2 * Math.PI);
            ctx.fill();
        }
    }

    Column {
        id: sunRows
        visible: root.wide || root.stacked
        anchors.right: parent.right
        width: root.stacked ? parent.width : parent.width * 0.5 - Theme.spacingM
        spacing: root.tall ? Theme.spacingS : 0
        anchors.bottom: root.stacked ? parent.bottom : undefined
        anchors.verticalCenter: root.stacked ? undefined : parent.verticalCenter

        SunRow {
            icon: "sunny"
            label: "Sunrise"
            value: root.istTime(root.today.rise)
        }

        SunRow {
            visible: root.roomy
            icon: "brightness_7"
            label: "Solar noon"
            value: root.istTime(root.today.noon)
        }

        SunRow {
            icon: "wb_twilight"
            label: "Sunset"
            value: root.istTime(root.today.set)
        }

        SunRow {
            visible: root.tall
            icon: "light_mode"
            label: "Daylight"
            value: root.duration(root.today.length)
        }

        SunRow {
            icon: root.daylight ? "clear_day" : "bedtime"
            label: root.nextEvent.name + " in"
            value: root.duration((root.nextEvent.at - root.now) / 60000)
            highlight: true
        }
    }
    component SunRow: Row {
        property string icon
        property string label
        property string value
        property bool highlight: false

        width: parent.width
        spacing: Theme.spacingS

        DIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: parent.icon
            size: Theme.fontSizeMedium
            color: parent.highlight ? root.accentColor : root.mutedColor
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - Theme.fontSizeMedium - valueText.width - parent.spacing * 2
            text: parent.label
            font.pixelSize: Theme.fontSizeSmall
            color: root.mutedColor
            elide: Text.ElideRight
        }

        StyledText {
            id: valueText
            anchors.verticalCenter: parent.verticalCenter
            text: parent.value
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Theme.fontWeightMedium
            color: parent.highlight ? root.accentColor : root.contentColor
        }
    }
}
