project('nv-l4t-drivers-dev', 'c', version: '32.7.4')

pkg = import('pkgconfig')

install_headers(
    'include/nvbuf_utils.h',
    'include/nvbufsurface.h',
    subdir : 'tegra',
)

install_data(
  'nvbuf.pc',
  subdir: 'pkgconfig',
)