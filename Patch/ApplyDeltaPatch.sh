#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

SOURCE_FILE="$SCRIPT_DIR/BC250_3.00_CHIPSETMENU.ROM"
PATCH_FILE="$SCRIPT_DIR/BC250_3.00_CHIPSETMENU-to-BC250_3.00_MeiMeiDXEv3.xdelta"
OUTPUT_FILE="$SCRIPT_DIR/BC250_3.00_MeiMeiDXEv3.ROM"
MD5_FILE="$SCRIPT_DIR/MD5SUMS.txt"
TEMP_FILE="$SCRIPT_DIR/BC250_3_MeiMeiDXEv2.tmp"

EXPECTED_SOURCE_MD5="d298267029fbbe9d29b0bfa0db5fbf9e"
EXPECTED_OUTPUT_MD5="38b7f947d6d0fd7e296485524ccd8967"

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

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

echo "Applying delta patch in: $SCRIPT_DIR"

require_cmd xdelta3
require_cmd md5sum
require_file "$SOURCE_FILE"
require_file "$PATCH_FILE"
require_file "$MD5_FILE"

echo "Verifying source file MD5..."
ACTUAL_SOURCE_MD5="$(md5sum "$SOURCE_FILE" | awk '{print $1}')"
if [ "$ACTUAL_SOURCE_MD5" != "$EXPECTED_SOURCE_MD5" ]; then
    echo "Error: BC250_3.00_CHIPSETMENU MD5 mismatch." >&2
    echo "Expected: $EXPECTED_SOURCE_MD5" >&2
    echo "Actual:   $ACTUAL_SOURCE_MD5" >&2
    exit 1
fi

echo "Applying patch..."
rm -f "$TEMP_FILE"
xdelta3 -d -f -s "$SOURCE_FILE" "$PATCH_FILE" "$TEMP_FILE"

echo "Verifying patched output MD5..."
ACTUAL_OUTPUT_MD5="$(md5sum "$TEMP_FILE" | awk '{print $1}')"
if [ "$ACTUAL_OUTPUT_MD5" != "$EXPECTED_OUTPUT_MD5" ]; then
    echo "Error: patched output MD5 mismatch." >&2
    echo "Expected: $EXPECTED_OUTPUT_MD5" >&2
    echo "Actual:   $ACTUAL_OUTPUT_MD5" >&2
    exit 1
fi

mv -f "$TEMP_FILE" "$OUTPUT_FILE"

echo
echo "Done. Wrote:"
echo "  $OUTPUT_FILE"
echo "Verified MD5: $EXPECTED_OUTPUT_MD5"
echo
echo "Do not flash unless the checksum matches MD5SUMS.txt."
