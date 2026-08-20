SUMMARY = "Blacklist Realtek PG driver"
DESCRIPTION = "Prevents the Realtek PG driver from automatically binding to the Ethernet controller"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://blacklist-eth.conf"

do_install() {
    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${UNPACKDIR}/blacklist-eth.conf \
        ${D}${sysconfdir}/modprobe.d/blacklist-eth.conf
}

FILES:${PN} += "${sysconfdir}/modprobe.d/blacklist-eth.conf"
