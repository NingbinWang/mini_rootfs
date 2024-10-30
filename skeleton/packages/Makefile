SHELL = /bin/bash
PYTHON := python
PWD = $(shell pwd)
include $(PWD)/linux.mk

I2CTOOS_VER=4.4
IOZONE3_VER=494

######WIFI####
WPA_VER=2.11
LIBNL_VER=3.2.25
OPENSSL_VER=3.4.0


BUILD_ALL = i2c_tools
#BUILD_ALL += iozone3
#BUILD_ALL += wpa_supplicant

BUILD_INSTALL = i2c_tools_install
#BUILD_INSTALL += iozone3_install

i2c_tools:
	@echo "CC=$(CC)"
	tar -zxvf $(PWD)/i2c-tools-$(I2CTOOS_VER).tar.gz
	make -C $(PWD)/i2c-tools-$(I2CTOOS_VER)

i2c_tools_install:
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/lib/*.so* $(STAGING_OUTPUTDIR)/lib/
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cdetect $(STAGING_OUTPUTDIR)/bin/
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cdump $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cget $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2cset $(STAGING_OUTPUTDIR)/bin
	$(INSTALL) $(PWD)/i2c-tools-$(I2CTOOS_VER)/tools/i2ctransfer $(STAGING_OUTPUTDIR)/bin


iozone3:
	tar -xzvf $(PWD)/iozone3_$(IOZONE3_VER).tgz
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current clean GCC=$(CC) CC=$(CC) LD=$(LD)
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current linux GCC=$(CC) CC=$(CC) LD=$(LD)
	make -C $(PWD)/iozone3_$(IOZONE3_VER)/src/current linux-arm GCC=$(CC) CC=$(CC) LD=$(LD)


iozone3_install:
	$(INSTALL) $(PWD)/iozone3_$(IOZONE3_VER)/src/current/iozone $(STAGING_OUTPUTDIR)/bin

wifienv:
	if [ ! -e $(PWD)/wifi ]; then \
		mkdir -p $(PWD)/wifi; \
	fi
# openssl website : https://github.com/openssl/openssl/releases
openssl:wifienv
	if [ ! -e $(PWD)/wifi/openssl_install ]; then \
		tar -zxvf $(PWD)/openssl-$(OPENSSL_VER).tar.gz; \
		cd $(PWD)/openssl-$(OPENSSL_VER)/&&./config no-asm shared no-async --prefix=$(PWD)/wifi/openssl_install; \
		make -C $(PWD)/openssl-$(OPENSSL_VER)/; \
		make -C $(PWD)/openssl-$(OPENSSL_VER)/ install; \
	fi
	
# libnl website :http://www.infradead.org/~tgr/libnl/
libnl:wifienv
	if [ ! -e $(PWD)/wifi/libnl_install ]; then \
		tar -zxvf $(PWD)/libnl-$(LIBNL_VER).tar.gz; \
		cd $(PWD)/libnl-$(LIBNL_VER)/&&./configure  --host=arm --prefix=$(PWD)/wifi/libnl_install --sysconfdir=$(PWD)/wifi/libnl_etc --enable-shared --enable-static; \
		make -C $(PWD)/libnl-$(LIBNL_VER); \
		make -C $(PWD)/libnl-$(LIBNL_VER) install; \
	fi

# wpa_supplicant website :http://w1.fi/wpa_supplicant/
wpa_supplicant:
	tar -zxvf $(PWD)/wpa_supplicant-$(WPA_VER).tar.gz
	cp $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/defconfig $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/.config
	make -C $(PWD)/wpa_supplicant-$(WPA_VER)/wpa_supplicant/  CFLAGS+=-I$(PWD)/wifi/openssl_install/include LIBS+=-L$(PWD)/wifi/openssl_install/lib CFLAGS+=-I$(PWD)/wifi/libnl_install/include LIBS+=-L$(PWD)/wifi/libnl_install/lib 

# -I$(PWD)/wifi/libnl_install/include
# -L$(PWD)/wifi/libnl_install/lib















install:$(BUILD_INSTALL)
	@echo "Finish install packages"


all:$(BUILD_ALL)
	@echo "Finish build packages"