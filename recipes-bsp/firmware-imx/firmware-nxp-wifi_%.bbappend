# Pin firmware to pre-deprecation commit
SRCREV = "f5002c76000214ab1b83347460bfd728d4518338"

FILES:${PN} += " \
    ${nonarch_base_libdir}/firmware/nxp/*8997* \
    ${nonarch_libdir}/firmware/nxp/*8997* \
"
