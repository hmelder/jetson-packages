#!/bin/bash
# Description: Common variables and functions for all scripts

# Get the directory where the script is located
L4T_VERSION="32.7.4"
BSP_DOWNLOAD_URL="https://developer.nvidia.com/downloads/embedded/l4t/r32_release_v7.4/t210/jetson-210_linux_r32.7.4_aarch64.tbz2"

DEST="${SCRIPT_DIR}/../nvidia-bin-release"
BSP_TARBALL_DEST="${DEST}/bsp.tar.bz2"
UNPACKED_DEST="${DEST}/bsp"

SOURCE_T210_DIR="${SCRIPT_DIR}/../source/t210"
SOURCE_DEB_DIR="$SOURCE_T210_DIR/debian-desc"

BINARY_T210_DIR="${SCRIPT_DIR}/../binary/t210"

# Build only this package
ONLY_PKG=""
VERBOSE=1

# Debian building configuration
PBUILDER_DIR="${SCRIPT_DIR}/../pbuilder"
PBUILDER_CONFIG="${PBUILDER_DIR}/pbuilderrc"
PBUILDER_BASE_TGZ="${PBUILDER_DIR}/base-${DEBIAN_RELEASE}-${ARCHITECTURE}.tgz"
PBUILDER_RESULT="/var/cache/pbuilder/result"
PBUILDER_DEFAULT_ARGS="--basetgz ${PBUILDER_BASE_TGZ} --distribution ${DEBIAN_RELEASE} --architecture ${ARCHITECTURE} --configfile ${PBUILDER_CONFIG} --hookdir ${PBUILDER_DIR}/hooks"
PBUILDER_SKIP_UPDATE=0

# Debian release version. By default the unstable version (sid) is used.
DEBIAN_RELEASE="sid"
ARCHITECTURE=arm64