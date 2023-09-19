project('nv-l4t-drivers-dev', 'c', version: '32.7.4')

pkg = import('pkgconfig')

install_headers(
    'include/nvbuf_utils.h',
    'include/nvbufsurface.h',
    subdir : 'tegra',
)

pkgconfig_dir = join_paths(get_option('prefix'), get_option('libdir'), 'pkgconfig')
install_data('nvbuf.pc', install_dir: pkgconfig_dir)