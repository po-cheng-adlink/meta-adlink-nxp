SRCREV:lec-imx95 = "f5002c76000214ab1b83347460bfd728d4518338"

FILES:${PN} += " \
    ${nonarch_base_libdir}/firmware/nxp/*8997* \
    ${nonarch_libdir}/firmware/nxp/*8997* \
"

do_install:append:lec-imx8mp() {
    printf 'SD8997 = {\n\tcal_data_cfg=none\n}\n' >> ${D}${nonarch_base_libdir}/firmware/nxp/wifi_mod_para.conf
    printf 'SDAW693 = {\n\tcal_data_cfg=none\n\tfw_name=nxp/sduartiw693_combo_v1.bin.se\n}\n' >> ${D}${nonarch_base_libdir}/firmware/nxp/wifi_mod_para.conf
}
