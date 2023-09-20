prefix?=$(DESTDIR)/usr
includedir?=$(prefix)/include
pkgconfigdir?=$(prefix)/lib/aarch64-linux-gnu/pkgconfig

build:
	@#Do Nothing

.PHONY: install
install:
# Our additions
	mkdir -p $(includedir)/tegra
	install -m 644 include/*.h $(includedir)/tegra
	mkdir -p $(pkgconfigdir)
	install -m 644 nvbuf.pc $(pkgconfigdir)
# Extract Nvidia Drivers (/lib/firmware was moved to /usr/lib/firmware)
	tar -xjpf nvidia_drivers_32_7_4.tar.bzip2 -C $(DESTDIR)
# Override ld.so.conf.d entry as the one in the Nvidia tarball is missing the multiarch dir
	cp nvidia-tegra.conf $(DESTDIR)/etc/ld.so.conf.d/nvidia-tegra.conf