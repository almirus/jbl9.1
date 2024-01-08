#!/bin/sh

ATH_MOD_PATH=/lib/modules/`uname -r`/BDP

insmod ${ATH_MOD_PATH}/adf.ko
insmod ${ATH_MOD_PATH}/hif_usb.ko
insmod ${ATH_MOD_PATH}/hst_htc.ko
insmod ${ATH_MOD_PATH}/hst_hal.ko
insmod ${ATH_MOD_PATH}/hst_wlan.ko
insmod ${ATH_MOD_PATH}/hst_rate.ko
insmod ${ATH_MOD_PATH}/hst_tx99.ko
insmod ${ATH_MOD_PATH}/hst_ath.ko 
insmod ${ATH_MOD_PATH}/if_ath_usb.ko
insmod ${ATH_MOD_PATH}/hst_scansta.ko
insmod ${ATH_MOD_PATH}/hst_scanap.ko
insmod ${ATH_MOD_PATH}/hst_xauth.ko
insmod ${ATH_MOD_PATH}/hst_wep.ko
insmod ${ATH_MOD_PATH}/hst_tkip.ko
insmod ${ATH_MOD_PATH}/hst_ccmp.ko
insmod ${ATH_MOD_PATH}/hst_acl.ko
