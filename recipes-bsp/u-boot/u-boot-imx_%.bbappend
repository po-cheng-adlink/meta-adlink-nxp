FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SPLASH_IMAGE ?= "splash.bmp"
UBOOT_UMS_IMAGE ?= "ums.bmp"

EXTRA_SRC = "${@d.getVarFlag('UBOOT_SRC_PATCHES', d.getVar('MACHINE'), True) or ''}"
SRC_URI:append = " ${EXTRA_SRC}"

do_copy_source () {
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  dtbes=$(echo "${UBOOT_DTB_NAME}" | xargs)
  srces=$(echo "${EXTRA_SRC}" | xargs)

  srcdir="${WORKDIR}/sources/${MACHINE}"

  bbnote "u-boot dtbes: ${dtbes}, srces: ${srces}"
  bbnote "Using source directory: ${srcdir}"

  # Copy config and dts
  for config in ${configs}; do
    if [ -f ${srcdir}/${config} ]; then
      bbnote "copy u-boot config: ${config} to ${S}/configs/"
      cp -f ${srcdir}/${config} ${S}/configs/
    else
      bbwarn "Missing ${srcdir}/${config}"
    fi
  done

  for dtbname in ${dtbes}; do
    dtsname=$(echo "${dtbname%%.*}.dts")

    if [ -f ${srcdir}/${dtsname} ]; then
      bbnote "copy u-boot dts: ${dtsname} to ${S}/arch/arm/dts/"
      cp -f ${srcdir}/${dtsname} ${S}/arch/arm/dts/

      if ! grep -q ${dtbname} ${S}/arch/arm/dts/Makefile; then
        bbnote "modify ${S}/arch/arm/dts/Makefile: add ${dtbname}"

        if [ "${MACHINE}" = "lec-imx95" ] || \
           [ "${MACHINE}" = "osm-imx93" ] || \
           [ "${MACHINE}" = "osm-imx95" ]; then
          sed -e 's,dtb-$(CONFIG_ARCH_IMX9) += \\,dtb-$(CONFIG_ARCH_IMX9) += \\\n\t'${dtbname}' \\,g' \
              -i ${S}/arch/arm/dts/Makefile
        else
          sed -e 's,dtb-$(CONFIG_ARCH_IMX8M) += \\,dtb-$(CONFIG_ARCH_IMX8M) += \\\n\t'${dtbname}' \\,g' \
              -i ${S}/arch/arm/dts/Makefile
        fi
      fi
    else
      bbwarn "Missing ${srcdir}/${dtsname}"
    fi
  done

  for src in ${srces}; do
    srcfile=$(basename -- ${src} | xargs)

    case "${srcfile}" in
      *.dtsi)
        if [ -f ${srcdir}/${srcfile} ]; then
          bbnote "copy u-boot dtsi: ${srcfile} to ${S}/arch/arm/dts/"
          cp -f ${srcdir}/${srcfile} ${S}/arch/arm/dts/
        else
          bbwarn "Missing ${srcdir}/${srcfile}"
        fi
        ;;
    esac
  done
}

addtask copy_source before do_patch after do_unpack

do_replace () {
  # replace printf Bad has value to show calculated hashes
  sed -e 's|memcmp(value, (const void \*)fit_hash,|memcmp(value, value,|g' \
      -i ${S}/arch/arm/mach-imx/spl.c
}

addtask replace before do_configure after do_patch

do_configure:prepend () {
  # Additional CONFIG_XXX for u-boot config
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
  extras=$(echo "${UBOOT_EXTRA_CONFIGS}" | xargs)

  bbnote "add ${extras} to ${configs}"

  for extra in ${extras}; do
    if [ -n "$extra" ]; then
      for config in ${configs}; do
        if [ -f ${S}/configs/${config} ]; then
          case "${extra}" in
            NO_*)
              upper=$(echo ${extra#NO_} | tr '[:lower:]' '[:upper:]')
              echo "CONFIG_${upper##CONFIG_}=n" >> ${S}/configs/${config}
              ;;
            *)
              upper=$(echo ${extra} | tr '[:lower:]' '[:upper:]')
              echo "CONFIG_${upper##CONFIG_}=y" >> ${S}/configs/${config}
              ;;
          esac
        fi
      done
    fi
  done
}

do_install:append () {
    install -d ${DEPLOY_DIR_IMAGE}

    if [ -f ${WORKDIR}/${MACHINE}/${UBOOT_SPLASH_IMAGE} ]; then
        install -m 0644 ${WORKDIR}/${MACHINE}/${UBOOT_SPLASH_IMAGE} \
            ${DEPLOY_DIR_IMAGE}/${UBOOT_SPLASH_IMAGE}
    else
        bbwarn "${S}/${UBOOT_SPLASH_IMAGE} not found. No splash image for u-boot"
    fi

    if [ -f ${WORKDIR}/${MACHINE}/${UBOOT_UMS_IMAGE} ]; then
        install -m 0644 ${WORKDIR}/${MACHINE}/${UBOOT_UMS_IMAGE} \
            ${DEPLOY_DIR_IMAGE}/${UBOOT_UMS_IMAGE}
    else
        bbwarn "${S}/${UBOOT_UMS_IMAGE} not found. No ums image for u-boot"
    fi
}
