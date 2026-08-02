# Copyright 2021 ADLINK Inc.
# get pre-deprecation commit
SRCREV = "371a047ac6345e2c49fb5d77f30ec24aa04ae765"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

EXTRA_OEMAKE:append:lec-imx8mp = " CONFIG_SDAW693=y"

SRC_URI:append = " \
    file://moal.conf \
"
SRC_URI:append:lec-imx8mp = " file://blacklist-mwifiex.conf"

MOD_CONF_FILES = "${@bb.utils.contains('MACHINE_FEATURES', 'wifi', 'moal.conf', '', d)}"
MOD_CONF_FILES:append:lec-imx8mp = "${@bb.utils.contains('MACHINE_FEATURES', 'wifi', ' blacklist-mwifiex.conf', '', d)}"

do_install:append () {
    install -d ${D}${sysconfdir}/modprobe.d
    for f in ${MOD_CONF_FILES}; do
        CONF_PATH=""
        if [ -f "${UNPACKDIR}/${f}" ]; then
            CONF_PATH="${UNPACKDIR}/${f}"
        elif [ -f "${WORKDIR}/${f}" ]; then
            CONF_PATH="${WORKDIR}/${f}"
        elif [ -f "${WORKDIR}/../${f}" ]; then
            CONF_PATH="${WORKDIR}/../${f}"
        fi

        if [ -n "${CONF_PATH}" ]; then
            install -m 644 "${CONF_PATH}" ${D}${sysconfdir}/modprobe.d/
        else
            bbfatal "Could not find ${f} in ${UNPACKDIR} or ${WORKDIR}"
        fi
    done
}

FILES:${PN} += "${sysconfdir}/modprobe.d/"
