#!/bin/sh
##################################
##################################
      ## RTSTA   ##
##################################
##################################

echo "install model=$1"
echo "install dongle=$2"
echo "install P2P region=$3"
echo "install P2P regionABand=$4"

device_type="11-0050F204-2"
model="MSA"
dongle="7662"
p2p_region="0"
p2p_region_aband="10"
start_model="service"
CTRL_INTERFACE=/var/run/wpa_supplicant

export PATH=/usr/bin/7603:$PATH

# Handle arguments
# start_rtsta_sony.sh model=MSA dongle=7662 p2p_reg=0 p2p_reg_aband=10
if [ $# -gt 0 ]; then
    for arg in "$@"
	do
		if [ ${arg:0:6} == "model=" ]; then
		    if [ ${arg:6:3} == "MSB" ]; then
			    model="MSB"
			    device_type="8-0050F204-5"
				start_model="cmd"
			fi
		elif [ ${arg:0:7} == "dongle=" ]; then
		    if [ ${arg:7:4} == "7603" ]; then
			    dongle="7603"
			fi
		elif [ ${arg:0:11} == "p2p_region=" ]; then
		    p2p_region=${arg:11:3}
		elif [ ${arg:0:17} == "p2p_region_aband=" ]; then
		    p2p_region_aband=${arg:17:3}
		fi
	done
fi

if [ "$dongle" != "7603" -a "$dongle" != "7662" ] || [ "$model" == "MSA" -a "$dongle" != "7662" ]; then
    echo "Invalid arguments found, please check!!"
	exit 1
fi

echo "=================================================="
echo "===  wpa_supplicant starting Args:"
echo "===  model=$model "
echo "===  dongle=$dongle "
echo "===  start_model=$start_model "
echo "===  p2p_region=$p2p_region "
echo "===  p2p_region_aband=$p2p_region_aband "
echo "=================================================="

# Install Wi-Fi driver
echo 3 > /proc/sys/vm/drop_caches
RT_MOD_PATH=/lib/modules/`uname -r`/BDP
if [ "$dongle" == "7603" ]; then
    echo "install wlan mt7603 ko start"
    insmod ${RT_MOD_PATH}/cfg80211.ko 
    insmod ${RT_MOD_PATH}/mt7603u_sta.ko      
elif [ "$dongle" == "7662" ]; then
    echo "install wlan mt7662 ko start"
    insmod ${RT_MOD_PATH}/compat.ko
    insmod ${RT_MOD_PATH}/cfg80211.ko
    insmod ${RT_MOD_PATH}/mac80211.ko
    insmod ${RT_MOD_PATH}/mt7662u_sta.ko
fi
echo "install wlan ko finish"

# Create config for Infra
if [ "$model" == "MSB" ]; then
	WPA_CONF="/tmp/wpa_supplicant.conf"
else
	WPA_CONF="/data/wifi/wpa_supplicant.conf"
fi

if [ x"`grep "wps_cred_processing" $WPA_CONF`" != "x" ] ; then
	echo "=================================================="
	echo "@@@ \"$WPA_CONF\" exist "
	echo "=================================================="
else
	echo "=================================================="
	echo "@@@ \"$WPA_CONF\" does not exist, create it "
	echo "=================================================="
	echo -e "ctrl_interface=$CTRL_INTERFACE" > $WPA_CONF
	echo -e "ap_scan=1" >> $WPA_CONF
	echo -e "config_methods=display push_button virtual_display virtual_push_button" >> $WPA_CONF
	echo -e "device_name=MEDIA PLAYER" >> $WPA_CONF
	echo -e "device_type=$device_type"	>> $WPA_CONF
	echo -e "manufacturer=Sony Corporation" >> $WPA_CONF
	echo -e "model_name=MEDIA PLAYER" >> $WPA_CONF
	echo -e "model_number=001" >> $WPA_CONF
	echo -e "serial_number=001" >> $WPA_CONF
	echo -e "os_version=80000000" >> $WPA_CONF
	echo -e "wps_cred_processing=1" >> $WPA_CONF
	echo -e "wowlan_triggers=magic_pkt" >> $WPA_CONF
fi

# Create config file for P2P
P2P_DEV_CONF="/mnt/ubi_boot/P2P_DEV_CONF"
P2P_DEV_CONF_BACKUP="/mnt/ubi_boot/P2P_DEV_CONF_BACKUP"
# If "/mnt/ubi_boot/P2P_DEV_CONF" exist
if [ x"`grep "serial_number=" $P2P_DEV_CONF`" != "x" ] ; then
	echo "=================================================="
	echo "@@@ \"$P2P_DEV_CONF\" exist "
	echo "=================================================="
	if [ "$dongle" == "7603" ]; then
		# Update "p2p_region" if it has changed
		if [ x"`grep "p2p_region=" $P2P_DEV_CONF`" != "x" ]; then
			if [ x"`grep "p2p_region=$p2p_region" $P2P_DEV_CONF`" == "x" ]; then
				sed -i "s/\(p2p_region=\)[^<]*\(.*\)/\1$p2p_region\2/" `grep "p2p_region=" -rl $P2P_DEV_CONF`
			fi
		else
			echo -e "p2p_region=$p2pRegion" >> $P2P_DEV_CONF
		fi
		# Update "p2p_region_aband" if it has changed
		if [ x"`grep "p2p_region_aband=" $P2P_DEV_CONF`" != "x" ]; then
			if [ x"`grep "p2p_region_aband=$p2p_region_aband" $P2P_DEV_CONF`" == "x" ]; then
				sed -i "s/\(p2p_region_aband=\)[^<]*\(.*\)/\1$p2p_region_aband\2/" `grep "p2p_region_aband=" -rl $P2P_DEV_CONF`
			fi
		else
			echo -e "p2p_region=$p2pRegion" >> $P2P_DEV_CONF
		fi
	fi
else
	echo "=================================================="
	echo "@@@ \"$P2P_DEV_CONF\" does not exist, create it "
	echo "=================================================="

	echo -e "ctrl_interface=$CTRL_INTERFACE" > $P2P_DEV_CONF
	echo -e "device_name=MEDIA PLAYER" >> $P2P_DEV_CONF
	echo -e "manufacturer=Sony Corporation" >> $P2P_DEV_CONF
	echo -e "model_name=MEDIA PLAYER" >> $P2P_DEV_CONF
	echo -e "device_type=$device_type" >> $P2P_DEV_CONF
	echo -e "config_methods=display push_button keypad virtual_display virtual_push_button" >> $P2P_DEV_CONF
	echo -e "persistent_reconnect=1" >> $P2P_DEV_CONF
	echo -e "update_config=1" >> $P2P_DEV_CONF
	echo -e "p2p_go_intent=13" >> $P2P_DEV_CONF
	echo -e "p2p_intra_bss=0" >> $P2P_DEV_CONF
	if [ "$dongle" == "7603" ]; then
		echo -e "p2p_oper_reg_class=81" >> $P2P_DEV_CONF
		echo -e "p2p_oper_channel=1" >> $P2P_DEV_CONF
	else
		echo -e "p2p_oper_reg_class=0" >> $P2P_DEV_CONF
		echo -e "p2p_oper_channel=0" >> $P2P_DEV_CONF
	fi
	echo -e "p2p_listen_reg_class=81" >> $P2P_DEV_CONF
	echo -e "p2p_listen_channel=1" >> $P2P_DEV_CONF
	echo -e "model_number=0" >> $P2P_DEV_CONF
	echo -e "serial_number=0" >> $P2P_DEV_CONF
	if [ "$dongle" == "7603" ]; then
		echo -e "p2p_region=$p2p_region" >> $P2P_DEV_CONF
		echo -e "p2p_region_aband=$p2p_region_aband" >> $P2P_DEV_CONF
	fi
	if [ x$dongle == x"7603" ]; then
	    echo -e "driver_param=shared_interface=p2p0" >> $P2P_DEV_CONF
	fi
	if [ x$dongle == x"7662" ]; then
	    echo -e "p2p_no_group_iface=1" >> $P2P_DEV_CONF
	fi
	
	echo === Make a backup of \"$P2P_DEV_CONF_BACKUP\" ===
	rm -rf $P2P_DEV_CONF_BACKUP
	cp -f $P2P_DEV_CONF $P2P_DEV_CONF_BACKUP
fi

# Start wpa_supplicant
if [ x"`ps | grep wpa_supplicant`" == x ]; then
	if [ "$start_model" == "service" ]; then
		start wpa_supplicant
		echo "start wpa_supplicant by service"
	else
	  if [ "$dongle" == "7603" ]; then
			/usr/bin/7603/wpa_supplicant -Dnl80211 -i ra0 -c $WPA_CONF -N -Dnl80211 -i p2p0 -c $P2P_DEV_CONF -dd &
	  else
			/usr/bin/wpa_supplicant -Dnl80211 -ira0 -c $WPA_CONF -N -Dnl80211 -ip2p0 -c $P2P_DEV_CONF -K &
	  fi
	  
		sleep 3
		echo "Check whether wpa_supplicant is started ..."
		i=0
		WPA_SUPPLICANT_UP=0
		while [ "$i" != "30" ]
		do
			wpa_cli -ira0 PING | grep PONG > /dev/null
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
		
		wpa_cli -ira0 log_level error
		
		echo "start wpa_supplicant by cmd"
	fi
else
	echo "wpa_supplicant is running, so return."
	exit 0
fi

chmod 777 -R $CTRL_INTERFACE

if [ "$dongle" == "7603" ]; then
	echo --- Start wpa_supplicant 2.0 end! ---
else
	echo --- Start wpa_supplicant 2.4 end! ---
fi
echo --- Start RTSTA! ---

exit 0


