import QtQuick
import qs.components
import qs.services

// Hottest sensor on the bar, all of them on click.
BarButton {
    Label {
        text: Theme.glyph(0xf2c9) + " " + Stats.tempSummary
        color: Stats.tempCritical ? Theme.red : Theme.peach
    }

    popout: Column {
        width: 200
        spacing: 2

        Heading {
            text: "Temperatures"
            topPadding: 0
        }
        Repeater {
            model: Stats.temps
            Label {
                required property string modelData
                text: modelData
                font.pixelSize: Theme.smallSize
                font.weight: Font.Normal
            }
        }
    }
}
