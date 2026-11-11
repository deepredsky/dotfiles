import QtQuick
import QtQuick.Controls
import Quickshell
import qs.components
import qs.services

// Date and time; click for a calendar and the India / Copenhagen clocks.
BarButton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Label {
        text: Theme.glyph(0xf133)
        color: Theme.pink
    }
    Label {
        text: Qt.formatDateTime(clock.date, "ddd dd HH:mm")
        color: Theme.maroon
    }

    popout: Row {
        spacing: 32

        Column {
            id: cal

            property int month: clock.date.getMonth()
            property int year: clock.date.getFullYear()

            function shift(n) {
                const d = new Date(year, month + n, 1);
                month = d.getMonth();
                year = d.getFullYear();
            }

            width: 260
            spacing: 4

            Item {
                width: parent.width
                height: monthLabel.height

                Label {
                    text: "‹"
                    color: Theme.overlay1
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: cal.shift(-1)
                    }
                }
                Label {
                    id: monthLabel
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(new Date(cal.year, cal.month, 1), "MMMM yyyy")
                    color: Theme.mauve
                }
                Label {
                    anchors.right: parent.right
                    text: "›"
                    color: Theme.overlay1
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: cal.shift(1)
                    }
                }
                WheelHandler {
                    onWheel: event => cal.shift(event.angleDelta.y > 0 ? -1 : 1)
                }
            }

            DayOfWeekRow {
                width: parent.width
                locale: Qt.locale("en_GB")
                delegate: Label {
                    required property string shortName
                    text: shortName.slice(0, 2)
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.overlay1
                    font.pixelSize: Theme.smallSize
                }
            }

            MonthGrid {
                width: parent.width
                height: 6 * 30
                month: cal.month
                year: cal.year
                locale: Qt.locale("en_GB")
                delegate: Item {
                    required property var model
                    readonly property bool today: model.today

                    implicitHeight: 30

                    Rectangle {
                        anchors.centerIn: parent
                        width: 28
                        height: 28
                        radius: 14
                        color: Theme.mauve
                        visible: parent.today
                    }
                    Label {
                        anchors.centerIn: parent
                        text: parent.model.day
                        color: parent.today ? Theme.crust : parent.model.month === cal.month ? Theme.text : Theme.surface1
                        font.pixelSize: Theme.smallSize
                        font.weight: parent.today ? Font.Bold : Font.Normal
                    }
                }
            }
        }

        ZoneCard {
            title: "India · New Delhi"
            zone: "ist"
            lat: 28.6139
            lon: 77.2090
            now: clock.date
        }

        ZoneCard {
            title: "Copenhagen"
            zone: "cet"
            lat: 55.6761
            lon: 12.5683
            now: clock.date
        }
    }
}
