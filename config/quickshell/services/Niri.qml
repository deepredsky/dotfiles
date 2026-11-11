pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Workspace and window state from `niri msg -j event-stream`.
Singleton {
    id: root

    property var workspaces: []
    property var windows: ({})
    property var focusedId: null
    readonly property var focusedWindow: focusedId !== null ? windows[focusedId] ?? null : null

    function action(args) {
        Quickshell.execDetached(["niri", "msg", "action"].concat(args));
    }

    function setWorkspaces(list) {
        workspaces = list.sort((a, b) => a.idx - b.idx);
    }

    function handle(ev) {
        if (ev.WorkspacesChanged) {
            setWorkspaces(ev.WorkspacesChanged.workspaces);
        } else if (ev.WorkspaceActivated) {
            const {id, focused} = ev.WorkspaceActivated;
            const output = workspaces.find(w => w.id === id)?.output;
            setWorkspaces(workspaces.map(w => Object.assign({}, w, {
                "is_active": w.output === output ? w.id === id : w.is_active,
                "is_focused": focused ? w.id === id : w.is_focused
            })));
        } else if (ev.WorkspaceUrgencyChanged) {
            const {id, urgent} = ev.WorkspaceUrgencyChanged;
            setWorkspaces(workspaces.map(w => w.id === id ? Object.assign({}, w, {
                "is_urgent": urgent
            }) : w));
        } else if (ev.WindowsChanged) {
            const map = {};
            for (const w of ev.WindowsChanged.windows) {
                map[w.id] = w;
                if (w.is_focused)
                    focusedId = w.id;
            }
            windows = map;
        } else if (ev.WindowOpenedOrChanged) {
            const w = ev.WindowOpenedOrChanged.window;
            windows = Object.assign({}, windows, {
                [w.id]: w
            });
            if (w.is_focused)
                focusedId = w.id;
        } else if (ev.WindowClosed) {
            const map = Object.assign({}, windows);
            delete map[ev.WindowClosed.id];
            windows = map;
            if (focusedId === ev.WindowClosed.id)
                focusedId = null;
        } else if (ev.WindowFocusChanged) {
            focusedId = ev.WindowFocusChanged.id;
        }
    }

    Process {
        id: stream
        running: true
        command: ["niri", "msg", "-j", "event-stream"]
        stdout: SplitParser {
            onRead: line => root.handle(JSON.parse(line))
        }
        onExited: retry.start()
    }

    Timer {
        id: retry
        interval: 2000
        onTriggered: stream.running = true
    }
}
