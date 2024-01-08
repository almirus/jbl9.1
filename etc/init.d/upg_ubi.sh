#! /bin/sh
#

echo "=== Upgrade Ubi Script Start Runing ==="

lsmod

echo "=== Upgrade Program Will Run ==="

chmod +x /mnt/ubi_boot/upgbinary.bin
#/mnt/ubi_boot/upgbinary.bin

/etc/init.d/init 4