#!/bin/sh
##################################
##################################
      ## RT5370   ##
##################################
##################################


#/usr/bin/wpa_supplicant -i ra0 -c /usr/bin/wpa_supplicant.conf.ralink -d -B
/usr/bin/wpa_supplicant_ath -dd -Dathr -iwifi0 -c /usr/bin/wpa_supplicant_ath.conf &
echo --- Start ath RT5370 wpa ! ---


