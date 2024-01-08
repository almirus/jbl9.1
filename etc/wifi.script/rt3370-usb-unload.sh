#!/bin/sh
##################################
##################################
      ## RT3370 Unload  ##
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

rmmod rtnet3370sta.ko
rmmod rt3370sta.ko
rmmod rtutil3370sta.ko

