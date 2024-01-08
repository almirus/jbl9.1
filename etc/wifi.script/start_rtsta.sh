#!/bin/sh
##################################
##################################
      ## RTSTA   ##
##################################
##################################


#
# 
#
#RT_MOD_PATH=/usr/bin

#{RT_MOD_PATH}wpa_supplicant -i ra0 -c
#{RT_MOD_PATH}wpa_supplicant.conf.ralink -d

echo "install wlan=$1"

echo 3 > /proc/sys/vm/drop_caches

RT_MOD_PATH=/lib/modules/`uname -r`/BDP
if [ $1 == 7601 ]; then
    echo "install wlan mt7601 ko start"
    insmod ${RT_MOD_PATH}/mtutil7601Usta.ko
    insmod ${RT_MOD_PATH}/mt7601Usta.ko
    insmod ${RT_MOD_PATH}/mtnet7601Usta.ko    
elif [ $1 == 7650 ]; then
    echo "install wlan mt7650 ko start"
    #insmod ${RT_MOD_PATH}/rtsta.ko
    insmod ${RT_MOD_PATH}/mt7650u_sta_util.ko
    insmod ${RT_MOD_PATH}/mt7650u_sta.ko
    insmod ${RT_MOD_PATH}/mt7650u_sta_net.ko
fi

echo "install wlan ko finish"

CTRL_IFACE="/var/run/wpa_supplicant"

P2P_DEV_CONF="/tmp/P2P_DEV_CONF"
WPA_CONF="/tmp/WPA_CONF"

if [ $1 == 7601 ]; then
    echo -e "ctrl_interface=$CTRL_IFACE" > $WPA_CONF
		echo -e "ap_scan=1" >> $WPA_CONF
		echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
		echo -e "device_name=BD/DVD PLAYER" >> $WPA_CONF
		echo -e "device_type=8-0050F204-5"	>> $WPA_CONF
		echo -e "manufacturer=Sony Corporation" >> $WPA_CONF
		echo -e "model_name=BD/DVD PLAYER" >> $WPA_CONF
		echo -e "model_number=0" >> $WPA_CONF
		echo -e "serial_number=0" >> $WPA_CONF
		echo -e "os_version=80000000" >> $WPA_CONF
		echo -e "wps_cred_processing=1" >> $WPA_CONF
elif [ $1 == 7650 ]; then
    echo -e "ctrl_interface=$CTRL_IFACE" > $WPA_CONF
		echo -e "ap_scan=1" >> $WPA_CONF
		echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
		echo -e "device_name=BD/DVD HOME THEATRE SYSTEM" >> $WPA_CONF
		echo -e "device_type=11-0050F204-2"	>> $WPA_CONF
		echo -e "manufacturer=Sony Corporation" >> $WPA_CONF
		echo -e "model_name=BD/DVD HOME THEATRE SYSTEM" >> $WPA_CONF
		echo -e "model_number=0" >> $WPA_CONF
		echo -e "serial_number=0" >> $WPA_CONF
		echo -e "os_version=80000000" >> $WPA_CONF
		echo -e "wps_cred_processing=1" >> $WPA_CONF
elif [ $1 == pana ]; then
    echo -e "ctrl_interface=$CTRL_IFACE" > $WPA_CONF
    echo -e "ap_scan=1" >> $WPA_CONF
		echo -e "config_methods=virtual_display virtual_push_button keypad" >> $WPA_CONF
		echo -e "device_name=HTS" >> $WPA_CONF
		echo -e "manufacturer=Ralink" >> $WPA_CONF
		echo -e "model_name=BD Player" >> $WPA_CONF
		echo -e "model_number=000" >> $WPA_CONF
		echo -e "serial_number=000" >> $WPA_CONF
else
    echo -e "ctrl_interface=$CTRL_IFACE" > $WPA_CONF
    echo -e "ap_scan=1" >> $WPA_CONF
    echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
    echo -e "device_name=RalinkLinuxClient" >> $WPA_CONF
    echo -e "manufacturer=Ralink Technology, Corp." >> $WPA_CONF
    echo -e "model_name=Ralink Wireless Linux Client" >> $WPA_CONF
    echo -e "model_number=RTSTA" >> $WPA_CONF
    echo -e "serial_number=12345678" >> $WPA_CONF
fi


        
echo -e "ctrl_interface=$CTRL_IFACE" > $P2P_DEV_CONF
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
#echo -e "driver_param=shared_interface=p2p0" >> $P2P_DEV_CONF
#/usr/bin/wpa_supplicant -Dwext -i ra0 -c $WPA_CONF -B
#/usr/bin/wpa_supplicant -Dwext -ip2p0 -c $P2P_DEV_CONF -B
/usr/local/bin/wpa_supplicant -Dwext -ira0 -c $WPA_CONF -N -Dwext -ip2p0 -c $P2P_DEV_CONF -d -K -B

#/usr/bin/wpa_supplicant -i ra0 -c /usr/bin/wpa_supplicant.conf.ralink -d -B

#echo "Start to check wpa_supplicant is ready or not..."
#i=30
#while [ "$i" != 0 ]
#do
#	/usr/local/bin/wpa_cli -ira0 ping | grep PONG
#	if [ "$?" == "0" ]; then
#		echo "wpa_supplicant is ready."
#		break
#	else
#		echo "[$((30-$i))]waiting for wpa_supplicant to be ready..."
#		sleep 1
#	fi
#	i=$(($i-1))
#done
#
#/usr/bin/wpa_cli -ira0 log_level 4

#change the access right of control interface
chmod -R 777 $CTRL_IFACE
chown -R system:system $CTRL_IFACE

echo --- Start RTSTA! ---


