#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Local Options
ONLY_SOURCE_PKGS=0
ONLY_BINARY_PKGS=0

# Import common variables and functions
source ${SCRIPT_DIR}/common.sh
if test $VERBOSE -eq 1; then
    echo "DEBUG: Sourced ${SCRIPT_DIR}/common.sh"
fi

# Import Source Package Builder
source ${SCRIPT_DIR}/deb-build-packages.sh
if test $VERBOSE -eq 1; then
    echo "DEBUG: Sourced ${SCRIPT_DIR}/deb-source-packages.sh"
fi

# Check if the script is run as root
function checkRootNoFail {
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: This script must be run as root!"
        exit 1
    fi
}

# Check if all required binaries are installed.
# I do not understand why nobody does this when writing a shell script -_-
function checkRTDependenciesNoFail {
    # Check if pbuilder is installed
    if ! command -v pbuilder &> /dev/null; then
        echo "ERROR: pbuilder is not installed!"
        echo "ERROR: Install it with 'sudo apt install pbuilder'"
        exit 1
    fi
    # Check if we can create local debian repositories
    if ! command -v apt-ftparchive &> /dev/null; then
        echo "ERROR: apt-ftparchive is not installed! We need to create local debian repositories!"
        echo "ERROR: Install it with 'sudo apt install apt-utils'"
        exit 1
    fi
    # Check if tar is installed
    if ! command -v tar &> /dev/null; then
        echo "ERROR: tar is not installed!"
        exit 1
    fi
    # Check if wget is installed
    if ! command -v wget &> /dev/null; then
        echo "ERROR: wget is not installed!"
        exit 1
    fi
}

# Download the driver package (BSP) from the Nvidia website
function downloadBSP {
    wget -O ${BSP_TARBALL_DEST} ${BSP_DOWNLOAD_URL}
    return $?
}

# Unpack the BSP tarball to nvidia-bin-release/bsp
function unpackBSP {
    tar --strip-components=1 -xjf ${BSP_TARBALL_DEST} -C ${UNPACKED_DEST}
    return $?
}

function usage {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help: Show this help message"
    echo "  -s, --only-source-pkgs: Only build the source packages"
    echo "  -b, --only-binary-pkgs: Only build the binary packages (Binaries extracted from the BSP and repackaged as deb packages)"
    echo "  -r, --release: Release version of the debian rootfs using for building the packages. Default: ${DEBIAN_RELEASE}"
    echo "  -a, --architecture: Architecture to build the packages for. Default: ${ARCHITECTURE}"
    echo "  -o, --only-pkg: Only build the specified package"
    echo "  -u, --skip-update: Skip updating the pbuilder base tarball"
}

function main {
    checkRootNoFail
    checkRTDependenciesNoFail
    echo "INFO: All runtime dependencies are installed and running with root privileges! Continuing..."
    echo "INFO: Configured L4T version: ${L4T_VERSION}"

    # Check if ../nvidia-bin-release/bsp exists
    if test ! -d "${SCRIPT_DIR}/../nvidia-bin-release/bsp"; then
        echo "INFO: ${SCRIPT_DIR}/../nvidia-bin-release/bsp does not exist! Downloading BSP..."

        mkdir -p ${UNPACKED_DEST}
        if ! downloadBSP; then
            echo "ERROR: Failed to download BSP!"
            exit 1
        fi

        if ! unpackBSP; then
            echo "ERROR: Failed to unpack BSP!"
            exit 1
        fi
    else
        echo "INFO: ${SCRIPT_DIR}/../nvidia-bin-release/bsp exists! Skipping BSP download..."
    fi

    if test $ONLY_BINARY_PKGS -eq 0; then
        if ! buildPackagesT210; then
            echo "ERROR: Failed to build source packages!"
            exit 1
        fi
    fi
}


# Parse options using a while loop and case statement
while (( "$#" )); do
case "$1" in
    -h | --help)
    usage
    exit 0
    ;;
    -s | --only-source-pkgs)
    ONLY_SOURCE_PKGS=1
    shift
    ;;
    -b | --only-binary-pkgs)
    ONLY_BINARY_PKGS=1
    shift
    ;;
    -u | --skip-update)
    PBUILDER_SKIP_UPDATE=1
    shift
    ;;
    -r|--release)
    if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        DEBIAN_RELEASE=$2
        shift 2
    else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
    fi
    ;;
    -a|--architecture)
    if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ARCHITECTURE=$2
        shift 2
    else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
    fi
    ;;
    -o| --only-pkg)
    if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ONLY_PKG=$2
        shift 2
    else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
    fi
    ;;
    -*|--*=) # unsupported flags
    echo "Error: Unsupported flag $1" >&2
    exit 1
    ;;
    *) # preserve positional arguments
    shift
    ;;
esac
done

# Run main function
main