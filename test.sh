#!/bin/bash

echo "=== BusyBox linked commands ==="
/bin/busybox-static --list | while read cmd; do
    echo "/bin/bb-${cmd}"
done

echo ""
echo "=== Sample command tests ==="

run_test() {
    local label="$1"
    shift
    "$@" > /dev/null 2>&1
    echo "[$label] exit code: $?"
}

run_test "bb-ls"      /bin/bb-ls /tmp
run_test "bb-echo"    /bin/bb-echo "hello"
run_test "bb-whoami"  /bin/bb-whoami
run_test "bb-pwd"     /bin/bb-pwd
run_test "bb-date"    /bin/bb-date
run_test "bb-uname"   /bin/bb-uname -a
run_test "bb-cat"     /bin/bb-cat /etc/hostname
run_test "bb-true"    /bin/bb-true
run_test "bb-false"   /bin/bb-false

echo ""
echo "Test run complete."
