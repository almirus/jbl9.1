#!/bin/sh

KERNELRELEASE=

if [ "`grep -w 3.10.26 /proc/version`" != "" ]; then
    KERNELRELEASE=3.10.26
else
    KERNELRELEASE=2.6.35
fi

ATH_MOD_PATH=/lib/modules/${KERNELRELEASE}/BDP

#@echo "install wlan=$1"

if [ $1 == dongle ]; then
#    insmod ${ATH_MOD_PATH}/hst_athwq.ko priority=99 policy=2
    insmod ${ATH_MOD_PATH}/hst_athwq.ko priority=38 policy=2
    insmod ${ATH_MOD_PATH}/adf.ko
    insmod ${ATH_MOD_PATH}/hif_usb.ko
    insmod ${ATH_MOD_PATH}/hst_htc.ko
    insmod ${ATH_MOD_PATH}/hst_hal.ko
    insmod ${ATH_MOD_PATH}/hst_wlan.ko
    insmod ${ATH_MOD_PATH}/hst_scansta.ko
    insmod ${ATH_MOD_PATH}/hst_rate.ko
    insmod ${ATH_MOD_PATH}/hst_tx99.ko
    insmod ${ATH_MOD_PATH}/hst_ath.ko
    insmod ${ATH_MOD_PATH}/if_ath_usb.ko
    insmod ${ATH_MOD_PATH}/hst_scanap.ko
    insmod ${ATH_MOD_PATH}/hst_xauth.ko
    insmod ${ATH_MOD_PATH}/hst_wep.ko
    insmod ${ATH_MOD_PATH}/hst_tkip.ko
    insmod ${ATH_MOD_PATH}/hst_ccmp.ko
    insmod ${ATH_MOD_PATH}/hst_acl.ko
elif [ $1 == 7601 ]; then
    echo "install wlan mt7601 ko start"
    insmod ${ATH_MOD_PATH}/mtutil7601Usta.ko
    insmod ${ATH_MOD_PATH}/mt7601usta.ko
    insmod ${ATH_MOD_PATH}/mtnet7601Usta.ko
elif [ $1 == 7603 ]; then
    echo "install wlan mt7603 ko start"
    insmod ${ATH_MOD_PATH}/cfg80211.ko 
    insmod ${ATH_MOD_PATH}/mt7603u_sta.ko   
elif [ $1 == 7650 ]; then
    echo "[Wi-Fi] install wlan mt7650 ko start"
    insmod ${ATH_MOD_PATH}/cfg80211.ko 
    insmod ${ATH_MOD_PATH}/mt7650u_sta.ko
elif [ $1 == 7662 ]; then
    echo "[Wi-Fi] install wlan mt7662 ko start"
    insmod ${ATH_MOD_PATH}/compat.ko
    insmod ${ATH_MOD_PATH}/cfg80211.ko
    insmod ${ATH_MOD_PATH}/mac80211.ko
    insmod ${ATH_MOD_PATH}/mt7662u_sta.ko
elif [ $1 == marvell ]; then
    insmod ${ATH_MOD_PATH}/mlan.ko
    #insmod ${ATH_MOD_PATH}/usb8766.ko drv_mode=1 priority=38 
    lsmod | grep usb8xxx > /dev/null
    if [ $? -ne 0 ]; then
	  insmod ${ATH_MOD_PATH}/usb8766.ko drv_mode=1
    else
	  echo "[Wi-Fi] usb8766.ko already installed, Skip"
    fi
fi    

echo "[Wi-Fi] Wlan driver install finished"
