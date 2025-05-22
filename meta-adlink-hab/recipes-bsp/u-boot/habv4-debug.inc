FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

EXTRA_UBOOT_PATCHES:append = " file://sp2-imx8mp/0001-sp2-imx8mp-habv4-patch-to-show-addition-hab_status-e.patch"

do_replace () {
  # replace printf Bad has value to show calculated hashes
  sed -e 's|debug(|printf(|g' -i ${S}/arch/arm/mach-imx/spl.c
  sed -e 's|DECLARE_GLOBAL_DATA_PTR;|#define DEBUG 1\nDECLARE_GLOBAL_DATA_PTR;|g' -i ${S}/arch/arm/mach-imx/hab.c
  sed -e 's|debug(|printf(|g' -i ${S}/arch/arm/mach-imx/hab.c
}
addtask replace before do_configure after do_patch

