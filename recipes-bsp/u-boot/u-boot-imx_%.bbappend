do_configure_prepend () {
  extras=$(echo "${UBOOT_EXTRA_CONFIGS}" | xargs)
  configs=$(echo "${UBOOT_MACHINE}" | xargs)
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
