#! /bin/sh

PIDS=`ps|grep -v " init "|grep -v nw_upg_daemon | grep -v PID | grep -v sh |awk '{print $1}'`
kill -9 $PIDS

LIBTOCOPY=`find /lib/* | grep -v libQt* |grep -v libdirect* | grep -v libplayready | grep -v libavcodec | grep -v modules | grep -v fonts | grep -v directfb`
mkdir /root/lib/
cp $LIBTOCOPY /root/lib/

mkdir /root/bin/
cp /bin/* /root/bin/
cp /dev /root/ -rf

#echo "Release Driver Memory"
#2. free reserved memory
fMTKRmmod () {
    USED_BY=$(lsmod|awk -v name=$1 '$1==name {print $4}'|awk -F "," '{print $1}') 
    echo "fMTKRmmod $1 ${USED_BY}"

    if [ -e ${USED_BY} ]; then
        if [ "`lsmod|awk -v name=$1 '$1==name {print $3}'`" == "0" ]; then
            echo "rmmod $1"
            rmmod $1
        else
            echo "error: $1 used by others!"  
            exit 1
        fi    
    else
        echo "rmmod related module..."
        fMTKRmmod ${USED_BY}      
        fMTKRmmod $1
    fi
  
}
#fMTKRmmod drv_mem

chmod 777 /etc/init.d/upg_1.sh
chmod 777 /etc/init.d/upg_2.sh
chmod 777 /etc/init.d/upg_prog
cp /etc/init.d/upg_prog /root/upg_prog
cp /etc/init.d/upg_2.sh /root/upg_2.sh

echo "chroot to /root and run upg_prog"
chroot /root /upg_2.sh
