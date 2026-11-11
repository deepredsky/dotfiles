pragma Singleton
import QtQuick
import Quickshell

// One popout at a time; the bar's overlay window renders `content` under `item`.
Singleton {
    property Item item: null
    property Component content: null

    function toggle(i, c) {
        if (item === i) {
            close();
        } else {
            item = i;
            content = c;
        }
    }

    function close() {
        item = null;
        content = null;
    }
}
