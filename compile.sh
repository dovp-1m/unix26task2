#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./compile.sh"
    exit 1
fi

if ! command -v gcc &>/dev/null || ! command -v make &>/dev/null; then
    echo "Installing build dependencies..."
    apt-get install -y build-essential libncurses-dev
fi

VERSION="1.36.1"
SRC_DIR="/opt/task2/src"

mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

if [ ! -f "busybox-${version}.tar.bz2" ]; then
	wget "https://busybox.net/downloads/busybox-${VERSION}.tar.bz2"
fi

if [ ! -d "busybox-{VERSION}" ]; then
	tar -xjf "busybox-${VERSION}.tar.bz2"
fi

cd "busybox-${VERSION}"

make defconfig

sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/' .config

make -j$(nproc)
make install CONFIG_PREFIX="$SRC_DIR/busybox-${VERSION}/_install"

echo "Build complete: $(pwd)/busybox"
echo "Binary: $SRC_DIR/busybox-${VERSION}/_install/bin/busybox"

file "$SRC_DIR/busybox-${VERSION}/_install/bin/busybox"
