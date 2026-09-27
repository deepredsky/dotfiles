# Shared cross-platform (macOS/Linux) helpers for bin/ scripts.
# source "$(dirname "$0")/lib/platform.sh"

os_is_darwin() { [ "$(uname -s)" = "Darwin" ]; }

# Epoch seconds for a free-form date string (e.g. `ps -o lstart=` output).
date_to_epoch() {
  if os_is_darwin; then
    date -j -f '%c' "$1" +%s
  else
    date -d "$1" +%s
  fi
}

# YYYY-MM-DD for the day after the given YYYY-MM-DD date.
next_day() {
  if os_is_darwin; then
    date -j -v+1d -f '%Y-%m-%d' "$1" +%Y-%m-%d
  else
    date -d "$1 + 1 day" +%Y-%m-%d
  fi
}

# Reverse stdin line order (GNU `tac` isn't on macOS by default).
reverse_lines() {
  if command -v tac >/dev/null 2>&1; then
    tac
  else
    tail -r
  fi
}

# Best-effort desktop notification; silently does nothing if no notifier is installed.
notify() {
  title=$1
  message=$2
  if os_is_darwin; then
    command -v terminal-notifier >/dev/null 2>&1 &&
      terminal-notifier -title "$title" -message "$message" -sound default
  else
    command -v notify-send >/dev/null 2>&1 && notify-send "$title" "$message"
  fi
}

# Copy stdin to the system clipboard.
clipboard_copy() {
  if os_is_darwin; then
    pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  else
    echo "No clipboard utility found (need pbcopy, wl-copy, or xclip)" >&2
    return 1
  fi
}

# Open a URL/file with the OS default handler.
open_default() {
  if os_is_darwin; then
    open "$@"
  else
    xdg-open "$@"
  fi
}
