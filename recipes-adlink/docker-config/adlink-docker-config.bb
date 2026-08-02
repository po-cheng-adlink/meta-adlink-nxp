SUMMARY = "LEC-iMX8MP Docker runtime configuration"
DESCRIPTION = "Docker daemon configuration for LEC-iMX8MP: nftables firewall \
backend, a pinned docker0 bridge subnet, and IPv4 forwarding."
LICENSE = "CLOSED"

do_install() {
    install -d ${D}${sysconfdir}/docker
    printf '{\n    "firewall-backend": "nftables",\n    "bip": "172.20.0.1/24",\n    "default-address-pools": [\n        { "base": "172.21.0.0/16", "size": 24 }\n    ]\n}\n' > ${D}${sysconfdir}/docker/daemon.json

    install -d ${D}${sysconfdir}/sysctl.d
    printf 'net.ipv4.ip_forward=1\n' > ${D}${sysconfdir}/sysctl.d/60-docker-ipforward.conf

    install -d ${D}${sysconfdir}/systemd/system/docker.service.d
    printf '[Service]\nExecStart=\nExecStart=/usr/bin/dockerd --data-root /var/lib/docker -H fd://\n' > ${D}${sysconfdir}/systemd/system/docker.service.d/10-fix-bip.conf
}

FILES:${PN} = " \
    ${sysconfdir}/docker/daemon.json \
    ${sysconfdir}/sysctl.d/60-docker-ipforward.conf \
    ${sysconfdir}/systemd/system/docker.service.d/10-fix-bip.conf \
"
CONFFILES:${PN} = "${sysconfdir}/docker/daemon.json"
