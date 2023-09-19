project('gstnvvideo4linux2', 'c', version: '1.14.0')

glib_dep = dependency('glib-2.0')
libv4l2_dep = dependency('libv4l2')
gstreamer_dep = dependency('gstreamer-1.0')
gstreamer_base_dep = dependency('gstreamer-base-1.0')
gstreamer_video_dep = dependency('gstreamer-video-1.0')
gstreamer_allocators_dep = dependency('gstreamer-allocators-1.0')
nvbuf_dep = dependency('nvbuf')

add_project_arguments(
  '-DEXPLICITLY_ADDED=1',
  '-DGETTEXT_PACKAGE=1',
  '-DHAVE_LIBV4L2=1',
  '-DUSE_V4L2_TARGET_NV=1',
  language: 'c',
)

sources = [
    'gstv4l2allocator.c',
    'gstv4l2bufferpool.c',
    'gstv4l2.c',
    'gstv4l2h264enc.c',
    'gstv4l2h265enc.c',
    'gstv4l2object.c',
    'gstv4l2videodec.c',
    'gstv4l2videoenc.c',
    'gstv4l2vp8enc.c',
    'gstv4l2vp9enc.c',
    'v4l2_calls.c',
    'v4l2-utils.c',
]

dependencies = [
    glib_dep,
    libv4l2_dep,
    gstreamer_dep,
    gstreamer_base_dep,
    gstreamer_video_dep,
    gstreamer_allocators_dep,
    nvbuf_dep,
]

gstreamer_install_dir = '/usr/lib/aarch64-linux-gnu/gstreamer-1.0'

gstnvvideo4linux2 = shared_library(
    'gstnvvideo4linux2',
    sources,
    dependencies: dependencies,
    install: true,
    install_dir: gstreamer_install_dir,
)