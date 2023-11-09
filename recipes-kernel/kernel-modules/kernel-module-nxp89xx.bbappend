# Copyright 2021 ADLINK Inc.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
  file://moal.conf \
"

MOD_CONF_FILES = "${@bb.utils.contains('MACHINE_FEATURES', 'wifi', 'moal.conf', '', d)}"

do_install:append () {
  install -d ${D}${sysconfdir}/modprobe.d
  # if building wifi/bt, then copy moal.conf
  for f in "${MOD_CONF_FILES}"; do
    install -m 644 ${WORKDIR}/${f} ${D}${sysconfdir}/modprobe.d/
  done
}

FILES:${PN} += "${sysconfdir}/modprobe.d/"

