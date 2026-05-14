#!/bin/bash

PORT=3321
echo "Testing bb-httpd on port $PORT..."
echo ""

RESPONSE=$(timeout 5 /bin/bb-wget -q -O - http://localhost:$PORT/)
echo "$RESPONSE"
echo ""
echo "wget exit code: $?"

echo ""
echo "Service status:"
systemctl is-active bb-httpd && echo "bb-httpd is running" || echo "bb-httpd is NOT running"
