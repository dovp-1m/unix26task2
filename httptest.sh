#!/bin/bash

PORT=3321
EXPECTED_USER="$USER"
EXPECTED_DATE=$(date +%Y-%m-%d)

echo "Testing bb-httpd on port $PORT..."
echo ""

RESPONSE=$(timeout 5 /bin/bb-wget -q -O - http://localhost:$PORT/)
WGET_EXIT=$?

echo "$RESPONSE"
echo ""
echo "wget exit code: $WGET_EXIT"

echo ""
echo "--- Content checks ---"

if echo "$RESPONSE" | grep -q "I am alive $EXPECTED_USER"; then
    echo "[PASS] Response contains: I am alive $EXPECTED_USER"
else
    echo "[FAIL] Missing: I am alive $EXPECTED_USER"
fi

if echo "$RESPONSE" | grep -q "$EXPECTED_DATE"; then
    echo "[PASS] Response contains date: $EXPECTED_DATE"
else
    echo "[FAIL] Missing date: $EXPECTED_DATE"
fi

echo ""
echo "Service status:"
systemctl is-active bb-httpd && echo "bb-httpd is running" || echo "bb-httpd is NOT running"
