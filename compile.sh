#!/bin/bash
set -e

VERSION="1.36.1"
SRC_DIR="/opt/task2/src"
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

# Download source
wget "https://busybox.net/downloads/busybox-${VERSION}.tar.bz2"
tar -xjf "busybox-${VERSION}.tar.bz2"
cd "busybox-${VERSION}"

# Configure: default config, then enable static linking
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

# Build
make -j$(nproc) LDFLAGS="--static"

echo "Build complete: $(pwd)/busybox"
