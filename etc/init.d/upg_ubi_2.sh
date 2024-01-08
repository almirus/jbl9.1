#! /bin/sh
#

echo "=== upg_ubi2 Runing ==="

MODULE_DIR=/lib/modules/`uname -r`/BDP
MODULE_KOS=" nls_cp437.ko nls_ascii.ko nls_iso8859_1.ko nls_utf8.ko fat.ko vfat.ko msdos.ko isofs.ko udf.ko ntfs.ko usbcore.ko usb-storage.ko mtk_hcd.ko hid.ko usbhid.ko  af_packet.ko "

for MODULE_KO in $MODULE_KOS; do
    echo "insert module ${MODULE_DIR}/${MODULE_KO}"
    insmod ${MODULE_DIR}/${MODULE_KO}
    if [ $? -ne 0 ]; then
        echo "insert module ${MODULE_DIR}/${MODULE_KO} FAIL..."
    else
        echo "insert module ${MODULE_DIR}/${MODULE_KO} SUCCESS..."
    fi
done


sleep 2
mkdir /mnt/sda1
sleep 5
mount -t vfat /dev/sda1 /mnt/sda1

chmod +x /mnt/sda1/UPG/upgbinary.bin

/mnt/sda1/UPG/upgbinary.bin

