# openwrt-builder

Materials concerning the configuration of OpenWRT-based network management using a Raspberry Pi 4 as router.

Contains a custom build configuration for openwrt imagebuilder. 

Plug-and-play kernel build to support: https://github.com/broskic29/quota-manager

Known issues:
Flashing an RPi4 with this image will not exactly be plug-and-play just yet. There are some
issues with the timing of interfaces coming up on first boot. Still resolving.

For now, users can flash the build contained on the `test/simplest_config` branch, then manually add everything else.
Detailed instructions to come.
