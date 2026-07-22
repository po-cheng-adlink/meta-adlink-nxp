FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:lec-imx95 = " file://0001-LEC-IMX95-Add-mx95lec-config-profile.patch"

#
#SRC_URI:append:osm-imx95 = " file://0001-Added-osm-imx95-configuration.patch "
