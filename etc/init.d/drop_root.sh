#! /bin/sh
#

echo "bdp drop root"

#chmod 0777 /dev
chmod 0777 /tmp
#chmod 0777 /mnt
chown -R system:system /mnt/ubi_boot
