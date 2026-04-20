#!/bin/bash
set -e

BUSYBOX_BIN="/opt/task2/src/busybox-1.36.1/busybox"
TARGET="/bin/busybox-static"

# Copy binary
cp "$BUSYBOX_BIN" "$TARGET"
chmod +x "$TARGET"

# Create symlinks for every applet
for cmd in $("$TARGET" --list); do
    ln -sf "$TARGET" "/bin/bb-${cmd}"
    echo "Linked: /bin/bb-${cmd}"
done

echo "Deploy complete."
