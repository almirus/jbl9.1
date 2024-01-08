#!/bin/sh
##################################
##################################
      ## MAGPIE Unload  ##
##################################
##################################


#
# List all VAPs
#
VAPLIST=`ifconfig | grep ath | cut -b 1-4`

if [ "${VAPLIST}" != "" ]; then

    for i in $VAPLIST
    do
        #
        # Remove from Bridge
        #
        #brctl delif br0 $i
        #sleep 2
        #
        # Bring the interface down
        #
        ifconfig $i down
        sleep 1
    done
fi

rmmod hst_acl.ko
rmmod hst_ath.ko
rmmod hst_tx99.ko
rmmod hst_scanap.ko
rmmod hst_rate.ko
rmmod hst_scansta.ko
rmmod hst_ccmp.ko
rmmod hst_tkip.ko
rmmod hst_wep.ko
rmmod hst_xauth.ko
rmmod hst_wlan.ko
rmmod hst_hal.ko
rmmod hst_htc.ko
rmmod if_ath_usb.ko
rmmod hif_usb.ko
rmmod adf.ko

