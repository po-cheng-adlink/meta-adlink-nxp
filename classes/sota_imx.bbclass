# i.MX8/9 OSTree/SOTA machine configuration.
# Inherited from sota.bbclass as sota_${SOTA_MACHINE}.

# i.MX8/9 boots a raw arm64 Image and cannot boot without a device tree.
OSTREE_KERNEL ?= "Image"

OSTREE_BOOTLOADER ?= "u-boot"

OSTREE_DEPLOY_DEVICETREE = "1"
OSTREE_MULTI_DEVICETREE_SUPPORT = "1"

OSTREE_KERNEL_ARGS = "${OSTREE_KERNEL_ARGS_COMMON} console=ttyLP0,115200 earlycon panic=10"

# Must be override-qualified: sota.bbclass sets WKS_FILE:sota, and an
# override-qualified value wins regardless of order.
WKS_FILE:sota = "ota-ostree.wks.in"

# U-Boot standard boot scans the boot partition for boot.scr.uimg, so the
# bootloader itself needs no change.
IMAGE_BOOT_FILES:append:sota = " boot.scr.uimg"
WKS_FILE_DEPENDS:append:sota = " u-boot-ostree-script"

# The initramfs is an input to the main image's wic assembly, so building wic
# for it is circular. :remove is applied after lec-imx95.conf's :append and is
# what actually drops them.
IMAGE_FSTYPES:pn-initramfs-ostree-image = "${INITRAMFS_FSTYPES}"
IMAGE_FSTYPES:remove:pn-initramfs-ostree-image = "wic wic.md5sum"

