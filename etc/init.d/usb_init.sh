echo "=== upgrade with pit changed Start ==="
# insmod usb driver(for bdp_v301_upg version specially)


insmod /lib/modules/2.6.27-mt85xx/BDP/nls_base.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/nls_cp437.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/nls_ascii.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/nls_iso8859-1.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/nls_utf8.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/fat.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/msdos.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/vfat.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/isofs.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/fuse.ko
insmod /lib/modules/2.6.27-mt85xx/BDP/udf.ko

sleep 2
insmod ./lib/modules/2.6.27-mt85xx/BDP/usbcore.ko
insmod ./lib/modules/2.6.27-mt85xx/BDP/mtk_hcd.ko
insmod ./lib/modules/2.6.27-mt85xx/BDP/usb-storage.ko

sleep 2
insmod ./lib/modules/2.6.27-mt85xx/BDP/cdrom.ko
insmod ./lib/modules/2.6.27-mt85xx/BDP/libata.ko
insmod ./lib/modules/2.6.27-mt85xx/BDP/sata_mt85xx_mod.ko
insmod ./lib/modules/2.6.27-mt85xx/BDP/sr_mod.ko

sleep 2
mkdir /mnt/usb

sleep 5
mount -t vfat /dev/sda1 /mnt/usb



