#!/usr/bin/env bash
#
# Thin adapter for vimwiki's customize_wiki2html_program interface (see
# :h vimwiki-html for the argument contract vimwiki calls this with). The
# actual markdown -> HTML rendering is generic and lives in md2html.sh.

set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# ARGUMENT PARSING (vimwiki's fixed positional interface; args 2, 3, 6-9 are
# accepted because vimwiki always passes them, but unused here -- this wiki
# is rendered with a single fixed template/theme regardless of wiki-local
# settings)
OVERWRITE="$1"     # Do not overwrite (0) or overwrite (1)
OUTPUTDIR="$4"      # Full path of the output directory
INPUT="$5"          # Full path of the wiki page
ROOT_PATH="${10}"   # Count of '../' for pages buried in subdirs, or '-'

# Example: index.md -> index
FILENAME="$(basename "$INPUT")"
FILENAME="${FILENAME%.*}"
OUTPUT="$OUTPUTDIR$FILENAME"

# Skip regeneration if not overwriting and output already exists
[[ "$OVERWRITE" = 0 && -f "$OUTPUT.html" ]] && exit 0

exec "$SCRIPT_DIR/md2html.sh" "$INPUT" "$OUTPUTDIR" "$ROOT_PATH"
