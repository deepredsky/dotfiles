#!/usr/bin/env bash
#
# Render a single Markdown file to a standalone, styled HTML file using
# pandoc + the pandoc-markdown-css-theme theme + the pandoc-sidenote lua
# filter. Not vimwiki-specific -- works on any GFM markdown file. vimwiki
# integration lives in wiki2html.sh, which is a thin wrapper around this.
#
# This is heavily based on this code here:
# https://gist.github.com/maikeldotuk/54a91c21ed9623705fdce7bab2989742
# Which is heavily based on this code here:
# https://gist.github.com/enpassant/0496e3db19e32e110edca03647c36541
# Special thank you to the user enpassant for starting it https://github.com/enpassant
#
# Usage: md2html.sh <input.md> [outputdir] [root_path]
#
#   input.md    Path to the markdown file to render.
#   outputdir   Directory to write <name>.html into. Defaults to the
#               input file's own directory.
#   root_path   Value for pandoc's $root_path$ template variable (count of
#               '../' needed to reach the wiki base dir); '-' or omitted
#               means empty. Only relevant to nested-page templates.
#
# Override the template/theme without editing this file:
#   MD2HTML_TEMPLATE, MD2HTML_THEME_CSS, MD2HTML_HIGHLIGHT_CSS

set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

usage() {
  echo "usage: $0 <input.md> [outputdir] [root_path]" >&2
}

INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
  usage
  exit 1
fi

OUTPUTDIR="${2:-$(dirname "$INPUT")/}"
[[ "$OUTPUTDIR" != */ ]] && OUTPUTDIR="$OUTPUTDIR/"

ROOT_PATH="${3:-}"
[[ "$ROOT_PATH" = "-" ]] && ROOT_PATH=''

TEMPLATE="${MD2HTML_TEMPLATE:-$HOME/dev/wiki/template.html}"
THEME_CSS="${MD2HTML_THEME_CSS:-$HOME/dev/pandoc-markdown-css-theme/public/css/theme.css}"
HIGHLIGHT_CSS="${MD2HTML_HIGHLIGHT_CSS:-$HOME/dev/pandoc-markdown-css-theme/public/css/skylighting-modern-theme.css}"

# Example: index.md -> index
BASENAME=$(basename "$INPUT")
FILENAME="${BASENAME%.*}"
# Example: /home/rattletat/wiki/html/uni/index
OUTPUT="$OUTPUTDIR$FILENAME"

# PANDOC ARGUMENTS

# If you have Mathjax locally use this:
# MATHJAX="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
# MATHJAX="/usr/share/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

# PREPANDOC PROCESSING AND PANDOC
pandoc_template=( pandoc \
    --template="$TEMPLATE" \
    --from gfm \
    # --filter d2-filter
    --lua-filter="$SCRIPT_DIR/pandoc-sidenote.lua" \
    --to html5+smart \
    --toc \
    --wrap=none \
    --css="$THEME_CSS" \
    --css="$HIGHLIGHT_CSS" \
    -M root_path:"$ROOT_PATH" )

# Searches for markdown links (without extension or .md) and appends a .html.
# Image links (![...](...)) are protected first so their targets are left alone.
regex_protect_images='s/!\[/@@IMG@@/g'
regex1='s/(\[[^][]+\])\(([^().]+)(\.md)?\)/\1(\2.html)/g'
regex_restore_images='s/@@IMG@@/![/g'
# Removes placeholder title from vimwiki markdown file. Not needed if you use a
# correct YAML header.
# regex2='s/^%title (.+)$/---\ntitle: \1\n---/'

# POSTPANDOC PROCESSING

# Removes "file" from ![pic of sharks](file:../sharks.jpg)
regex3='s/file://g'

mkdir -p "$OUTPUTDIR"

sed -E "$regex_protect_images" "$INPUT" \
    | sed -E "$regex1" \
    | sed -E "$regex_restore_images" \
    | "${pandoc_template[@]}" \
    | sed -E "$regex3" > "$OUTPUT.html"

# With this you can have ![pic of sharks](file:../sharks.jpg) in your markdown file and it removes "file"
# and the unnecesary dot html that the previous command added to the image.
# sed 's/file://g' < /tmp/crap.html | sed 's/\(png\|jpg\|pdf\).html/\1/g' | sed -e 's/\(href=".*\)\.html/\1/g' > "$OUTPUT.html"

# Copy relative
# destination=$(cd -- "$4" && pwd) # make it an absolute path
# cd -- "/home/rattletat/wiki/text/" &&
    # find . -type f -regex ".*\.\(jpg\|gif\|png\|jpg\)" -exec cp {} "$destination/{}"
