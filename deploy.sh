#!/bin/bash
set -e

BUSYBOX_BIN="/opt/task2/src/busybox-1.36.1/_install/bin/busybox"
TARGET="/opt/task2/busybox-static"
PORT=3321
WWW_DIR="/opt/task2/www"
mkdir -p "$WWW_DIR"

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
cat > "$WWW_DIR/index.html" <<EOF
I am alive $USER
Date: $(date +%Y-%m-%d)
EOF

cat > /etc/systemd/system/bb-httpd.service <<EOF
[Unit]
Description=BusyBox HTTPD
After=network.target

[Service]
ExecStart=/opt/task2/busybox-static httpd -f -p $PORT -h $WWW_DIR
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable bb-httpd
systemctl restart bb-httpd
echo "httpd listening on port $PORT, serving $WWW_DIR"
