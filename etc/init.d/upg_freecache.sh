#! /bin/sh
#
set -x
echo "=== upg_free cache Start ==="

cat /proc/meminfo
pwd
echo "cd /root/"
cd /root/
echo "pwd"
pwd
cat /proc/sys/vm/drop_caches
sync
echo 1 > /proc/sys/vm/drop_caches
sleep 2
echo 2 > /proc/sys/vm/drop_caches
sleep 2
echo 3 > /proc/sys/vm/drop_caches
sleep 2
cat /proc/sys/vm/drop_caches
free
sync
cat /proc/meminfo	
cd -
pwd
/chrome/cast_cli stop cast
cat /proc/meminfo
sync
echo "=== upg_free cache end ==="