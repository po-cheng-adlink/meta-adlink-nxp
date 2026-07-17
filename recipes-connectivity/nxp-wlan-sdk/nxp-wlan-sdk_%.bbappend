FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', '', ' file://0001-add-mlanutl-source-code.patch', d)}"

SRC_URI:append = "${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', ' file://0001-LEC-IMX8MP-B1-Add-Latest-wlan-sdk-source.patch', '', d)}"
do_populate_lic[noexec] = "${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', '1', '0', d)}"

DEPENDS += "virtual/kernel"

do_compile:append () {
    if [ "${SUPPORT_LECIMX8MP_B1}" != "1" ]; then
        cd ${S}/wlan_src
        oe_runmake build
    fi
    #else build using base define
}


do_install () {
    install -d ${D}${datadir}/nxp_wireless
    if [ "${SUPPORT_LECIMX8MP_B1}" != "1" ]; then
        install -m 0755 script/load ${D}${datadir}/nxp_wireless
        install -m 0755 script/unload ${D}${datadir}/nxp_wireless
        install -m 0644 README ${D}${datadir}/nxp_wireless
    fi
    cp -rf ${S}/bin_wlan ${D}${datadir}/nxp_wireless
}


RDEPENDS:${PN} += " bash"

