#!/bin/sh

channel="11"
WPA=""
passphrase=""

# Store last 3-digit of MAC to n5 n6 n7 for SoftAP SSID
MAC="$(ifconfig wlan0 | head -1)"
lowMAC1=$(echo $MAC | cut -d':' -f7)
lowMAC2=$(echo $MAC | cut -d':' -f6)
lowMAC3=$(echo $MAC | cut -d':' -f5)
modelName=WAC
SSID="${modelName}_${lowMAC3}${lowMAC2}${lowMAC1}"

WAC_SOFTAP_CONF="/tmp/wac_softap_tmp.conf"
echo "=================================================="
echo "Create softap configuration file \"$WAC_SOFTAP_CONF ---\""
echo "=================================================="
echo -e "interface=ap0" > $WAC_SOFTAP_CONF
echo -e "ssid=$SSID" >> $WAC_SOFTAP_CONF
echo -e "hw_mode=g" >> $WAC_SOFTAP_CONF
echo -e "channel=$channel" >> $WAC_SOFTAP_CONF
echo -e "ieee80211n=1" >> $WAC_SOFTAP_CONF
echo -e "ctrl_interface=/var/run/hostapd" >> $WAC_SOFTAP_CONF
echo -e "driver=nl80211" >> $WAC_SOFTAP_CONF
echo -e "ignore_broadcast_ssid=0" >> $WAC_SOFTAP_CONF
#echo -e "wps_state=0" >> $WAC_SOFTAP_CONF
#echo -e "wps_pin_requests=/var/run/hostapd_wps_pin_requests" >> $WAC_SOFTAP_CONF
#echo -e "ap_pin=12345670" >> $WAC_SOFTAP_CONF
if [ x$WPA = x"1" -o x$WPA = x"2" ]; then
	echo -e "wpa=$WPA" >> $WAC_SOFTAP_CONF
	echo -e "wpa_key_mgmt=WPA-PSK" >> $WAC_SOFTAP_CONF
	if [ x$passphrase = "x" ]; then
		passphrase="12345678"			
	fi
	echo -e "wpa_passphrase=$passphrase" >> $WAC_SOFTAP_CONF
fi

echo --- hostapd: Start hostapd now! ---
/usr/bin/hostapd -B $WAC_SOFTAP_CONF
#start hostapd
echo --- hostapd: Start hostapd end! ---