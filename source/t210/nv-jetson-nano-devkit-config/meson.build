project('nv-jetson-nano-devkit-config', 'c', version: '0.1.0')

install_data(
    'extlinux.conf',
    install_dir: join_paths(get_option('prefix'), 'boot/extlinux'),
)

install_data(
    'nv_boot_control.conf',
    install_dir: join_paths(get_option('prefix'), 'etc'),
)