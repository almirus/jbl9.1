#!/bin/sh
##################################
##################################
      ## Start wpa_supplicant   ##
##################################
##################################

wpa_iface="ra0"
start_method="cmd"
need_update_config="0"
driver="CFG"
cred=""
WPA_CLI="/usr/bin/wpa_cli"

if [ $# -gt 0 ]; then
    for arg in "$@"
	do
		echo argument=$arg
		if [ ${arg} = "update_config=1" ]; then
			need_update_config="1"
		elif [ ${arg} = "WEXT" ]; then
			driver="WEXT"
		elif [ ${arg} = "WPS" ]; then
			cred="WPS"
		fi
	done
fi

echo "start to check wlan interface status ..."
i=10
status=""
while [ "$i" != 0 ]
do
	status=""
	status=$(ifconfig -a | grep ra0)
	echo ra0 status="$status"
	if [ "x$status" != "x" ]; then
		echo "interface ra0 is ready."
		wpa_iface="ra0"
		break
	fi
	
	status=""
	status=$(ifconfig -a | grep wlan0)
	echo wlan0 status="$status"
	if [ "x$status" != "x" ]; then
		echo "interface wlan0 is ready."
		wpa_iface="wlan0"
		break
	fi

	echo "[$((30-$i))]waiting for wlan interface to be ready..."
	sleep 1

	i=$(($i-1))
done

if [ -d "/chrome" ]; then
	start_method="service"
	echo "C4A is enabled, start wpa_supplicant with service method."
fi

if [ x"$start_method" = x"service" ]; then
	P2P_DEV_CONF="/mnt/ubi_boot/P2P_DEV_CONF"
	WPA_CONF="/data/wifi/wpa_supplicant.conf"
	CTRL_INTERFACE="/var/run/wpa_supplicant"
	WPA_CLI="/bin/wpa_cli"
else
	P2P_DEV_CONF="/tmp/P2P_DEV_CONF"
	WPA_CONF="/tmp/WPA_CONF"
	CTRL_INTERFACE="/var/run/wpa_supplicant"
	WPA_CLI="/usr/bin/wpa_cli"
fi

echo "Start wpa_supplicant: wpa_iface=$wpa_iface method=$start_method driver=$driver update_config=$need_update_config cred=$cred"
echo "WPA_CONF=$WPA_CONF, P2P_DEV_CONF=$P2P_DEV_CONF"
echo "wpa_cli path: $WPA_CLI"

if [ x"$start_method" = x"cmd" ]; then
	if [ ! -e $WPA_CONF ]; then
		echo "===== No $WPA_CONF, so create it. ====="
		echo "" > $WPA_CONF
	fi

	if [ x$(grep serial_number=12345678 $WPA_CONF) = "x" ]; then
		echo "===> Set configuration for WPA <==="
		echo -e "ctrl_interface=$CTRL_INTERFACE" > $WPA_CONF
		if [ x$need_update_config = x"1" ]; then
			echo -e "update_config=1" >> $WPA_CONF
		fi
		echo -e "ap_scan=1" >> $WPA_CONF
		echo -e "config_methods=virtual_display virtual_push_button" >> $WPA_CONF
		echo -e "device_name=RalinkLinuxClient" >> $WPA_CONF
		echo -e "manufacturer=Ralink Technology, Corp." >> $WPA_CONF
		echo -e "model_name=Ralink Wireless Linux Client" >> $WPA_CONF
		echo -e "model_number=RTSTA" >> $WPA_CONF
		echo -e "serial_number=12345678" >> $WPA_CONF
		echo -e "wowlan_triggers=magic_pkt" >> $WPA_CONF
		if [ x"$cred" = x"WPS" ]; then
			echo -e "wps_cred_processing=2" >> $WPA_CONF
		fi
	fi

	if [ ! -e $P2P_DEV_CONF ]; then
		echo "===== No $P2P_DEV_CONF, so create it. ====="
		echo "" > $P2P_DEV_CONF
	fi

	if [ x$(grep p2p_go_intent= $P2P_DEV_CONF) = "x" ]; then
		echo "===> Set configuration for P2P <==="        
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
		#echo -e "driver_param=shared_interface=p2p0" >> $P2P_DEV_CONF
		#echo -e "p2p_no_group_iface=1" >> $P2P_DEV_CONF
	fi
fi

echo "===> Start wpa_supplicant... <==="
echo "wlan interface status : "
ifconfig -a
echo "=====> $WPA_CONF : "
cat $WPA_CONF
echo "=====> $P2P_DEV_CONF : "
cat $P2P_DEV_CONF

if [ x"$start_method" = x"cmd" ]; then
	echo "===== start wpa_supplicant by cmd method ====="
	if [ ! -d "$CTRL_INTERFACE" ]; then
		mkdir -p "$CTRL_INTERFACE"
	fi

	if [ x$driver = x"WEXT" ]; then
		/usr/bin/wpa_supplicant -Dwext -i$wpa_iface -c $WPA_CONF -N -Dwext -ip2p0 -c $P2P_DEV_CONF -d -K -B
	else
		/usr/bin/wpa_supplicant -Dnl80211 -i$wpa_iface -c $WPA_CONF -N -Dnl80211 -ip2p0 -c $P2P_DEV_CONF -dd -K -B
	fi
	
	#change the access right of control interface
	chmod -R 777 $CTRL_INTERFACE
	chown -R system:system $CTRL_INTERFACE
elif [ x"$start_method" = x"service" ]; then
	echo "===== start wpa_supplicant by service method ====="
	if [ x"$(ls -l ${WPA_CONF} | grep rw-rw----)" = x ]; then
		chmod 0660 ${WPA_CONF}
		echo "===== set access right of ${WPA_CONF} to be 660. ====="
	fi
	if [ x"$(ls -l ${WPA_CONF} | grep wifi)" = x ]; then
		chown wifi:wifi ${WPA_CONF}
		echo "===== set owner and group of ${WPA_CONF} to be wifi:wifi. ====="
	fi

	if [ x"$(ls -l ${P2P_DEV_CONF} | grep rw-rw----)" = x ]; then
		chmod 0660 ${P2P_DEV_CONF}
		echo "===== set access right of ${P2P_DEV_CONF} to be 660. ====="
	fi
	if [ x"$(ls -l ${P2P_DEV_CONF} | grep wifi)" = x ]; then
		chown wifi:wifi ${P2P_DEV_CONF}
		echo "===== set owner and group of ${P2P_DEV_CONF} to be wifi:wifi. ====="
	fi
	
	start wpa_supplicant
	if [ $? -ne  0 ];then
		echo "start wpa_supplicant fail in start_rtsta.sh, and restart ..."
		start wpa_supplicant
	else
		echo "start wpa_supplicant service successful!"
   fi
else
	echo "Failed to start wpa_supplicant due to invalid start method!"
	exit 1
fi

echo "Start to check wpa_supplicant is ready or not..."
i=30
while [ "$i" != 0 ]
do
	$WPA_CLI -i$wpa_iface ping | grep PONG
	if [ x"$?" = x"0" ]; then
		echo "wpa_supplicant is ready."
		break
	else
		echo "[$((30-$i))] waiting for wpa_supplicant to be ready..."
		sleep 1
	fi
	i=$(($i-1))
done

#$WPA_CLI -i$wpa_iface log_level error

echo --- Start wpa_supplicant Completed! ---
exit 0


