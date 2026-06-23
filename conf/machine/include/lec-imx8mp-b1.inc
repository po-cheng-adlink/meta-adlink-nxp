#LEC-i.MX8MP B1 board specific patches and additions

#kernel
EXTRA_KERNEL_PATCHES:remove = "file://lec-imx8mp/lec-imx8mp_defconfig"

IMX_KERNEL_CONFIG_AARCH64:lec-imx8mp = "lec-imx8mp-b1_defconfig"


EXTRA_KERNEL_PATCHES:append = " \
        file://lec-imx8mp/lec-imx8mp-b1_defconfig \
	file://lec-imx8mp/0007-lec-imx8mp-AUO-g156han04-Panel.patch \
        file://lec-imx8mp/0008-lec-imx8mp-HDMI-edid-and-devinfo-support.patch \
        file://lec-imx8mp/0009-lec-imx8mp-b1-rtc-and-phy-support.patch \
        file://lec-imx8mp/0010-lec-imx8mp-b1-change-ov13855-reset-pin-control-api.patch \
        file://lec-imx8mp/0011-lec-imx8mp-b1-fixed-rtc-alarm-timer-issue.patch \
        file://lec-imx8mp/0012-lec-imx8mp-b1-optimize-RX-8310CE-driver-SEMA-wdg.patch \
"

KERNEL_DEVICETREE_BASENAME = "lec-imx8mp-b1"
KERNEL_DEVICETREE = " \ 
	adlink/${KERNEL_DEVICETREE_BASENAME}-auo-g156han04-0.dtb \
	adlink/${KERNEL_DEVICETREE_BASENAME}-auoB101UAN01-mipi-panel.dtb \
	adlink/${KERNEL_DEVICETREE_BASENAME}-hydis-hv150ux2.dtb \
	adlink/${KERNEL_DEVICETREE_BASENAME}.dtb \
	adlink/${KERNEL_DEVICETREE_BASENAME}-tlv320aic3x.dtb \
	adlink/${KERNEL_DEVICETREE_BASENAME}-tlv320-lvds.dtb \
"

WIFIBT_DTB = "${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'adlink/${KERNEL_DEVICETREE_BASENAME}-wifi.dtb', '', d)}"
KERNEL_DEVICETREE:append = " ${WIFIBT_DTB}"

WIFIBT_DTS = "${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'file://lec-imx8mp/lec-imx8mp-b1-wifi.dts', '', d)}"
EXTRA_KERNEL_CMA_2G_PATCH = "${@bb.utils.contains('UBOOT_EXTRA_CONFIGS', 'LPDDR4_2GB', 'file://lec-imx8mp/0003-Allocated-CMA-range-based-on-2G-Ram-Size.patch', '', d)}"

EXTRA_KERNEL_DTS = " \
        file://lec-imx8mp/lec-imx8mp-b1-auo-g156han04-0.dts \
	file://lec-imx8mp/lec-imx8mp-b1-auoB101UAN01-mipi-panel.dts \
        file://lec-imx8mp/lec-imx8mp-b1-hydis-hv150ux2.dts \
        file://lec-imx8mp/lec-imx8mp-b1.dts \
        file://lec-imx8mp/tlv320aic3x.dtsi \
        file://lec-imx8mp/lec-imx8mp-b1-tlv320aic3x.dts \
        file://lec-imx8mp/lec-imx8mp-b1-tlv320-lvds.dts \
        ${WIFIBT_DTS} \
        ${EXTRA_KERNEL_CMA_2G_PATCH} \
"

#uboot
UBOOT_DTB_NAME = "lec-imx8mp-b1.dtb"


EXTRA_UBOOT_PATCHES = " \
        file://lec-imx8mp/adlink_lec8mpb1_defconfig \
        file://lec-imx8mp/0001-lec-imx8mp-b1-add-imx8mp-board-support.patch \
        file://lec-imx8mp/0002-lec-imx8mp-b1-update-fdtfile-variable-based-on-connecte.patch \
        file://lec-imx8mp/0003-lec-imx8mp-enable-ddr4-inline-ecc.patch \
        file://lec-imx8mp/0004-lec-imx8mp-remove-unified-image-support.patch \
        file://lec-imx8mp/0005-Added-6GB-DDR-support.patch \
        file://lec-imx8mp/0006-Added-6GB-DDR-Timing-configuration-file.patch \
"

EXTRA_UBOOT_DTS = " \
        file://lec-imx8mp/lec-imx8mp-b1.dts \
"

