#! /bin/sh
export PATH="$PATH:/usr/local/bin:/usr/net/vudu:/usr/net/browser/bin"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/net/vudu:/usr/net/browser/lib:/mnt/ubi_boot/forusb/bluetooth/usr/lib:/lib/directfb-1.2-0/systems:/usr/lib/ppc"

# Enable root login without password and disable cloud update
cp -rf /mnt/sda1/AutoScript/var/AutoScript.TSS /var/AutoScript.TSS

# Enable SSH
/usr/local/sbin/sshd -p 22 &

# Commit filesystem caches to disk
sync
sleep 5
umount /mnt/sda1