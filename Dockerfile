FROM openwrt/imagebuilder:bcm27xx-bcm2711-24.10.1
WORKDIR /builder

ENV PROFILE="rpi-4"
ENV PACKAGES="luci vim htop curl wget bash lighttpd luci-app-nlbwmon nlbwmon luci-app-qos sqm-scripts collectd collectd-mod-network logrotate tcpdump git openssh-server openssh-sftp-server kmod-usb-net-rtl8152 tc kmod-sched-core kmod-sched iptables-mod-* kmod-ipt-* -dropbear-key -dropbear-default-config"
ENV FILES="files"
ENV ROOTFS_PARTSIZE="2048"
ENV BIN_DIR="/builder/bin"

# Copy files/ into imagebuilder root
COPY files/ files/

CMD ["sh", "-c", "make -j $(nproc) V=s image PROFILE=\"$PROFILE\" FILES=\"$FILES\" PACKAGES=\"$PACKAGES\" ROOTFS_PARTSIZE=\"$ROOTFS_PARTSIZE\" BIN_DIR=\"$BIN_DIR\""]