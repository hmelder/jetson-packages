prefix?=$(DESTDIR)/usr
includedir?=$(prefix)/include
pkgconfigdir?=$(prefix)/lib/aarch64-linux-gnu/pkgconfig

build:
	@#Do Nothing

.PHONY: install
install:
	mkdir -p $(includedir)/tegra
	install -m 644 include/*.h $(includedir)/tegra
	mkdir -p $(pkgconfigdir)
	install -m 644 nvbuf.pc $(pkgconfigdir)
	tar -xjpf nvidia_drivers_32_7_4.tar.bzip2 -C $(DESTDIR)