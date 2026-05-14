#!/bin/bash
set -e

BUSYBOX_BIN="/opt/task2/src/busybox-1.36.1/_install/bin/busybox"
TARGET="/opt/task2/busybox-static"

if ! file "$BUSYBOX_BIN" | grep -q "ELF"; then
	echo "$BUSYBOX_BIN is not a valid ELF binary. Run compile.sh first."
	exit 1
fi
APPLETS=$("$BUSYBOX_BIN" --list)

cp "$BUSYBOX_BIN" "$TARGET"
chmod +x "$TARGET"
echo "Deployed binary: $(file $TARGET)"

for cmd in $APPLETS; do
	[[ "$cmd" =~ ^[a-zA-Z0-9_-]+$ ]] || continue
	printf '#!/bin/bash\nexec %s %s "$@"\n' "$TARGET" "$cmd" > "/bin/bb-${cmd}"
	chmod +x "/bin/bb-${cmd}"
done

echo "Deploy complete."
