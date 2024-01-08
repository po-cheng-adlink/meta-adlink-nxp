# Copyright 2022-2023 ADLINK
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://mkimage_fit_atf.sh"

do_replace () {
    sed -i 's|dtbs ?=.*|ovlays ?= \ndtbs ?= ${UBOOT_DTB_NAME}|g' ${BOOT_STAGING}/soc.mak
    sed -i -E 's|mkimage_fit_atf.sh(.*) >|mkimage_fit_atf.sh\1 $(ovlays) >|g' ${BOOT_STAGING}/soc.mak

    cp -f ${WORKDIR}/mkimage_fit_atf.sh ${BOOT_STAGING}/mkimage_fit_atf.sh
}
addtask replace before do_compile after do_configure

compile_mx8m:append() {
    for dtbo in ${UBOOT_DTB_OVERLAYS}; do
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${dtbo}   ${BOOT_STAGING}
    done
}

#
# modify imx-boot_1.0.bb to copy multiple uboot dtbs
#
do_compile:prepend() {
    strDTBS=$(echo "${UBOOT_DTB_NAME}" | xargs)
    DTBS=$(echo ${strDTBS} | awk -F' ' '{print NF}')
    if [ ${DTBS} -gt 1 ]; then
        bberror "Error: Do not specify more than 1 uboot dtb for imx-boot."
    fi
}

#
# override original do_compile
#
do_compile() {
    # mkimage for i.MX8
    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}
        if ${DEPLOY_OPTEE_STMM}; then
            # Copy tee.bin to tee.bin-stmm
            cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}/tee.bin-stmm
        fi
    fi
    for target in ${IMXBOOT_TARGETS}; do
        compile_${SOC_FAMILY}
        if [ "$target" = "flash_linux_m4_no_v2x" ]; then
            # Special target build for i.MX 8DXL with V2X off
            bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO dtbs=${UBOOT_DTB_NAME} ovlays="${UBOOT_DTB_OVERLAYS}" flash_linux_m4
        elif [ "$target" = "flash_evk_stmm_capsule" ]; then
            cp ${RECIPE_SYSROOT_NATIVE}/${bindir}/mkeficapsule      ${BOOT_STAGING}

            bbnote "building ${IMX_BOOT_SOC_TARGET} - TEE=tee.bin-stmm ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm delete_capsule_key
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm capsule_key
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm dtbs=${UBOOT_DTB_NAME} ovlays="${UBOOT_DTB_OVERLAYS}" ${target}
        else
            bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} dtbs=${UBOOT_DTB_NAME} ovlays="${UBOOT_DTB_OVERLAYS}" ${target}
        fi
        if [ -e "${BOOT_STAGING}/flash.bin" ]; then
            cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
        fi
    done
}

