#!/usr/bin/env bash
set -e

BUILD_DIR="build"
FLASH_ADDR="0x08000000"

if [ $# -ne 1 ]; then
    echo "Usage: $0 {tx|rx}"
    echo "  tx - Flash the transmitter firmware"
    echo "  rx - Flash the receiver firmware"
    exit 1
fi

TARGET=$1
BIN_PATH="$BUILD_DIR/${TARGET}.bin"

if [ "$TARGET" != "tx" ] && [ "$TARGET" != "rx" ]; then
    echo "Error: Invalid target '$TARGET'. Use 'tx' or 'rx'."
    exit 1
fi

if [ ! -f "$BIN_PATH" ]; then
    echo "Error: Binary '$BIN_PATH' not found."
    echo "Please run 'make' first to build the project."
    exit 1
fi

echo "==> Flashing $TARGET firmware to Nucleo board..."
st-flash write "$BIN_PATH" "$FLASH_ADDR"
echo "==> Done! $TARGET is successfully flashed."
