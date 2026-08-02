SUMMARY = "NXP 88W8997 SDIO Wi-Fi/BT firmware"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=bc649096ad3928ec06a8713b8d787eac"

SRC_URI = "git://github.com/nxp-imx/imx-firmware.git;protocol=https;branch=${SRCBRANCH}"
SRCBRANCH = "lf-6.18.2_1.0.0"
SRCREV = "f5002c76000214ab1b83347460bfd728d4518338"

inherit allarch

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${S}/FwImage_8997_SD/sd8997_wlan_v4.bin       ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${S}/FwImage_8997_SD/sduart8997_combo_v4.bin  ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${S}/FwImage_8997_SD/uart8997_bt_v4.bin       ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${S}/FwImage_8997_SD/ed_mac_ctrl_V3_8997.conf ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${S}/FwImage_8997_SD/txpwrlimit_cfg_8997.conf ${D}${nonarch_base_libdir}/firmware/nxp/
}

FILES:${PN} = "${nonarch_base_libdir}/firmware/nxp/*8997*"
