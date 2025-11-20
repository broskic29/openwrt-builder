# Name of the Docker image to build
IMAGE_NAME := openwrt-builder

# Bin output directory on your Mac
OUTPUT := $(CURDIR)/bin

PROFILE="rpi-4"
PACKAGES="luci vim htop curl wget bash lighttpd luci-app-nlbwmon nlbwmon luci-app-qos sqm-scripts collectd collectd-mod-network logrotate tcpdump git"
FILES="files"
ROOTFS_PARTSIZE=2048
BIN_DIR="/builder/bin"


# -------------------------
# Targets
# -------------------------

.PHONY: all build run shell clean

# Default target: build firmware
all: run

# Build Docker image
build:
	docker build \
		--platform linux/amd64 \
		-t $(IMAGE_NAME) .

# Run ImageBuilder and produce custom OpenWrt firmware
run: build
	mkdir -p $(OUTPUT)
	docker run --rm \
		--platform linux/amd64 \
		-v $(OUTPUT):/builder/bin \
		$(IMAGE_NAME)

# Run ImageBuilder without building image first
run_no_build:
	mkdir -p $(OUTPUT)
	docker run --rm \
		--platform linux/amd64 \
		-v "$(PWD)/files":/builder/files \
		-v $(OUTPUT):/builder/bin \
		openwrt/imagebuilder:bcm27xx-bcm2711-24.10.1 \
		make -j $(nproc) V=s image PROFILE=$(PROFILE) FILES=$(FILES) PACKAGES=$(PACKAGES) ROOTFS_PARTSIZE=$(ROOTFS_PARTSIZE) BIN_DIR=$(BIN_DIR)

# Open interactive shell inside the builder container (for debugging/custom builds)
shell: build
	docker run --rm -it \
		-v $(OUTPUT):/builder/bin \
		$(IMAGE_NAME) bash

# Delete build outputs (not the Docker image)
clean:
	rm -rf $(OUTPUT)/*

