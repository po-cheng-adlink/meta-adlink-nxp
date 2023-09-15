FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
#UBOOT_SRC ?= "git://github.com/nxp-imx/uboot-imx.git;protocol=https"
#SRCBRANCH = "lf_v2022.04"
#SRCREV = "181859317bfafef1da79c59a4498650168ad9df6"
#LOCALVERSION = "-${SRCBRANCH}"

EXTRA_SRC = "${@d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  dtbes=$(echo "${UBOOT_DTB_NAME}" | xargs)
  bbnote "u-boot dtbes: $dtbes"

  # Copy config and dts
  for config in ${configs}; do
    if [ -f ${WORKDIR}/${config} ]; then
      bbnote "u-boot config: $config"
      cp -f ${WORKDIR}/${config} ${S}/configs/
    fi
  done
  for dtbname in ${dtbes}; do
    dtsname=$(echo "${dtbname%%.*}.dts")
    if [ -f ${WORKDIR}/$dtsname ]; then
      bbnote "u-boot dts: ${dtsname}"
      cp -f ${WORKDIR}/$dtsname ${S}/arch/arm/dts/
    fi
  done
}

addtask copy_source before do_patch after do_unpack

do_configure:prepend () {

  # Additional CONFIG_XXX for u-boot config
  # E.g. in local.conf
  #     UBOOT_EXTRA_CONFIGS = "LPDDR4_8GB"
  #
  # For imx8mq:
  #     DDR3L_1GB, DDR3L_2GB, DDR3L_4GB, DDR3L_4GB_MT
  # For imx8mp:
  #     LPDDR4_2GB, LPDDR4_2GK, LPDDR4_4GB, LPDDR4_8GB
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  extras=$(echo "${UBOOT_EXTRA_CONFIGS}" | xargs)
  echo "Add ${extras} to ${configs}"
  for extra in ${extras}; do
    if [ -n $extra ]; then
      for config in $configs; do
        if [ -f ${S}/configs/${config} ]; then
          upper=$(echo ${extra} | tr '[:lower:]' '[:upper:]')
          echo "CONFIG_${upper##CONFIG_}=y" | tee -a ${S}/configs/${config}
        fi
      done
    fi
  done
}