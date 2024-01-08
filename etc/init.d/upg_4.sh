#! /bin/sh
#

echo "=== upg_4.sh Start ==="

#ps

#1.kill all process
echo "=== kill all process ==="

#PIDS=`ps|grep -v [[] | grep -v "init" | grep -v "kthreadd" | grep -v "ksoftirqd/0"| grep -v "events/0" | grep -v "khelper" | grep -v "async/mgr" | grep -v "pm" | grep -v "sync_supers" | grep -v "bdi-default" | grep -v "kblockd/0" | grep -v "kseriod" | grep -v "kswapd0" | grep -v "aio/0" | grep -v "crypto/0" | grep -v "mtdblock." | grep -v "mtdblock.." | grep -v "kpsmoused" | grep -v "Uart2TxThread" | grep -v "MPV." | grep -v "SR." | grep -v "CECTask Thread" | grep -v "HDMITask Thread" | grep -v "AVDTask Thread" | grep -v "PostTask Thread" | grep -v "VetTask0" | grep -v "VdpRz._Inst" | grep -v "VdpBufResz" | grep -v "NR_Inst" | grep -v "ImgdmaInst." | grep -v "VSYNC" | grep -v "RleThrea00" | grep -v "GfxThrea00" | grep -v "ImgResz._thread" | grep -v "PngInst0" | grep -v "IRRC Thread" | grep -v "OsdThread0" | grep -v "ubi_bgt0d" | grep -v "ubifs_bgt0_0" | grep -v "ADSPTask Thread" | grep -v "AudDrv" | grep -v "AudEff" | grep -v "AudEsm" | grep -v "DMX._TH" | grep -v "DMX_QUEUE_TH" | grep -v "JdecInst." | grep -v "GifInst0" | grep -v "EseInst." | grep -v "EsnInst." | grep -v "VFD Thread" | grep -v "ata_aux" | grep -v "ata_sff/0" | grep -v "sata_mt85xx_0/0" | grep -v "scsi_eh_0" | grep -v "khubd" | grep -v "scsi_eh_1" | grep -v "usb_storage" | grep -v "flush-8:0" | grep -v upg_. | grep -v PID | grep -v "Unknown" | grep -v "telnetd" | grep -v "ps" | grep -v "grep" | grep -v "awk" | awk '{print $1}'`

#echo $PIDS

#sleep 5

#kill -9 $PIDS

echo "kill all process complete!"

#sleep 5

#cat /proc/meminfo

#Run upgprog
echo "------upgprog program start run------"
cd /mnt/ubi_boot
chmod +x upgbinary.bin
./upgbinary.bin
if [ $? -ne 0 ]; then
   echo "upgbinary.bin run fail!"
   exit 1
fi

#echo "-------Now system restart--------"
#chroot / reboot