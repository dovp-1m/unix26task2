#!/bin/bash

PORT=3321
echo "Testing bb-httpd on port $PORT..."
echo ""

RESPONSE=$(timeout 5 /bin/bb-wget -q -O - http://localhost:$PORT/)
echo "$RESPONSE"
echo ""
echo "wget exit code: $?"

echo ""
echo "--- Content checks ---"
if echo "$RESPONSE" | grep -q "I am alive $USER"; then
    echo "[PASS] Response contains: I am alive $USER"
else
    echo "[FAIL] Missing: I am alive $USER"
fi

TODAY=$(date +%Y-%m-%d)
if echo "$RESPONSE" | grep -q "$TODAY"; then
    echo "[PASS] Response contains date: $TODAY"
else
    echo "[FAIL] Missing date: $TODAY"
fi

echo ""
echo "Service status:"
systemctl is-active bb-httpd && echo "bb-httpd is running" || echo "bb-httpd is NOT running"
