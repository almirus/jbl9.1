#!/bin/sh

MOD_PATH=/lib/modules/`uname -r`/BDP

#Create a symbolic link to unload script as reboot command invokes
# killVAP script

#ln -sf /etc/ath/magpie-usb-unload /etc/ath/killVAP

#Export Environment Variables
#. /etc/ath/magpie-apcfg

#install usb ko first if needed
usbcore_installed=$(lsmod | grep "usbcore")
mtk_hcd_installed=$(lsmod | grep "mtk_hcd")
if [ "$usbcore_installed" == "" ]; then
    echo --- Installing usbcore.ko ---
    insmod ${MOD_PATH}/usbcore.ko
fi
if [ "$mtk_hcd_installed" == "" ]; then
    echo --- Installing mtk_hcd.ko ---
    insmod ${MOD_PATH}/mtk_hcd.ko
fi

insmod ${MOD_PATH}/adf.ko
insmod ${MOD_PATH}/hif_usb.ko
insmod ${MOD_PATH}/hst_htc.ko
insmod ${MOD_PATH}/hst_hal.ko
insmod ${MOD_PATH}/hst_wlan.ko
insmod ${MOD_PATH}/hst_scansta.ko
insmod ${MOD_PATH}/hst_rate.ko
insmod ${MOD_PATH}/hst_tx99.ko
insmod ${MOD_PATH}/hst_ath.ko
insmod ${MOD_PATH}/if_ath_usb.ko
insmod ${MOD_PATH}/hst_scanap.ko
insmod ${MOD_PATH}/hst_xauth.ko
insmod ${MOD_PATH}/hst_wep.ko
insmod ${MOD_PATH}/hst_tkip.ko
insmod ${MOD_PATH}/hst_ccmp.ko
insmod ${MOD_PATH}/hst_acl.ko

#sleep 2

insmod af_packet.ko

#athcfg wifi0 vapcreate set ath0 infra-sta 1
#athcfg ath0 mode set AUTO

#ifconfig br0 192.168.2.2
#ifconfig ath0 192.168.1.2 up


