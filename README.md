# jetson-gstreamer
Nvidia Jetson GStreamer sources from v32.x.x Jetson Linux

Broken:
- gst-nvcompositor: The GstVideoAggregator interface was unstable at the time this plugin was developed,
    and has since been changed. Additionally, Nvidia used private interfaces which disappeared completely.
    This plugin will need to be updated to work with the new interface.
    Note: The plugin was adapted by nvidia in the L4T 35.x.x releases, but uses a different set of
    private Nvidia APIs that are not available in the 32.x.x releases.
    Cherry-picking the changes might work.