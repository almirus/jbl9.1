#! /bin/sh
#
echo "upg_prog.sh content start..."
#1.kill all process

PIDS=`ps x|grep -v [[]|grep -v "init"|grep -v "sh"|grep -v "upgprog"|grep -v "ps"|grep -v "grep"|grep -v PID|awk '{print $1}'`

kill -9 $PIDS
killall lircd_simulator

echo "kill all process successful!"

#2.copy necessary files to /root (/bin, /sbin, /lib, /dev¡­)
#cp -rf /etc/init.d/upg_prog /root
cp -rf /bin /root
cp -rf /sbin /root
mkdir /root/lib
cp -rf /lib/*  /root/lib/
cp -rf /dev /root
cp -rf /var /root

if [ $? -ne 0 ]; then
   echo "copy necessary files to /root fail!"
   exit 1
fi

echo "copy necessary files to /root successful!"

#3.try to copy mac addr and key block files from nand to /root

cp -f /misc/network.ini /root
if [ $? -ne 0 ]; then
   echo "try to save mac addr files to /root fail!"
else
   echo "save mac addr files to /root success!"
fi

cp -f /mnt/BdpInfo1/key_block.dat /root
if [ $? -ne 0 ]; then
   echo "try to save key_block files to /root fail!"
else
   echo "save key_block files to /root success!"
fi

#4.unmount ubifs(for flushing data into nand) and ramfs(for saving dram usage)

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

if [ $? -ne 0 ]; then
   echo "umount ramfs fail!"
else
   echo "umount ramfs successful!"
fi


#Initialize new environment (ex. Mount /proc)
echo "------Initialize new environment ------"
mkdir /proc
mount -t proc none /proc


#Run upgprog
echo "------return to upgprog------"

