import subprocess
import os
import tempfile

SCRIPT_NAME = 'editor'
SCRIPT_AUTHOR = 'Steve Losh <steve@stevelosh.com>'
SCRIPT_VERSION = '1.0'
SCRIPT_LICENSE = 'MIT/X11'
SCRIPT_DESC = 'Launch an external editor to compose a message'
SCRIPT_COMMAND = 'editor'

import_ok = True

EDITOR = os.environ.get('EDITOR','vim')

try:
    import weechat
except ImportError:
    print 'This is a weechat script, what are you doing, run it in weechat, jesus'
    import_ok = False

weechat_version = 0


def get_data(suffix, initial_data):
    with tempfile.NamedTemporaryFile(suffix=".%s" % suffix, mode="w+") as tf:
        tf.write(initial_data)
        tf.flush()

        if subprocess.call([EDITOR, tf.name]) != 0:
            return None

        # Reopen, because most editors do atomic write-tmp+rename saves which
        # fucks with Python here.
        tf.file.close()
        tf = file(tf.name)

        return tf.readlines()

def editor(data, buffer, args):
    suffix = args or "tmp"

    line = weechat.buffer_get_string(buffer, "input")

    data = get_data(suffix, line)
    if data:
        weechat.command(buffer, "/input delete_line")

        for line in data:
            weechat.command(buffer, line)

    weechat.command("", "/window refresh")

    return weechat.WEECHAT_RC_OK


if __name__ == '__main__' and import_ok:
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION,
                        SCRIPT_LICENSE, SCRIPT_DESC, '', ''):
        weechat_version = weechat.info_get('version_number', '') or 0
        weechat.hook_command(
            SCRIPT_COMMAND,
            'Open $EDITOR to compose a message',
            '[file-extension]',
            'If an argument is given, it will be used as the extension for the temporary file.',
            '',
            'editor',
            '')
