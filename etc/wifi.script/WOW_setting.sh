#!/bin/sh

DONGLE_E2P_VALUE=$(iwpriv ra0 e2p 0 | grep "0x")
#DONGLE_TYPE=$(echo ${DONGLE_E2P_VALUE##*:} | sed 's/[ \t\r\n]*//g')
DONGLE_TYPE=0x7668

echo "Start WOW setting, WiFi dongle: ${DONGLE_TYPE}, standby mode: $1"

if [ "x$1" = "xNormal_Standby" ]; then
  echo "======= Enter Normal standby WOW setting ======="
  if [ "x${DONGLE_TYPE}" = "x0x7662" -o \
       "x${DONGLE_TYPE}" = "x0x7632" -o \
       "x${DONGLE_TYPE}" = "x0x7612" ]; then
    iwpriv ra0 set wow_enable=1
    iwpriv ra0 set wow_inband=1
    iwpriv ra0 set usbWOWSuspend=1
  elif [ "x${DONGLE_TYPE}" = "x0x7603" ]; then
    iwpriv ra0 set wow_enable=1
    iwpriv ra0 set usbWOWSuspend=1
  elif [ "x${DONGLE_TYPE}" = "x0x7668" ]; then
    iwpriv wlan0 driver "set_wow_enable 1"
    iwpriv wlan0 driver "usbWOWSuspend 1"	
  else    
    iwpriv ra0 set wow_enable=1
    #iwpriv ra0 mac 238=00e21580
    ifconfig p2p0 down
    ifconfig ra0 down
    rmmod rtsta
  fi
   
  #wpa_cli -ira0 terminate
elif [ "x$1" = "xSTR_Standby" ]; then
  echo "======= Enter STR standby WOW setting ======="
  if [ "x${DONGLE_TYPE}" = "x0x7662" -o \
       "x${DONGLE_TYPE}" = "x0x7632" -o \
       "x${DONGLE_TYPE}" = "x0x7603" ]; then
    iwpriv ra0 set wow_enable=1
    iwpriv ra0 set wow_inband=1
  elif [ "x${DONGLE_TYPE}" = "x0x7601" ]; then
    iwpriv ra0 set wow_enable=0
  elif [ "x${DONGLE_TYPE}" = "x0x7668" ]; then
    iwpriv wlan0 driver "set_wow_enable 1"  
  else
    iwpriv ra0 set usbWOWSuspend=1
  fi
else
  echo "!! Not support standby mode."
  exit 1
fi

echo "WOW Setting done."
exit 0
