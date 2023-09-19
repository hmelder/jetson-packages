# Arguments BSP_DIR PKG_DIR
function preparePkg {
    bspDir=$1
    pkgDir=$2

    echo "* SPEC: Preparing package ${pkgDir}"

    nvDriverTarball="${bspDir}/nv_tegra/nvidia_drivers.tbz2"

    echo "* SPEC: Extracting ${nvDriverTarball} into ${pkgDir}"
    tar -xjpf ${nvDriverTarball} -C ${pkgDir}
    if test $? -ne 0; then
        echo "ERROR: Failed to extract ${nvDriverTarball}"
        return 1
    fi

    # Move firmware files to /usr/lib, as /lib is only a symlink to /usr/lib
    # on recent Debian versions
    echo "* SPEC: Moving firmware files to /usr/lib"
    mkdir -p $pkgDir/usr/lib
    mv $pkgDir/lib/firmware $pkgDir/usr/lib
    rm -r $pkgDir/lib

    # Add Nvidia lib directory to ld configuration
    echo "/usr/lib/aarch64-linux-gnu/tegra" >> ${pkgDir}/etc/ld.so.conf.d/nvidia-tegra.conf

    # Create md5sums file
    echo "* SPEC: Creating md5sums file"
    find ${pkgDir} -type f ! -path "${pkgDir}/DEBIAN/*" -exec md5sum {} \; > ${pkgDir}/DEBIAN/md5sums

    # Fix permissions
    echo "* SPEC: Fixing permissions"
    chown -R root:root ${pkgDir}/DEBIAN
    chmod 755 ${pkgDir}/DEBIAN
    chmod 644 ${pkgDir}/DEBIAN/control

    return 0
}

# Arguments PKG_DIR
function cleanPkg {
    pkgDir=$1

    echo "* SPEC: Cleaning package ${pkgDir}"
    rm -r ${pkgDir}/etc
    rm -r ${pkgDir}/usr
    rm -r ${pkgDir}/var
    rm ${pkgDir}/DEBIAN/md5sums
    
    return 0;
}