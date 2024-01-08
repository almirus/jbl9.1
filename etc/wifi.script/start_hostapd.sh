#!/bin/sh

channel="11"
WPA=""
passphrase=""

if [ $# -gt 0 ]; then
    for arg in "$@"
	do
	  if [ "${arg:0:8}" = "channel=" ]; then
		    channel="${arg:8:3}"
		elif [ "${arg:0:4}" = "wpa=" ]; then
				WPA="${arg:4:1}"
		elif [ "${arg:0:11}" = "passphrase=" ]; then
				passphrase="${arg:11:64}"
		fi
	done
fi

if [ x$WPA = "x" ]; then
	echo "======= hostapd: channel=$channel Security Mode=OPEN ========"
elif [ x$WPA = x"1" ]; then
	echo "======= hostapd: channel=$channel Security Mode=WPA passphrase=$passphrase ========"
elif [ x$WPA = x"2" ]; then
	echo "======= hostapd: channel=$channel Security Mode=WPA2 passphrase=$passphrase ========"
else
	echo "======= hostapd: Invalid Security Mode, exit! ========"
	exit 1
fi


# Store last 3-digit of MAC to n5 n6 n7 for SoftAP SSID
MAC="$(ifconfig eth0 | head -1)"
lowMAC1=$(echo $MAC | cut -d':' -f7)
lowMAC2=$(echo $MAC | cut -d':' -f6)
lowMAC3=$(echo $MAC | cut -d':' -f5)
modelName="$(cat /tmp/modelName)"
if [  x${modelName} = "x" ]; then
	modelName=Sony_BDP
fi
SSID="${modelName}_${lowMAC3}${lowMAC2}${lowMAC1}"

HOSTAPD_CONF="/tmp/hostapd_tmp.conf"
echo "=================================================="
echo "hostapd: Create hostapd configuration file \"$HOSTAPD_CONF ---\""
echo "=================================================="
echo -e "interface=ap0" > $HOSTAPD_CONF
echo -e "ssid=$SSID" >> $HOSTAPD_CONF
echo -e "hw_mode=g" >> $HOSTAPD_CONF
echo -e "channel=$channel" >> $HOSTAPD_CONF
echo -e "ieee80211n=1" >> $HOSTAPD_CONF
echo -e "ctrl_interface=/var/run/hostapd" >> $HOSTAPD_CONF
echo -e "driver=nl80211" >> $HOSTAPD_CONF
echo -e "ignore_broadcast_ssid=0" >> $HOSTAPD_CONF
#echo -e "wps_state=0" >> $HOSTAPD_CONF
#echo -e "wps_pin_requests=/var/run/hostapd_wps_pin_requests" >> $HOSTAPD_CONF
#echo -e "ap_pin=12345670" >> $HOSTAPD_CONF
if [ x$WPA = x"1" -o x$WPA = x"2" ]; then
	echo -e "wpa=$WPA" >> $HOSTAPD_CONF
	echo -e "wpa_key_mgmt=WPA-PSK" >> $HOSTAPD_CONF
	if [ x$passphrase = "x" ]; then
		passphrase="12345678"			
	fi
	echo -e "wpa_passphrase=$passphrase" >> $HOSTAPD_CONF
fi

echo --- hostapd: Start hostapd now! ---
/usr/bin/hostapd -B $HOSTAPD_CONF
#start hostapd
echo --- hostapd: Start hostapd end! ---