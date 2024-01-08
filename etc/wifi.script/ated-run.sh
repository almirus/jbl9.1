#!/bin/sh

MOD_PATH=/lib/modules/`uname -r`/BDP

#modify to enable EthConvertMode
sed -i 's/EthConvertMode=/EthConvertMode=dongle/g' /etc/Wireless/RT2870STA/RT2870STA.dat


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
insmod af_packet.ko

brctl addbr br0
brctl setfd br0 1
ifconfig ath0 192.168.0.1 up
ifconfig eth0 192.168.10.3 up
brctl addif br0 eth0
brctl addif br0 ath0
ifconfig eth0 0.0.0.0
ifconfig ath0 0.0.0.0
ifconfig br0 up
ifconfig br0 10.0.0.20

echo Starting ATED...

ated

