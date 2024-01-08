#! /bin/sh
#
set -x
echo "=== upgrade with pit changed Start ==="

#1.kill all process

PIDS=`ps x|grep -v [[]|grep -v "init"|grep -v "sh"|grep -v "upgprog"|grep -v "bdpprog"|grep -v "ps"|grep -v "grep"|grep -v PID|awk '{print $1}'`

kill -9 $PIDS

echo "kill all process successful!"

#2.copy necessary files to /root (/bin, /sbin, /lib, /dev, upg_2.sh¡­)
cp -rf /etc/init.d/upg_prog /root
echo "/etc/init.d/upg_prog /root successful!"

umount /mnt/nand_06_0
#umount /mnt/ubi_boot

if [ $? -ne 0 ]; then
   echo "umount ubifs fail!"
fi

echo "umount ubifs successful!"


if [ -f "/usr/local/bin/upgprog" ]; then	
		echo "upgprog exist "
fi
if [ -f "/tmp/upgbinary" ]; then
		chmod +x /tmp/upgbinary
		echo "upgbinary"	
fi

#Run upg_prog
echo "------upg program start run------"
/root/upg_prog 1
#/usr/local/bin/upgprog

if [ $? -ne 0 ]; then
   echo "upg_prog run fail!"
   exit 1
fi

