#!/bin/sh
set -e

# Require root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

FLASH_ONLY=""

while getopts "d:f:c:oh" opt; do
  case "$opt" in
    d) DISK_NAME="$OPTARG" ;;
    f) FLASH_DISK_NAME="$OPTARG" ;;
    c) CONFIG_NAME="$OPTARG" ;;
    o) FLASH_ONLY=1 ;;
    h)
      echo "Usage: $0 -d disk -f flash_disk -c config [-o]"
      exit 0
      ;;
    *)
      echo "Invalid option"
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Validate required args
: "${DISK_NAME:?Missing -d disk}"
: "${DISK_NAME:?Missing -f flash_disk}"
: "${CONFIG_NAME:?Missing -c config}"

echo "About to write to $FLASH_DISK_NAME"
read -r -p "Type YES to continue: " confirm
[ "$confirm" = "YES" ] || exit 1

PROJECT_DIR="$HOME/Documents/projects/zambia/network_and_internet/openwrt-builder"
IMAGE_NAME="openwrt-24.10.1-bcm27xx-bcm2711-rpi-4-ext4-factory.img"
IMAGE_DIR="$PROJECT_DIR/images/$CONFIG_NAME"
IMAGE_PATH="$IMAGE_DIR/$IMAGE_NAME"

if [ -n "$FLASH_ONLY" ]; then
  diskutil unmountDisk "$DISK_NAME"
  dd if="$IMAGE_PATH" of="$FLASH_DISK_NAME" bs=4M status=progress
  sync
  diskutil eject "$DISK_NAME"
else
  cd "$PROJECT_DIR"
  make -j20

  mkdir -p "$IMAGE_DIR"
  cp "$PROJECT_DIR/bin/$IMAGE_NAME.gz" "$IMAGE_DIR"
  gunzip -f "$IMAGE_DIR/$IMAGE_NAME.gz"

  diskutil unmountDisk "$DISK_NAME"
  dd if="$IMAGE_PATH" of="$FLASH_DISK_NAME" bs=4M status=progress
  sync
  diskutil eject "$DISK_NAME"
fi
