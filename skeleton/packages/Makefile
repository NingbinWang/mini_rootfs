SHELL = /bin/bash
PYTHON := python
PWD = $(shell pwd)
include $(PWD)/linux.mk

#####tools####
I2CTOOS_VER=4.4
IOZONE3_VER=494
V4L_VER=1.22.1

######WIFI####
WPA_VER=2.9
LIBNL_VER=3.2.25
OPENSSL_VER=3.4.0


BUILD_ALL = i2c_tools
#BUILD_ALL += iozone3
#BUILD_ALL += wpa_supplicant
BUILD_ALL += v4l2-utils

BUILD_INSTALL = i2c_tools_install
#BUILD_INSTALL += iozone3_install
BUILD_INSTALL += v4l2-utils_install

i2c_tools:
	@echo "CC=$(CC)"
	tar -zxvf $(PWD)/i2c-tools-$(I2CTOOS_VER).tar.gz
	make -C $(PWD)/i2c-tools-$(I2CTOOS_VER)




iozone3:
	tar -xzvf $(PWD)/iozone3_$(IOZONE3_VER).tgz
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current clean GCC=$(CC) CC=$(CC) LD=$(LD)
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current linux GCC=$(CC) CC=$(CC) LD=$(LD)
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current linux-arm GCC=$(CC) CC=$(CC) LD=$(LD)

wifienv:
	if [ ! -e $(PWD)/wifi ]; then \
		mkdir -p $(PWD)/wifi; \
	fi
# openssl website : https://github.com/openssl/openssl/releases
openssl:wifienv
	if [ ! -e $(PWD)/wifi/openssl_install_$(OPENSSL_VER) ]; then \
		tar -zxvf $(PWD)/openssl-$(OPENSSL_VER).tar.gz; \
		cd $(PWD)/openssl-$(OPENSSL_VER)/&&./configure no-asm shared no-async --prefix=$(PWD)/wifi/openssl_install_$(OPENSSL_VER); \
		sed -i "s/PLATFORM=linux-x86_64/PLATFORM=arm/" $(PWD)/openssl-$(OPENSSL_VER)/Makefile; \
		sed -i "s/CNF_CFLAGS=-pthread -m64/CNF_CFLAGS=-pthread/" $(PWD)/openssl-$(OPENSSL_VER)/Makefile; \
		sed -i "s/CNF_CXXFLAGS=-std=c++11 -pthread -m64/CNF_CXXFLAGS=-std=c++11 -pthread/" $(PWD)/openssl-$(OPENSSL_VER)/Makefile; \
		make -C $(PWD)/openssl-$(OPENSSL_VER)/; \
		make -C $(PWD)/openssl-$(OPENSSL_VER)/ install; \
	fi
	
# libnl website :http://www.infradead.org/~tgr/libnl/
libnl:wifienv
	if [ ! -e $(PWD)/wifi/libnl_install_$(LIBNL_VER) ]; then \
		tar -zxvf $(PWD)/libnl-$(LIBNL_VER).tar.gz; \
		cd $(PWD)/libnl-$(LIBNL_VER)/&&./configure  --host=$(CROSS_COMPILE_HOST) --prefix=$(PWD)/wifi/libnl_install_$(LIBNL_VER) --sysconfdir=$(PWD)/wifi/libnl_etc --enable-shared --enable-static; \
		make -C $(PWD)/libnl-$(LIBNL_VER); \
		make -C $(PWD)/libnl-$(LIBNL_VER) install; \
	fi

# wpa_supplicant website :http://w1.fi/wpa_supplicant/
wpa_supplicant:openssl libnl
	tar -zxvf $(PWD)/wpa_supplicant-$(WPA_VER).tar.gz
	cp $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/defconfig $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	sed -i "s/CONFIG_CTRL_IFACE_DBUS_NEW=y/#CONFIG_CTRL_IFACE_DBUS_NEW=y/" $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	sed -i "s/CONFIG_CTRL_IFACE_DBUS_INTRO=y/#CONFIG_CTRL_IFACE_DBUS_INTRO=y/" $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	echo "CFLAGS+=-I$(PWD)/wifi/openssl_install_$(OPENSSL_VER)/include" >> $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	echo "LIBS+=-L$(PWD)/wifi/openssl_install_$(OPENSSL_VER)/lib64" >> $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	echo "CFLAGS+=-I$(PWD)/wifi/libnl_install_$(LIBNL_VER)/include/libnl3" >> $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	echo "LIBS+=-L$(PWD)/wifi/libnl_install_$(LIBNL_VER)/lib" >> $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	echo "CC=$(CC)" >> $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	make -C $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/

     
v4l2-utils:
	tar -jxvf $(PWD)/v4l-utils-$(V4L_VER).tar.bz2
	cd $(PWD)/v4l-utils-$(V4L_VER)&&./configure --disable-doxygen-doc --with-pic --with-udevdir --host=$(CROSS_COMPILE_HOST) --prefix=$(PWD)/v4l2_install 
	make -C $(PWD)/v4l-utils-$(V4L_VER)
	make -C $(PWD)/v4l-utils-$(V4L_VER) install;



all:$(BUILD_ALL)
	@echo "Finish build packages"



i2c_tools_install:
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/lib/*.so* $(STAGING_OUTPUTDIR)/lib/
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cdetect $(STAGING_OUTPUTDIR)/bin/
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cdump $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cget $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cset $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2ctransfer $(STAGING_OUTPUTDIR)/bin

iozone3_install:
	$(INSTALL) $(PWD)/iozone3_$(IOZONE3_VER)/src/current/iozone $(STAGING_OUTPUTDIR)/bin

v4l2-utils_install:
	$(INSTALL) $(PWD)/v4l2_install/lib/*.so* $(STAGING_OUTPUTDIR)/lib/
	$(INSTALL) $(PWD)/v4l2_install/bin/v4l2-ctl $(STAGING_OUTPUTDIR)/bin/


install:$(BUILD_INSTALL)
	@echo "Finish install packages"


