#!/bin/bash
svn_export() {
	# 参数1是分支名, 参数2是子目录, 参数3是目标目录, 参数4仓库地址
	TMP_DIR="$(mktemp -d)" || exit 1
 	ORI_DIR="$PWD"
	[ -d "$3" ] || mkdir -p "$3"
	TGT_DIR="$(cd "$3"; pwd)"
	git clone --depth 1 -b "$1" "$4" "$TMP_DIR" >/dev/null 2>&1 && \
	cd "$TMP_DIR/$2" && rm -rf .git >/dev/null 2>&1 && \
	cp -af . "$TGT_DIR/" && cd "$ORI_DIR"
	rm -rf "$TMP_DIR"
}


# 删除冲突软件和依赖
rm -rf feeds/luci/applications/luci-app-pushbot feeds/luci/applications/luci-app-serverchan

# 替换argon主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git ./feeds/luci/themes/luci-theme-argon
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# 个性化设置
cd package
sed -i "s/OpenWrt /Wing build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" lean/default-settings/files/zzz-default-settings
sed -i "/firewall\.user/d" lean/default-settings/files/zzz-default-settings
# 设置管理地址
sed -i 's/192.168.1./192.168.10./g' base-files/files/bin/config_generate
sed -i 's/192.168.1./192.168.10./g' base-files/luci2/bin/config_generate
sed -i 's/192.168.1./192.168.10./g' base-files/Makefile
sed -i 's/192.168.1./192.168.10./g' base-files/image-config.in
# 设置密码为空
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' lean/default-settings/files/zzz-default-settings

# 下载插件
# mosdns
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf package/feeds/packages/mosdns
rm -rf package/feeds/packages/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata


