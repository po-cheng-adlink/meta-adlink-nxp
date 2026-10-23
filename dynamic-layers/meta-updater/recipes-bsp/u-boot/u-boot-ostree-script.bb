SUMMARY = "U-Boot boot script for OSTree deployments on iMX8/9"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

OSTREE_BOOT_SCRIPT ?= "boot.cmd"
SRC_URI = "file://${OSTREE_BOOT_SCRIPT}"

# Same provider the existing u-boot-script recipe uses in this layer.
DEPENDS = "u-boot-mkimage-native"
INHIBIT_DEFAULT_DEPS = "1"
PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8|mx9)"

S = "${WORKDIR}"

inherit deploy

do_configure[noexec] = "1"

do_compile() {
    mkimage -A arm64 -O linux -T script -C none -a 0 -e 0 \
        -n "LEC-iMX95 OSTree boot" \
        -d ${S}/${OSTREE_BOOT_SCRIPT} ${B}/boot.scr.uimg
}

# Nothing belongs in the rootfs - this file lives on the boot partition only.
do_install[noexec] = "1"
ALLOW_EMPTY:${PN} = "1"

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${B}/boot.scr.uimg ${DEPLOYDIR}/boot.scr.uimg
}
addtask deploy before do_package after do_compile
