#!/bin/sh

echo "enable wow wlan=$1"

#rmmod rtsta
if [ $1 == 7662 ]; then
iwpriv ra0 set wow_enable=1
iwpriv ra0 set wow_inband=1
elif [ $1 == 7603 ]; then
iwpriv ra0 set wow_enable=1
iwpriv ra0 set wow_inband=1
fi
