FROM openwrt/imagebuilder:bcm27xx-bcm2711-24.10.1
WORKDIR /builder

ENV PACKAGES="\
# Base utilities
bash curl wget vim git openssl-util ca-certificates \
\
# Networking & routing
ipset ip-full kmod-veth kmod-ipt-conntrack kmod-nft-nat kmod-nf-nathelper \
kmod-usb-net kmod-usb-net-rtl8152 iptables-mod-extra \
iptables-mod-conntrack-extra iptables-mod-quota2 \
iptables-mod-trace \
\
# Services & servers
lighttpd luci luci-app-nlbwmon nlbwmon luci-app-qos \
sqm-scripts collectd collectd-mod-network logrotate \
tcpdump msmtp ca-bundle\
\
# OpenSSH
openssh-client openssh-server openssh-sftp-server \
\
# OpenSSL Legacy for RADIUS
libopenssl-legacy \
\
# Python
python3 python3-pip python3-sqlite3 python3-pyroute2\
\
# CLI apps
sqlite3-cli \
\
# Docker
docker docker-compose \
\
# QoS / firewall / monitoring
luci-app-nft-qos \
\
# RADIUS server for AAA
freeradius3-default freeradiuse-mod-sql-sqlite \
\
# Removing dropbear
-dropbear -dropbear-openssl \
"

ENV PROFILE="rpi-4"
ENV FILES="files"
ENV ROOTFS_PARTSIZE="2048"
ENV BIN_DIR="/builder/bin"

# Copy files/ into imagebuilder root
COPY files/ files/

CMD ["sh", "-c", "make -j $(nproc) V=s image PROFILE=\"$PROFILE\" FILES=\"$FILES\" PACKAGES=\"$PACKAGES\" ROOTFS_PARTSIZE=\"$ROOTFS_PARTSIZE\" BIN_DIR=\"$BIN_DIR\""]