plugin_LTLIBRARIES = libgstnveglglessink.la

DISTRO_SRC = gstegladaptation_egl.c video_platform_wrapper.c
GST_EGL_LIBS = $(top_builddir)/gst-libs/gst/egl/libgstegl-$(GST_API_VERSION).la

libgstnveglglessink_la_SOURCES = gsteglglessink.c gstegladaptation.c $(DISTRO_SRC)

libgstnveglglessink_la_CFLAGS = $(GST_PLUGINS_BAD_CFLAGS) \
			      $(GST_PLUGINS_BASE_CFLAGS) \
                              $(GST_BASE_CFLAGS) \
                              $(GST_CFLAGS) \
                              $(EGL_CFLAGS) \
                              $(EGLGLES_CFLAGS) -DUSE_EGL_TEGRA
libgstnveglglessink_la_OBJCFLAGS = $(GST_PLUGINS_BAD_OBJCFLAGS) \
                                 $(GST_PLUGINS_BASE_OBJCFLAGS) \
                                 $(GST_BASE_OBJCFLAGS) \
                                 $(GST_OBJCFLAGS) \
                                 $(EGLGLES_OBJCFLAGS) \
                                 -fobjc-abi-version=2 -fobjc-legacy-dispatch

libgstnveglglessink_la_LIBADD = $(GST_LIBS) $(GST_BASE_LIBS) \
	$(GST_PLUGINS_BASE_LIBS) $(EGL_LIBS) $(EGLGLES_LIBS) \
	-lgstvideo-$(GST_API_VERSION) $(GST_EGL_LIBS)

libgstnveglglessink_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)

libgstnveglglessink_la_LIBTOOLFLAGS = --tag=CC $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = gsteglglessink.h gstegladaptation.h video_platform_wrapper.h

EXTRA_DIST = gsteglglessink.c gstegladaptation.c gstegladaptation_egl.c video_platform_wrapper.c gstegladaptation_eagl.m $(noinst_HEADERS)
