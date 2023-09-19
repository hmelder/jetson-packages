project('nv-l4t-drivers-dev', 'c', version: '32.7.4')

pkg = import('pkgconfig')

install_headers(
    'include/nvbuf_utils.h',
    'include/nvbufsurface.h',
    subdir : 'tegra',
)

libdir = '/usr/lib/aarch64-linux-gnu/tegra'
includedir = join_paths(get_option('prefix'), 'include', 'tegra')

pkg.generate(
  name : 'nvbuf',
  description : 'Nvidia Buffer Utilities and Surface Libraries',
  version : meson.project_version(),
  libdirs : [libdir],
  includedir : includedir,
  libraries : ['nvbuf_utils', 'nvbufsurface'],
)