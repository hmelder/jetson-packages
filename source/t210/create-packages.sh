#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENABLED_PACKAGES=("nv-gstreamer1.0-nvvidconv", "nv-gstreamer1.0-v4l2")

# Arguments: PACKAGE_DIR
function build_package {
    PACKAGE_DIR=$1

    echo "Building package $PACKAGE_DIR"

    # Build the package with pbuilder
}

function main {
    echo "INFO: Building sources for release"
}