import QtQuick
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins
import qs.Modules.ControlCenter.Details
import qs.Services

PluginComponent {
    id: root

    horizontalBarPill: Component {
        DIcon {
            name: AudioService.sinkVolumeIconName
            size: root.iconSize
            color: Theme.widgetIconColor

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    const audio = AudioService.sink?.audio;
                    if (!audio)
                        return;
                    const step = event.angleDelta.y > 0 ? 0.05 : -0.05;
                    const max = (AudioService.sinkMaxVolume ?? 100) / 100;
                    audio.volume = Math.max(0, Math.min(max, audio.volume + step));
                }
            }
        }
    }
    verticalBarPill: horizontalBarPill

    popoutWidth: 420
    popoutHeight: 380
    popoutContent: Component {
        PopoutComponent {
            headerText: "Sound"
            AudioOutputDetail {
                width: parent.width
                height: 320
            }
        }
    }
}
