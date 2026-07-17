#LEC-i.MX8MP B1 board specific patches and additions
#kernel

EXTRA_KERNEL_PATCHES:remove = "file://lec-imx8mp/lec-imx8mp_defconfig"

IMX_KERNEL_CONFIG_AARCH64:lec-imx8mp = "lec-imx8mp-b1_defconfig"

EXTRA_KERNEL_PATCHES:append = " \
        file://lec-imx8mp/lec-imx8mp-b1_defconfig \
	file://lec-imx8mp/0005-LEC-IMX8MP-B1-phy-led-and-edid-delay-support.patch \
	file://lec-imx8mp/0006-LEC-IMX8MP-B1-change-ov13855-reset-pin-control-api.patch \
"

KERNEL_DEVICETREE_BASENAME = "lec-imx8mp-b1"
KERNEL_DEVICETREE = " \
        adlink/${KERNEL_DEVICETREE_BASENAME}-auoB101UAN01-mipi-panel.dtb \
        adlink/${KERNEL_DEVICETREE_BASENAME}-hydis-hv150ux2.dtb \
        adlink/${KERNEL_DEVICETREE_BASENAME}.dtb \
        adlink/${KERNEL_DEVICETREE_BASENAME}-tlv320aic3x.dtb \
        adlink/${KERNEL_DEVICETREE_BASENAME}-tlv320-lvds.dtb \
        adlink/${KERNEL_DEVICETREE_BASENAME}-auoG101EAT02p6-lvds-panel.dtb \
"
WIFIBT_DTB = "${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'adlink/${KERNEL_DEVICETREE_BASENAME}-wifi.dtb', '', d)}"
KERNEL_DEVICETREE:append = " ${WIFIBT_DTB}"
# over device tree overlay
EXTRA_OEMAKE:append:pn-linux-imx = " DTC_FLAGS='-@ -H epapr'"

DELTA_KERNEL_DEFCONFIG:append:lec-imx8mp = " LEC-i.MX8MP_CVE-2026-31431_crypto-algif_aead-disable.config"


EXTRA_KERNEL_PATCHES:append:tinycma = " file://lec-imx8mp/0001-dtb-reduce-cma-size-for-adlink-imx8mp-som.patch"
EXTRA_KERNEL_DTS = " \
        file://lec-imx8mp/lec-imx8mp-b1-auoB101UAN01-mipi-panel.dts \
        file://lec-imx8mp/lec-imx8mp-b1-hydis-hv150ux2.dts \
        file://lec-imx8mp/lec-imx8mp-b1.dts \
        file://lec-imx8mp/tlv320aic3x.dtsi \
        file://lec-imx8mp/lec-imx8mp-b1-tlv320aic3x.dts \
        file://lec-imx8mp/lec-imx8mp-b1-tlv320-lvds.dts \
        file://lec-imx8mp/lec-imx8mp-b1-auoG101EAT02p6-lvds-panel.dts \
"
WIFIBT_DTS = "${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'file://lec-imx8mp/lec-imx8mp-b1-wifi.dts', '', d)}"
EXTRA_KERNEL_DTS:append = " ${WIFIBT_DTS}"

#wifi bbmask remove for B1
BBMASK:remove:lec-imx8mp = "nxp-wlan-sdk_%.bbappend"

#uboot

EXTRA_UBOOT_PATCHES:append = " \
	file://lec-imx8mp/adlink_lec8mpb1_defconfig \
"
UBOOT_CONFIG_BASENAME = "adlink_lec8mpb1"

UBOOT_CONFIG[fspi] = "${UBOOT_CONFIG_BASENAME}_defconfig"



