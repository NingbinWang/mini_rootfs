
SHELL = /bin/bash
PYTHON := python
PWD = $(shell pwd)



SKELETON_PATH = $(PWD)/skeleton
OUTPUT_PATH = $(PWD)/output
BUILD_DIR = $(OUTPUT_PATH)/build
SKELETON_TOOLS = $(SKELETON_PATH)/tools
STAGING_OUTPUTDIR = $(BUILD_DIR)/stagine
PACKAGES_BUILDDIR = $(BUILD_DIR)/packages
PACKAGES_DIR=$(SKELETON_PATH)/packages
export  STAGING_OUTPUTDIR

ROOTFS_ARCH = arm64
ifeq ($(ROOTFS_ARCH),arm64)
ROOTFS_CROSS_COMPILE_DIR =  $(PWD)/../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu
ROOTFS_CROSS_COMPILE = $(ROOTFS_CROSS_COMPILE_DIR)/bin/aarch64-linux-gnu
CROSS_COMPILE_LIBCDIR=$(ROOTFS_CROSS_COMPILE_DIR)/aarch64-linux-gnu/libc
else
ROOTFS_CROSS_COMPILE_DIR =  $(PWD)/../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf
ROOTFS_CROSS_COMPILE = $(ROOTFS_CROSS_COMPILE_DIR)/bin/arm-linux-gnueabihf
CROSS_COMPILE_LIBCDIR=$(ROOTFS_CROSS_COMPILE_DIR)/arm-linux-gnueabihf/libc
endif
BUSYBOX_DIR = $(SKELETON_PATH)/busybox
#fix
#BUSYBOX_CONFIG = $(BUSYBOX_DIR)/configs/fireflyrk3288_defconfig
BUSYBOX_CONFIG = $(BUSYBOX_DIR)/configs/tsp_defconfig
IMGNAME_EXT4=rootfs.ext4.bin
ROOTFS_EXT4_SIZE=1892MB







BUSYBOX_VERSION = 1.34.1
BUSYBOX_ARCH = $(ROOTFS_ARCH)
BUSYBOX_CROSS_COMPILE = $(ROOTFS_CROSS_COMPILE)-

export ROOTFS_CROSS_COMPILE ROOTFS_ARCH


BUSYBOX_SOURCE = busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_BUILD = $(BUILD_DIR)/busybox-$(BUSYBOX_VERSION)
BUSYBOX_INSTALL_DIR = $(BUSYBOX_BUILD)/_install
BUSYBOX_BUILD_CONFIG = $(BUSYBOX_BUILD)/.config

BUSYBOX_MAKE_OPTS += \
	CROSS_COMPILE=$(BUSYBOX_CROSS_COMPILE) \
	ARCH=$(BUSYBOX_ARCH) \
	PREFIX="$(BUSYBOX_INSTALL_DIR)" \
	CONFIG_PREFIX="$(BUSYBOX_INSTALL_DIR)" \
	CFLAGS="-Wl,--rpath-link $(STAGING_OUTPUTDIR)/usr/lib"

checkenv:
	if [ ! -e $(OUTPUT_PATH) ]; then \
		mkdir $(OUTPUT_DIR); \
		mkdir -p $(BUILD_DIR); \
		mkdir -p $(STAGING_OUTPUTDIR); \
		mkdir -p $(PACKAGES_BUILDDIR); \
	fi

stagine:checkenv
	cp -rf $(SKELETON_PATH)/base/*  $(STAGING_OUTPUTDIR) 
	cp -a  $(CROSS_COMPILE_LIBCDIR)/lib/*.so* $(STAGING_OUTPUTDIR)/lib
	cp -a  $(CROSS_COMPILE_LIBCDIR)/usr/lib/*.so* $(STAGING_OUTPUTDIR)/usr/lib




busybox_build:checkenv
	if [ ! -e $(BUSYBOX_BUILD) ]; then \
		tar -jxvf $(BUSYBOX_DIR)/$(BUSYBOX_SOURCE) -C $(BUILD_DIR)/; \
	fi
	cp $(BUSYBOX_CONFIG) $(BUSYBOX_BUILD_CONFIG)
	make -C $(BUSYBOX_BUILD) $(BUSYBOX_MAKE_OPTS) all
	make -C $(BUSYBOX_BUILD) $(BUSYBOX_MAKE_OPTS) install
	cp -af $(BUSYBOX_INSTALL_DIR)/* $(STAGING_OUTPUTDIR)/

busybox_config:checkenv
	if [ ! -e $(BUSYBOX_BUILD) ]; then \
		tar -jxvf $(BUSYBOX_DIR)/$(BUSYBOX_SOURCE) -C $(BUILD_DIR)/; \
	fi
	cp $(BUSYBOX_CONFIG) $(BUSYBOX_BUILD_CONFIG) 
	make -C $(BUSYBOX_BUILD) $(BUSYBOX_MAKE_OPTS) menuconfig
	cp $(BUSYBOX_BUILD_CONFIG) $(BUSYBOX_CONFIG)




packages:stagine
	cp  $(PACKAGES_DIR)/*   $(PACKAGES_BUILDDIR)/ -rf
	make -C $(PACKAGES_BUILDDIR) all
	make -C $(PACKAGES_BUILDDIR) install


all:stagine busybox_build packages
	if [ -e $(OUTPUT_PATH)/$(IMGNAME_EXT4) ]; then \
		rm $(OUTPUT_PATH)/$(IMGNAME_EXT4); \
	fi
	$(SKELETON_TOOLS)/make_ext4fs -l $(ROOTFS_EXT4_SIZE) -s $(OUTPUT_PATH)/$(IMGNAME_EXT4) $(STAGING_OUTPUTDIR)
#	dd if=/dev/zero of=$(OUTPUT_PATH)/$(IMGNAME_EXT4) bs=1M count=6
#	mkfs.ext4 $(OUTPUT_PATH)/$(IMGNAME_EXT4)
#	mkdir -p $(OUTPUT_PATH)/romfs
#	mount -o loop $(OUTPUT_PATH)/$(IMGNAME_EXT4) $(OUTPUT_PATH)/romfs
#	cp $(STAGING_OUTPUTDIR)/* $(OUTPUT_PATH)/romfs -rf
#	umount $(OUTPUT_PATH)/romfs

	
clean:
	rm $(OUTPUT_PATH) -rf 