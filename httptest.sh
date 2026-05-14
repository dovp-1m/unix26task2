#!/bin/bash

echo "Testing bb-httpd on port 80..."
echo ""

timeout 5 /bin/bb-wget -q -O - http://localhost:80/
echo ""
echo "wget exit code: $?"

echo ""
echo "Service status:"
systemctl is-active bb-httpd && echo "bb-httpd is running" || echo "bb-httpd is NOT running"
