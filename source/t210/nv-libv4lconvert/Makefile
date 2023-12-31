###############################################################################
#
# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#
###############################################################################

SO_NAME := libnvv4lconvert.so
DEST_DIR ?= /usr/lib/aarch64-linux-gnu/tegra

SRCS := libv4lconvert.c tinyjpeg.c sn9c10x.c sn9c20x.c pac207.c  mr97310a.c \
	flip.c crop.c jidctflt.c spca561-decompress.c \
	rgbyuv.c sn9c2028-decomp.c spca501.c sq905c.c bayer.c hm12.c \
	stv0680.c cpia1.c se401.c jpgl.c jpeg.c jl2005bcd.c helper.c \
	$(wildcard processing/*.c) \
	$(wildcard control/*.c)

INCLUDES += -I./ -I../include -I./control -I./processing

OBJS := $(SRCS:.c=.o)

CFLAGS := -fPIC

MACHINE = $(shell uname -m)

ifeq ($(MACHINE),x86-64)
	CFLAGS += -DLIBV4L2_PLUGIN_DIR_PATH_X86
	DEST_DIR = /opt/nvidia/deepstream/deepstream-4.0/lib
	SYM_LINK_DIR := $(DEST_DIR)
else
	DEST_DIR = /usr/lib/$(MACHINE)-linux-gnu/tegra
	SYM_LINK_DIR := $(shell realpath $(DEST_DIR)/..)
endif

LIBS = -lrt

LDFLAGS := -Wl,-soname,libv4lconvert.so.0

all: $(SO_NAME)

%.o: %.c
	$(CC) -c $< $(CFLAGS) $(INCLUDES) -o $@

$(SO_NAME): $(OBJS)
	$(CC) -shared -o $(SO_NAME) $(OBJS) $(LIBS) $(LDFLAGS)

.PHONY: install
install: $(SO_NAME)
	cp -vp $(SO_NAME) $(DEST_DIR)
	if [ "${MACHINE}" = "aarch64" ]; then \
		ln -sf $(DEST_DIR)/$(SO_NAME) $(SYM_LINK_DIR)/libv4lconvert.so.0.0.999999 ; \
		ln -sf $(SYM_LINK_DIR)/libv4lconvert.so.0.0.999999 \
			$(SYM_LINK_DIR)/libv4lconvert.so ; \
	fi
	ldconfig

.PHONY: clean
clean:
	rm -rf $(OBJS) $(SO_NAME)
