#! /bin/sh
#
set -x
echo $0
echo $@
echo "=== upgrade with pit changed Start ==="

#1.kill all process

PIDS=`ps x|grep -v [[]|grep -v "init"|grep -v "sh"|grep -v "upgprog"|grep -v "bdpprog"|grep -v "ps"|grep -v "grep"|grep -v PID|awk '{print $1}'`

kill -9 $PIDS

echo "kill all process successful!"

#2.copy necessary files to /root (/bin, /sbin, /lib, /dev, upg_2.sh¡­)
#cp -rf /etc/init.d/upgprog /root
#echo "C4A /etc/init.d/upgprog /root successful!"

#umount /mnt/nand_06_0
#umount /mnt/ubi_boot

#if [ $? -ne 0 ]; then
#   echo "umount ubifs fail!"
#fi

#echo "umount ubifs successful!"

# stop net_mgr to avoid it access to rootfs_normal
stop net_mgr


cat /proc/meminfo
#Run upg_prog
echo "------C4A upg program start run------"
if [ -f "/usr/local/bin/upgprog" ]; then
		echo "upgprog exist "
fi

if [ -f "/root/ota.zip" ]; then
		chmod +x /root/ota.zip
		echo "ota.zip"
fi
/usr/local/bin/upgprog 1 /root/ota.zip 1

if [ $? -ne 0 ]; then
   echo "upgprog run fail!"
   exit 1
fi

