#!/bin/bash -e

wget -P ${ROOTFS_DIR}/lib/firmware/brcm/ https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.bin
wget -P ${ROOTFS_DIR}/lib/firmware/brcm/ https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.txt

