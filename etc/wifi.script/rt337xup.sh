#!/bin/sh

MOD_PATH=/lib/modules/`uname -r`/BDP


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

insmod ${MOD_PATH}/rt3370sta.ko
insmod ${MOD_PATH}/af_packet.ko

#ifconfig ath0 up 192.168.1.2

