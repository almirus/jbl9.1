#! /bin/sh
#

echo "=== upg_2.sh Start ==="

#Initialize new environment (ex. Mount /proc)
mkdir /proc
mount -t proc none /proc

#Run upg_prog
echo "------upg program start run------"
/upg_prog
if [ $? -ne 0 ]; then
   echo "upg_prog run fail!"
   exit 1
fi

#reboot
echo "-------Now system restart--------"
reboot