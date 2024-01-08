#!/bin/sh
##################################
##################################
      ## RT5370   ##
##################################
##################################

echo ">>>> this script is used to bringup wpa_supplicant"
#
# 
#
#RT_MOD_PATH=/usr/bin
CTRL_INTERFACE=/var/run/wpa_supplicant

P2P_DEV_CONF="/tmp/P2P_DEV_CONF"
WPA_CONF="/tmp/WPA_CONF"
echo -e "ctrl_interface=$CTRL_INTERFACE" > $WPA_CONF
echo -e "ap_scan=1" >> $WPA_CONF
echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
echo -e "device_name=RalinkLinuxClient" >> $WPA_CONF
echo -e "manufacturer=Ralink Technology, Corp." >> $WPA_CONF
echo -e "model_name=Ralink Wireless Linux Client" >> $WPA_CONF
echo -e "model_number=RT5370" >> $WPA_CONF
echo -e "serial_number=12345678" >> $WPA_CONF
        
echo -e "ctrl_interface=$CTRL_INTERFACE" > $P2P_DEV_CONF
echo -e "device_name=Ralink-p2p-linux" >> $P2P_DEV_CONF
echo -e "manufacturer=Ralink" >> $P2P_DEV_CONF
echo -e "model_name=pb44" >> $P2P_DEV_CONF
echo -e "device_type=1-0050F204-1" >> $P2P_DEV_CONF
#echo -e "config_methods=display keypad push_button" >> $P2P_DEV_CONF
echo -e "persistent_reconnect=1" >> $P2P_DEV_CONF
echo -e "p2p_go_intent=14" >> $P2P_DEV_CONF
#echo -e "p2p_oper_reg_class=81" >> $P2P_DEV_CONF
echo -e "p2p_oper_channel=1" >> $P2P_DEV_CONF
#echo -e "p2p_listen_reg_class=81" >> $P2P_DEV_CONF
echo -e "p2p_listen_channel=1" >> $P2P_DEV_CONF
echo -e "driver_param=shared_interface=p2p0" >> $P2P_DEV_CONF
#/usr/bin/wpa_supplicant -Dwext -i ra0 -c $WPA_CONF -B
#/usr/bin/wpa_supplicant -Dwext -ip2p0 -c $P2P_DEV_CONF -B

if [ x"$1" = x"wlan0" ]; then
  	/system/bin/wpa_supplicant -Dnl80211 -iwlan0 -c $WPA_CONF -N -Dnl80211 -ip2p0 -c $P2P_DEV_CONF -qq -K &      
else
  	/system/bin/wpa_supplicant -Dwext -ira0 -c $WPA_CONF -N -Dwext -ip2p0 -c $P2P_DEV_CONF -qq -K &
fi

	sleep 3
	echo "Check whether wpa_supplicant is started ..."
	i=0
	WPA_SUPPLICANT_UP=0
	while [ "$i" != "30" ]
	do
		wpa_cli -i"$1" PING | grep PONG > /dev/null
		if [ "$?" = "0" ]; then
			echo "wpa_supplicant is ready."
			WPA_SUPPLICANT_UP=1
			break
		else
			echo "Waiting wpa_supplicant to be ready ..."
			sleep 0.5
		fi
		i=$(($i+1))
	done
	if [ "$WPA_SUPPLICANT_UP" != "1" ]; then
		echo "!!Failed to start wpa_supplicant."
		exit 1
	fi
	
	wpa_cli -i"$1" log_level error
	
	echo "start wpa_supplicant by cmd"

chmod 777 -R $CTRL_INTERFACE
echo --- Start RT5370 p2p! ---

ifconfig ap0 up
HOSTAPD_CONF="/tmp/hostapd.conf"
echo "=================================================="
echo "hostapd: Create hostapd configuration file \"$HOSTAPD_CONF ---\""
echo "=================================================="
echo -e "interface=ap0" > $HOSTAPD_CONF
echo -e "ssid=MediatekAudio_AP" >> $HOSTAPD_CONF
echo -e "hw_mode=g" >> $HOSTAPD_CONF
echo -e "channel=6" >> $HOSTAPD_CONF
echo -e "ieee80211n=1" >> $HOSTAPD_CONF
echo -e "ctrl_interface=/var/run/hostapd" >> $HOSTAPD_CONF
echo -e "driver=nl80211" >> $HOSTAPD_CONF
echo -e "ignore_broadcast_ssid=0" >> $HOSTAPD_CONF

