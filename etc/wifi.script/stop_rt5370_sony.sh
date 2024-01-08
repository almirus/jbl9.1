#!/bin/sh
##################################
##################################
      ## RT5370   ##
##################################
##################################


#
# 
#
#RT_MOD_PATH=/usr/bin

#{RT_MOD_PATH}wpa_supplicant -i ra0 -c
#{RT_MOD_PATH}wpa_supplicant.conf.ralink -d

#if [ -e /usr/bin/7603/wpa_cli ]; then
#	/usr/bin/7603/wpa_cli -i ra0 terminate
#else
#	/usr/bin/wpa_cli -i ra0 terminate
#fi
#echo --- Stop wpa_supplicant ! ---

DEV=ra0

echo "[Wi-Fi] Unloading Wi-Fi driver"
#ifconfig ra0 down
#ifconfig p2p0 down
echo "[Wi-Fi] remove rtsta"
#rmmod rtsta
echo "[Wi-Fi] remove rtsta end"
