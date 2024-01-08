#!/bin/sh

echo --- start wmn module load or unload ---

if [ "$1" == "adhoc" ]
then
	RT_MOD_PATH=/usr/sbin
	echo "adhoc driver path = ${RT_MOD_PATH}"
	ifconfig p2p0 down
	ifconfig ra0 down
	ifconfig ra0 up
	ifconfig p2p0 up
	#insmod ${RT_MOD_PATH}/wmn_xmit.ko
	#mknod /dev/xmit c 252 0
	insmod ${RT_MOD_PATH}/wmn_bcast.ko
	#insmod ${RT_MOD_PATH}/wmn_overlay.ko wired_ifname=eth0 wireless_ifname=ra0
	#insmod ${RT_MOD_PATH}/wmn_xmit.ko
	#mknod /dev/xmit c 252 0
else
	RT_MOD_PATH=/lib/modules/`uname -r`/BDP
	echo "infra driver path = ${RT_MOD_PATH}"
	rmmod wmn_bcast.ko

	ifconfig p2p0 down
	ifconfig ra0 down
	ifconfig ra0 up
	ifconfig p2p0 up

	#rmmod wmn_overlay.ko
	#rm -rf /dev/xmit
	#rmmod wmn_xmit.ko
	#ifconfig ra0 down
	#ifconfig ra0 up
fi
echo --- end wmn module load or unload ---


