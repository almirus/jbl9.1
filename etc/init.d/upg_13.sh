
echo "=== upg_13.sh Start ==="
set -x
#1.kill all process
echo "=== kill all process ==="

PIDS=`ps x|grep -v [[]|grep -v "init"|grep -v "sh"|grep -v "upgprog"|grep -v "ps"|grep -v "grep"|grep -v PID|awk '{print $1}'`

kill -9 $PIDS

echo "kill all process complete!"

cat /proc/meminfo

#2.Run upg_prog
echo "------C4A upgprog start run only for vizio------"
if [ -f "/usr/local/bin/upgprog" ]; then	
		echo "upgprog exist "
fi

/usr/local/bin/upgprog 1

if [ $? -ne 0 ]; then
   echo "upgprog run fail!"
   exit 1
fi