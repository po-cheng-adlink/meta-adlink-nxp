python () {
    import bb
    machine = d.getVar("MACHINE")
    if machine != "lec-imx8mp":
        bb.warn("k3s-worker being used on MACHINE='%s', but it is only tested for 'lec-imx8mp'" % machine)
}

# Add k3s to DISTRO_FEATURES
DISTRO_FEATURES:append = " virtualization k3s seccomp containers"

# K3s and container runtime packages
IMAGE_INSTALL:append = " \
    containerd-opencontainers \
    crictl \
    runc-opencontainers \
    cni \
    packagegroup-k3s-node \
    ca-certificates \
    kernel-modules \
"

# Disable k3s server (worker only)
SYSTEMD_AUTO_ENABLE:pn-k3s = "disable"

# Disable and mask Docker services (k3s uses containerd)
SYSTEMD_AUTO_ENABLE:pn-docker-moby = "disable"
SYSTEMD_AUTO_ENABLE:pn-docker = "disable"
SYSTEMD_MASKED_SERVICES:append = " docker.socket docker.service containerd.service"

# Remove docker packages
IMAGE_INSTALL:remove = "docker-moby docker"

# Rootfs size for k3s workloads
IMAGE_ROOTFS_SIZE = "20971520"
# Add k3s kernel config fragment for imx8mp

EXTRA_KERNEL_PATCHES += " file://lec-imx8mp/k3s.config \
"
DELTA_KERNEL_DEFCONFIG:append:lec-imx8mp = " k3s.config"

# DNS Configuration
ROOTFS_POSTPROCESS_COMMAND:append = " configure_k3s_dns; "

configure_k3s_dns() {
    bbnote "Configuring DNS for K3s worker node"

    rm -f ${IMAGE_ROOTFS}/etc/resolv.conf

    install -d ${IMAGE_ROOTFS}/etc/systemd/resolved.conf.d

    cat <<EOF > ${T}/k3s-dns.conf
[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=8.8.4.4 1.0.0.1
DNSSEC=no
DNSStubListener=no
Domains=~.
EOF

    install -m 0644 ${T}/k3s-dns.conf \
        ${IMAGE_ROOTFS}/etc/systemd/resolved.conf.d/k3s-dns.conf

    cat <<EOF > ${T}/resolv.conf
nameserver 8.8.8.8
nameserver 1.1.1.1
options timeout:2 attempts:3
EOF

    install -m 0644 ${T}/resolv.conf \
        ${IMAGE_ROOTFS}/etc/resolv.conf
}
