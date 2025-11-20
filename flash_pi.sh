
diskutil unmountDisk $(DISK_NAME)
sudo dd if=/Users/melchizedek/Documents/projects/zambia/network_and_internet/openwrt-builder/bin/openwrt-24.10.1-bcm27xx-bcm2711-rpi-4-ext4-factory.img of=$(DISK_NAME) bs=4M status=progress conv=sync
sync
diskutil eject $(DISK_NAME)