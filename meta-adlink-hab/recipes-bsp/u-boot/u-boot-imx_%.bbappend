UBOOT_EXTRA_CONFIGS:append = "${@bb.utils.contains('IMAGE_FEATURES', 'hab', ' IMX_HAB', '', d)}"

include ${@bb.utils.contains('IMAGE_FEATURES', 'hab debug-tweaks', 'habv4-debug.inc', '', d)}
