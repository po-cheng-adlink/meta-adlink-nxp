FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

require ${@bb.utils.contains('SUPPORT_LECIMX8MP_B1', '1', 'include/lec-imx8mp-wifi-b1.inc', '', d)}
