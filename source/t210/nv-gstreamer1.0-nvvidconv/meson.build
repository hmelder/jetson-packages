project('gstnvvidconv', 'c', version: '1.2.3')

glib_dep = dependency('glib-2.0')
gstreamer_dep = dependency('gstreamer-1.0')
gstreamer_base_dep = dependency('gstreamer-base-1.0')
gstreamer_video_dep = dependency('gstreamer-video-1.0')
gstreamer_allocators_dep = dependency('gstreamer-allocators-1.0')
nvbuf_dep = dependency('nvbuf')

sources = ['gstnvvconv.c']
dependencies = [
    glib_dep,
    gstreamer_dep,
    gstreamer_base_dep,
    gstreamer_video_dep,
    gstreamer_allocators_dep,
    nvbuf_dep,
]

gstreamer_install_dir = '/usr/lib/aarch64-linux-gnu/gstreamer-1.0'

shared_library(
    'gstnvvidconv',
    sources,
    dependencies: dependencies,
    install : true,
    install_dir : gstreamer_install_dir,
)