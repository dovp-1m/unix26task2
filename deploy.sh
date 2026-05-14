#!/bin/bash
set -e

BUSYBOX_BIN="/opt/task2/src/busybox-1.36.1/_install/bin/busybox"
TARGET="/opt/task2/busybox-static"
HTTPD_PORT=3321
WEBROOT="/opt/task2/www"

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

echo "Wrappers deployed."

# --- httpd setup ---
mkdir -p "$WEBROOT"

TODAY=$(date +%Y-%m-%d)
cat > "$WEBROOT/index.html" <<EOF
I am alive $USER
Date: $TODAY
EOF

# Stop any running instance first
systemctl stop bb-httpd 2>/dev/null || true

# Create systemd service
cat > /etc/systemd/system/bb-httpd.service <<EOF
[Unit]
Description=BusyBox httpd on port $HTTPD_PORT

[Service]
ExecStart=$TARGET httpd -f -p $HTTPD_PORT -h $WEBROOT
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable bb-httpd
systemctl start bb-httpd

echo "Deploy complete. httpd listening on port $HTTPD_PORT"
echo "Serving: $(cat $WEBROOT/index.html)"
