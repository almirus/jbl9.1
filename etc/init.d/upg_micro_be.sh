#! /bin/sh
#

echo "=== upgrade with pit changed Start ==="

echo "for reboot para to rc6 then call rc.fast_reboot"
echo 6 > /6

#1.kill all process

PIDS=`ps|grep -v [[]|grep -v " init "|grep -v upg_micro_be|grep -v PID|cut -c1-6`

kill -9 $PIDS

echo "2 kill all process successful!"

cp -rf /etc/init.d/upg_prog /root

umount /mnt/nand_06_0
umount /mnt/ubi_boot

if [ $? -ne 0 ]; then
   echo "umount ubifs fail!"
#   exit 1
fi

echo "umount ubifs successful!"

#umount ramfs except /root

#umount /var
#umount /tmp
#umount /mnt

if [ $? -ne 0 ]; then
   echo "umount ramfs fail!"
else
   echo "umount ramfs successful!"
fi


#Run upg_prog
echo "------upg program start run------"
/root/upg_prog
if [ $? -ne 0 ]; then
   echo "upg_prog run fail!"
   exit 1
fi

#reboot
echo "-------Now system restart--------"
reboot