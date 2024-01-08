#!/bin/sh

ATH_MOD_PATH=/lib/modules/2.6.35/BDP/

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
elif [ $1 == builtin ]; then
    insmod ${ATH_MOD_PATH}/rtutil3370sta.ko
    insmod ${ATH_MOD_PATH}/rt3370sta.ko
    insmod ${ATH_MOD_PATH}/rtnet3370sta.ko priority=38
fi

