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
P2P_DEV_CONF="/tmp/P2P_DEV_CONF"
WPA_CONF="/tmp/WPA_CONF"
echo -e "ctrl_interface=/var/run/wpa_supplicant" > $WPA_CONF
echo -e "ap_scan=1" >> $WPA_CONF
echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
echo -e "device_name=RalinkLinuxClient" >> $WPA_CONF
echo -e "manufacturer=Ralink Technology, Corp." >> $WPA_CONF
echo -e "model_name=Ralink Wireless Linux Client" >> $WPA_CONF
echo -e "model_number=RT5370" >> $WPA_CONF
echo -e "serial_number=12345678" >> $WPA_CONF
        
echo -e "ctrl_interface=/var/run/wpa_supplicant" > $P2P_DEV_CONF
echo -e "device_name=Ralink-p2p-linux" >> $P2P_DEV_CONF
echo -e "manufacturer=Ralink" >> $P2P_DEV_CONF
echo -e "model_name=pb44" >> $P2P_DEV_CONF
echo -e "device_type=1-0050F204-1" >> $P2P_DEV_CONF
echo -e "config_methods=display keypad push_button" >> $P2P_DEV_CONF
echo -e "persistent_reconnect=1" >> $P2P_DEV_CONF
echo -e "p2p_go_intent=14" >> $P2P_DEV_CONF
echo -e "p2p_oper_reg_class=81" >> $P2P_DEV_CONF
echo -e "p2p_oper_channel=1" >> $P2P_DEV_CONF
echo -e "p2p_listen_reg_class=81" >> $P2P_DEV_CONF
echo -e "p2p_listen_channel=1" >> $P2P_DEV_CONF
echo -e "driver_param=shared_interface=p2p0" >> $P2P_DEV_CONF
#/usr/bin/wpa_supplicant -Dwext -i ra0 -c $WPA_CONF -B
#/usr/bin/wpa_supplicant -Dwext -ip2p0 -c $P2P_DEV_CONF -B
#/usr/bin/wpa_supplicant -Dwext -ira0 -c $WPA_CONF -N -Dwext -ip2p0 -c $P2P_DEV_CONF -B
/usr/bin/wpa_supplicant -Dwext -ira0 -c $WPA_CONF -d -K -B

#/usr/bin/wpa_supplicant -i ra0 -c /usr/bin/wpa_supplicant.conf.ralink -d -K -B

echo --- Start RT5370 p2p! ---


