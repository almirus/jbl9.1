#!/bin/sh
##################################
##################################
      ## RT5370 Unload  ##
##################################
##################################


#
# List all VAPs
#
VAPLIST=`ifconfig | grep ra | cut -b 1-4`

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


if [ "" != `lsmod | grep "5370sta"` ]; then
    rmmod rtnet5370sta.ko
    rmmod rt5370sta.ko
    rmmod rtutil5370sta.ko
elif [ "" != `lsmod | grep "3370sta"` ]; then
    rmmod rtnet3370sta.ko
    rmmod rt3370sta.ko
    rmmod rtutil3370sta.ko
fi
