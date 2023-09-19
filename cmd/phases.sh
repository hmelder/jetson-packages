#!/usr/bin/env bash

# pbuilder is not smart enough to resolve local dependencies automatically
# Additionally, we have binary packages that need to be patched and build differently (dpkg-deb)
BUILD_PHASES_ARRAY=(
    "nv-l4t-drivers"
    "nv-l4t-drivers-dev"
    "nv-jetson-nano-devkit-config"
    "nv-gstreamer1.0-nvvidconv"
    "nv-gstreamer1.0-v4l2"
)