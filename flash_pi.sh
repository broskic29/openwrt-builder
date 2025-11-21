while getopts "d:" opt; do
  case $opt in
    d) DISK_NAME=$OPTARG ;;
  esac
done

gunzip 
diskutil unmountDisk $DISK_NAME
sudo dd if=$PWD/bin/openwrt-24.10.1-bcm27xx-bcm2711-rpi-4-ext4-factory.img of=$DISK_NAME bs=4M status=progress conv=sync
sync
diskutil eject $DISK_NAME