#!/bin/sh

echo "enable wow wlan=$1"

if [ $1 == 7662 ]; then
    echo "7662 wow"
    iwpriv ra0 set wow_enable=1
    iwpriv ra0 set wow_inband=1
    iwpriv ra0 set usbWOWSuspend=1
        
elif [ $1 == 7603 ]; then
    echo "7603 wow"
    iwpriv ra0 set wow_enable=1
    iwpriv ra0 set usbWOWSuspend=1
    
else
    echo "other wow"
    iwpriv ra0 set wow_enable=1
    #iwpriv ra0 mac 238=00e21580
    ifconfig p2p0 down
    ifconfig ra0 down

    #rmmod rtsta
    if [ $1 == 7601 ]; then
        echo "remove wlan mt7601 ko start"
        rmmod mtnet7601Usta 
        rmmod mt7601Usta 
        rmmod mtutil7601Usta
    elif [ $1 == 7650 ]; then
        echo "remove wlan mt7650 ko start"
        rmmod mt7650u_sta_net 
        rmmod mt7650u_sta 
        rmmod mt7650u_sta_util
    fi

/usr/bin/7603/wpa_cli -ira0 terminate

fi