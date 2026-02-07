FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " file://0001-Added-lec-imx95-configuration.patch "

SRC_URI:append:osm-imx95 = " file://0001-Added-osm-imx95-configuration.patch "
