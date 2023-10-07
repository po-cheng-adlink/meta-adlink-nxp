FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SRCBRANCH = "lf-5.15.y"
#LOCALVERSION = "-lts-next"
#KERNEL_SRC ?= "git://github.com/nxp-imx/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
#KBRANCH = "${SRCBRANCH}"
#SRC_URI = "${KERNEL_SRC}"

EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
  deltaconfigs=$(echo "${DELTA_KERNEL_DEFCONFIG}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)

  # Copy config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${WORKDIR}/${config} -a ! -f ${S}/arch/arm64/configs/${config} ]; then
        bbnote "copy kernel config: $config"
        cp -f ${WORKDIR}/${config} ${S}/arch/arm64/configs/${config}
      fi
    done
  fi

  if [ -n "${deltaconfigs}" ]; then
    for deltacfg in "${deltaconfigs}"; do
      if [ -f ${WORKDIR}/${deltacfg} -a ! -f ${S}/arch/${ARCH}/configs/${deltacfg} ]; then
        bbnote "copy kernel delta config: $deltacfg"
        cp -f ${WORKDIR}/${deltacfg} ${S}/arch/arm64/configs/${deltacfg}
      fi
    done
  fi

  # Copy device trees
  if [ -n "${dtbes}" ]; then
    for dtbname in ${dtbes}; do
      dtsname=$(echo "${dtbname%%.*}.dts")
      dtsfile=$(basename -- $dtsname)
      if [ -f ${WORKDIR}/$dtsfile ]; then
        if [ ! -d ${S}/arch/arm64/boot/dts/adlink ]; then
          mkdir -p ${S}/arch/arm64/boot/dts/adlink/
        fi
        bbnote "copy kernel dts: $dtsfile"
        cp -f ${WORKDIR}/$dtsfile ${S}/arch/arm64/boot/dts/adlink/
        if [ -f ${S}/arch/arm64/boot/dts/adlink/Makefile ]; then
          if ! grep -q $dtbname ${S}/arch/arm64/boot/dts/adlink/Makefile; then
            bbnote "Makefile: add $dtbname"
            echo "dtb-\$(CONFIG_ARCH_MXC) += ${dtsfile%%.*}.dtb" >> ${S}/arch/arm64/boot/dts/adlink/Makefile
          fi
        fi
      fi
    done
  fi
}

addtask copy_source before do_validate_branches after do_kernel_checkout

RDEPENDS_${PN} += "kernel-devsrc"
