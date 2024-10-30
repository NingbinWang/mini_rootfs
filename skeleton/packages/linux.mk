#平台是否支持C++
#Makefile全局参数
MAKEFLAGS += -rR --no-print-directory

#makfile编译相关变量
export CC      := $(ROOTFS_CROSS_COMPILE)-gcc
export CXX	   := $(ROOTFS_CROSS_COMPILE)-g++
export LD      := $(ROOTFS_CROSS_COMPILE)-ld
export NM      := $(ROOTFS_CROSS_COMPILE)-nm
export AR      := $(ROOTFS_CROSS_COMPILE)-ar
export RM      := rm
export Q       := @
export MAKE    := make
export MKDIR   := mkdir
export CP	   := cp
export OBJCOPY := $(ROOTFS_CROSS_COMPILE)-objcopy
export STRIP   := $(ROOTFS_CROSS_COMPILE)-strip
export RM      := rm -rf
export ECHO    := echo
export INSTALL := /usr/bin/install
export ARCH    := $(ROOTFS_ARCH)

#全局C_FLAGS
DBG_CFLAGS := -g -fstack-protector -fstack-protector-all  -feliminate-unused-debug-types -Wno-int-to-pointer-cast

C_FLAGS += -O2 $(DBG_CFLAGS) -D_REENTRANT -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Wall \
		-pipe

#c版本
C_FLAGS += -ldl -lm -lpthread -lrt


