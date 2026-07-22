FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_SRC = "${@d.getVarFlag('KERNEL_SRC_PATCHES', d.getVar('MACHINE'), True)}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {

  if [ -d ${WORKDIR}/sources/${MACHINE} ]; then
    SRC_BASE=${WORKDIR}/sources/${MACHINE}
  else
    SRC_BASE=${WORKDIR}/${MACHINE}
  fi

  configs=$(echo "${IMX_KERNEL_CONFIG_AARCH64}" | xargs)
  deltaconfigs=$(echo "${DELTA_KERNEL_DEFCONFIG}" | xargs)
  dtbes=$(echo "${KERNEL_DEVICETREE}" | xargs)
  extras=$(echo "${EXTRA_SRC}" | xargs)

  # Copy main kernel build config
  if [ -n "${configs}" ]; then
    for config in ${configs}; do
      if [ -f ${SRC_BASE}/${config} -a ! -f ${S}/arch/arm64/configs/${config} ]; then
        bbnote "copy kernel build config: $config to ${S}/arch/arm64/configs/${config}"
        cp -f ${SRC_BASE}/${config} ${S}/arch/arm64/configs/${config}
      fi
    done
  fi

  if [ -n "${deltaconfigs}" ]; then
    for deltacfg in ${deltaconfigs}; do
      if [ -f ${SRC_BASE}/${deltacfg} -a ! -f ${S}/arch/${ARCH}/configs/${deltacfg} ]; then
        bbnote "copy kernel delta config: $deltacfg to ${S}/arch/arm64/configs/${deltacfg}"
        cp -f ${SRC_BASE}/${deltacfg} ${S}/arch/arm64/configs/${deltacfg}
      fi
    done
  fi

  # copy dts, dtso and dtsi
  if [ -n "${extras}" -a -n "${dtbes}" ]; then
    if [ ! -d ${S}/arch/arm64/boot/dts/adlink ]; then
      bbnote "create ${S}/arch/arm64/boot/dts/adlink/ directory"
      mkdir -p ${S}/arch/arm64/boot/dts/adlink/

      if [ -f ${S}/arch/arm64/boot/dts/Makefile ]; then
        if ! grep -q "subdir-y.*adlink" ${S}/arch/arm64/boot/dts/Makefile; then
          bbnote "Makefile: modify to build ${S}/arch/arm64/boot/dts/adlink/ directory"
          echo "subdir-y += adlink" >> ${S}/arch/arm64/boot/dts/Makefile
        else
          bbnote "Makefile: Already building ${S}/arch/arm64/boot/dts/adlink/ directory"
        fi
      fi
    fi

    for extra in ${extras}; do
      extrafile=$(basename -- ${extra})
      extraname=$(echo ${extrafile%%.*})

      if [ -f ${SRC_BASE}/${extrafile} ]; then
        case ${extrafile} in
        *.dtsi)
          bbnote "copy kernel dtsi: ${extrafile}"
          cp -f ${SRC_BASE}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
          ;;
        *.h)
          bbnote "copy header file: ${extrafile}"
          cp -f ${SRC_BASE}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
          ;;
        *.dtso)
              dtbname=""
        for dtb in ${dtbes}; do
                echo "$dtb" | grep -q "${extraname}" && {
                dtbname=$(basename "$dtb")
                break
                }
        done
            if [ -n "${dtbname}" ]; then
            bbnote "copy kernel dtso: ${extrafile}"
            cp -f ${SRC_BASE}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
            if ! grep -q ${extraname} ${S}/arch/arm64/boot/dts/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtbo"
              echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtbo" >> ${S}/arch/arm64/boot/dts/adlink/Makefile
            fi
          fi
          ;;
        *.dts)
            dtbname=""
        for dtb in ${dtbes}; do
                case "$dtb" in
                *"${extraname}"*)
                dtbname=$(basename "$dtb")
                break
          ;;
        esac
        done

          if [ -n "${dtbname}" ]; then
            bbnote "copy kernel dts: ${extrafile} for ${dtbname}"
            cp -f ${SRC_BASE}/${extrafile} ${S}/arch/arm64/boot/dts/adlink/
            if ! grep -q ${extraname} ${S}/arch/arm64/boot/dts/adlink/Makefile; then
              bbnote "Makefile: add ${extraname}.dtb"
              echo "dtb-\$(CONFIG_ARCH_MXC) += ${extraname}.dtb" >> ${S}/arch/arm64/boot/dts/adlink/Makefile
            fi
          fi
          ;;
        esac
      fi
    done
  fi
}

addtask copy_source before do_validate_branches after do_kernel_checkout

RDEPENDS:${PN} += "kernel-devsrc"
