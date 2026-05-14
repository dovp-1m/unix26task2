#!/bin/bash

echo "--- all linked commands ---"
ls /bin/bb-*

echo ""
echo "--- linked command tests ---"

timeout 2 /bin/bb-ls /tmp          > /dev/null 2>&1; echo "[bb-ls]     exit code: $?"
timeout 2 /bin/bb-echo "hello"     > /dev/null 2>&1; echo "[bb-echo]   exit code: $?"
timeout 2 /bin/bb-whoami           > /dev/null 2>&1; echo "[bb-whoami] exit code: $?"
timeout 2 /bin/bb-pwd              > /dev/null 2>&1; echo "[bb-pwd]    exit code: $?"
timeout 2 /bin/bb-date             > /dev/null 2>&1; echo "[bb-date]   exit code: $?"
timeout 2 /bin/bb-uname -a         > /dev/null 2>&1; echo "[bb-uname]  exit code: $?"
timeout 2 /bin/bb-cat /etc/hostname > /dev/null 2>&1; echo "[bb-cat]    exit code: $?"
timeout 2 /bin/bb-true             > /dev/null 2>&1; echo "[bb-true]   exit code: $?"
timeout 2 /bin/bb-false            > /dev/null 2>&1; echo "[bb-false]  exit code: $?"

echo ""
echo "Test complete."
