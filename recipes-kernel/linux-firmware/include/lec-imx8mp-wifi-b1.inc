SRC_URI:append = " \
    file://sdaw693_wlan_v1.bin.se \
    file://sduartaw693_combo_v1.bin.se \
    file://uartaw693_bt_v1.bin.se \
    file://wifi_mod_para.conf \
"

do_install:append () {
    install -d ${D}${nonarch_base_libdir}/firmware/nxp

    # Install the new AW693 firmware binaries
    install -m 0644 ${WORKDIR}/sdaw693_wlan_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${WORKDIR}/sduartaw693_combo_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp/
    install -m 0644 ${WORKDIR}/uartaw693_bt_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp/
    # Overwrite the legacy baseline configuration with updated module parameters
    install -m 0644 ${WORKDIR}/wifi_mod_para.conf ${D}${nonarch_base_libdir}/firmware/nxp/
}

FILES:${PN}-nxp89xx += " \
    ${nonarch_base_libdir}/firmware/nxp/*w693* \
    ${nonarch_base_libdir}/firmware/nxp/wifi_mod_para.conf \
"
