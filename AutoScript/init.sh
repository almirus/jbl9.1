#! /bin/sh
export PATH="$PATH:/usr/local/bin:/usr/net/vudu:/usr/net/browser/bin"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/net/vudu:/usr/net/browser/lib:/mnt/ubi_boot/forusb/bluetooth/usr/lib:/lib/directfb-1.2-0/systems:/usr/lib/ppc"

# Enable root login without password
#/bin/echo root::0:0:root,,,:/root:/bin/sh > /etc/passwd

/usr/local/sbin/sshd -p 22 &

dmesg > /mnt/sda1/dmesg.log

# Commit filesystem caches to disk
sync
sleep 5
umount /mnt/sda1