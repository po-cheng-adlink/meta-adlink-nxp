#!/bin/sh

TOKEN_PRE="ghp_"
TOKEN_POST="DiFPUbMC2PjG06sFvpuDrsBdJAH5bO0bSQd9"
CWD=$(pwd)
PROGNAME="$CWD/imx-setup-release.sh"

if [ -z "$BUILD" ]; then
	BUILD="build"
fi

EULA=1 MACHINE=$MACHINE DISTRO=$DISTRO BUILD_DIR=$BUILD source $PROGNAME $@

CWD=$(pwd)
if [ -f ${CWD}/../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append ]; then
	cat ${CWD}/../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append >> ${CWD}/conf/bblayers.conf
fi
if [ -f ${CWD}/../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append ]; then
	cat ${CWD}/../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append >> ${CWD}/conf/local.conf
fi

echo "PA_USER ?= \"adlink-guest\"" >> ${CWD}/conf/local.conf
echo "PA_TOKEN ?= \""${TOKEN_PRE}${TOKEN_POST}"\"" >> ${CWD}/conf/local.conf

if [ ! -d ${CMD}/../sources/meta-nxp-deskop ]; then
	echo "BBMASK += \"imx-image-desktop.bbappend\"" >> ${CWD}/conf/local.conf;
	echo "BBMASK += \"adlink-image-installer.bbappend\"" >> ${CWD}/conf/local.conf;
fi

