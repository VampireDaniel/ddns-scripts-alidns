include $(TOPDIR)/rules.mk

PKG_NAME:=ddns-scripts-alidns
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Your Name <your@email.com>

include $(INCLUDE_DIR)/package.mk

define Package/ddns-scripts-alidns
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Aliyun DNS provider for ddns-scripts
  DEPENDS:=+ddns-scripts +curl +openssl-util +jshn +jsonfilter
endef

define Package/ddns-scripts-alidns/description
  OpenWrt ddns-scripts provider for Aliyun DNS (alidns.com).
endef

define Build/Compile
endef

define Package/ddns-scripts-alidns/install
	$(INSTALL_DIR) $(1)/usr/lib/ddns
	$(INSTALL_BIN) files/usr/lib/ddns/update_alidns.sh $(1)/usr/lib/ddns/
	$(INSTALL_DIR) $(1)/etc/ddns/services.d
	$(INSTALL_DATA) files/etc/ddns/services.d/alidns.json $(1)/etc/ddns/services.d/
endef

$(eval $(call BuildPackage,ddns-scripts-alidns)) 