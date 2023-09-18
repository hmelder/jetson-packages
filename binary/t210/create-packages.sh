#!/usr/bin/env bash
    
# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function prepare_nv-l4t-drivers {
    echo "INFO: Preparing nv-l4t-drivers package"

    TARBALL="${SCRIPT_DIR}/../nvidia-bin-release/bsp/nv_tegra/nvidia_drivers.tbz2"
    DEST="${SCRIPT_DIR}/nv-l4t-drivers"
    tar xjpf $TARBALL -C $DEST

    # Move firmware files to /usr/lib, as /lib is only a symlink to /usr/lib
    # on recent Debian versions
    mkdir -p $DEST/usr/lib
    mv $DEST/lib/firmware $DEST/usr/lib
    rm -r $DEST/lib
}

function main {
    # Check if ../nvidia-bin-release/bsp exists
    if [ ! -d "${SCRIPT_DIR}/../nvidia-bin-release/bsp" ]; then
        echo "ERROR: ${SCRIPT_DIR}/nvidia-bin-release/bsp does not exist!"
        echo "Please run ./download-bsp.sh first."
        exit 1
    fi

    echo "INFO: Packaging t210 binaries for release"
    # Get all directories relative to the script directory
    dirs=("$SCRIPT_DIR"/*/)

    OUTPUT_DIR="$SCRIPT_DIR"/../packages
    mkdir -p $OUTPUT_DIR

    # Run any pre-packaging steps
    prepare_nv-l4t-drivers

    for dir in "${dirs[@]}"; do
        dpkg-deb --build $dir $OUTPUT_DIR
    done

    echo "INFO: Done! Check $OUTPUT_DIR for the packages."
}

main