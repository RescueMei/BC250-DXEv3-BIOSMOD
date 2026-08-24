#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# SOURCE_FILE="$SCRIPT_DIR/Robin3.00"
SOURCE_FILE="$SCRIPT_DIR/BC250_3.00_CHIPSETMENU.ROM"
TARGET_FILE="$SCRIPT_DIR/BC250_3.00_MeiMeiDXEv3.ROM"
PATCH_FILE="$SCRIPT_DIR/BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta"
MD5_FILE="$SCRIPT_DIR/MD5SUMS.txt"

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: required command not found: $1" >&2
        exit 1
    fi
}

require_file() {
    if [ ! -f "$1" ]; then
        echo "Error: required file not found: $1" >&2
        exit 1
    fi
}

echo "Creating delta patch in: $SCRIPT_DIR"

require_cmd xdelta3
require_cmd md5sum
require_file "$SOURCE_FILE"
require_file "$TARGET_FILE"

rm -f "$PATCH_FILE"

echo "Generating xdelta patch..."
xdelta3 -e -s "$SOURCE_FILE" "$TARGET_FILE" "$PATCH_FILE"

echo "Generating MD5 manifest..."
(
    cd "$SCRIPT_DIR"
    md5sum \
        "BC250_3.00_CHIPSETMENU.ROM" \
        "BC250_3.00_MeiMeiDXEv3.ROM" \
        "BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta" \
        > "MD5SUMS.txt"
)

echo
echo "Done. Created:"
echo "  $PATCH_FILE"
echo "  $MD5_FILE"
echo
echo "Distribute these files:"
echo "  Apply Delta Patch.sh"
echo "  BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta"
echo "  MD5SUMS.txt"
echo "  README.txt"
