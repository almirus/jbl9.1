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


/usr/bin/wpa_cli -i ra0 terminate
echo --- Stop RT5370 wpa ! ---


