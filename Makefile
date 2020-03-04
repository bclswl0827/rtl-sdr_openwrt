#
# Copyright (C) 2015 OpenWrt.org
# Copyright (C) 2020 ibcl.us
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl-sdr
PKG_VERSION:=0.6.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/bclswl0827/rtl-sdr/tar.gz/$(PKG_VERSION)?
PKG_HASH:=4fe53d7c168a4a631cedd2436d6d773288f244cf3cd4720d22f70a07ba45439b

PKG_BUILD_PARALLEL:=1
CMAKE_INSTALL:=1

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=COPYING

PKG_MAINTAINER:=Yuki Kikuchi <bclswl0827@yahoo.co.jp>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/rtl-sdr/Default
  TITLE:=Software Defined Radio with Realtek RTL2832U, which support rtl_sdr and rtl_tcp direct sampling from I/Q branch.
  URL:=https://github.com/bclswl0827/rtl-sdr
endef

define Package/rtl-sdr/Default/description
  rtl-sdr allows DVB-T dongles based on the Realtek RTL2832U to be used as
  an inexpensive SDR.
endef

define Package/rtl-sdr
  $(call Package/rtl-sdr/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+librt +libpthread +librtlsdr
endef

define Package/rtl-sdr/description
  $(call Package/rtl-sdr/Default/description)

  This package contains the utilities and daemons.
endef

define Package/librtlsdr
  $(call Package/rtl-sdr/Default)
  TITLE+= shared library
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE+= library
  DEPENDS:=+libusb-1.0
endef

define Package/librtlsdr/description
  $(call Package/rtl-sdr/Default/description)

  This package contains the librtlsdr shared library.
endef

TARGET_CFLAGS += $(FPIC)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/librtlsdr.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/librtlsdr.pc $(1)/usr/lib/pkgconfig/
endef

define Package/rtl-sdr/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/rtl_* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/rtl_tcp.init $(1)/etc/init.d/rtl_tcp
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/rtl_tcp.config $(1)/etc/config/rtl_tcp
endef

define Package/librtlsdr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/librtlsdr.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,rtl-sdr))
$(eval $(call BuildPackage,librtlsdr))
