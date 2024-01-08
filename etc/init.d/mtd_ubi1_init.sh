#! /bin/sh

# ubi attach
# $1 : partition name
# return 0 : OK
#        1 : can't find partition name 
#        2 : format type error
#        3 : attach fail
funcUbiAttach () {
	PART_NAME=\"$1\"
	PART_NAME_NEW=$1
	
	MTD_ID=$(awk -v v1=${PART_NAME} '$4==v1 {print substr($1,4,length($1)-4)}' /proc/mtd)
	MTD_TYPE=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($5,2,7)}' /proc/part_info_tbl)

	if [ "${MTD_ID}" = "" ]; then
		echo "no find mtd [${PART_NAME}]"
		return 1
	fi
	
	if [ "${MTD_TYPE}" != "mtd_ubi" ]; then
		echo "format type[${MTD_TYPE}] not mtd_ubi"
		return 2
	fi
	
	echo "ubiattach mtd${MTD_ID}"  
	/sbin/ubiattach /dev/ubi_ctrl -m $MTD_ID
	if [ $? -ne 0 ]; then
		echo "ubiattach mtd${MTD_ID} fail"  
		return 3
	fi
	
	echo "ubiattach mtd${MTD_ID} success" 
	return 0
}

# Mount ubi attach
# $1 : partition name
# $2 : path
# return 0 : OK
#        1 : can't find volume name 
#        2 : format type error
#        3 : mount fail
funcMntUbiVol () {
	PART_NAME_NEW=$1
	NAND_MNT_DIR=$2
	
	MTD_TYPE=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($5,2,7)}' /proc/part_info_tbl)
	MTD_SIZE=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($3,2,10)}' /proc/part_info_tbl)
	VOL_NAME=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($6,3,4)}' /proc/part_info_tbl)

	if [ "${MTD_TYPE}" = "" ]; then
		echo "no find mtd [${PART_NAME_NEW}]"
		return 1
	fi
	
	if [ "${MTD_TYPE}" != "ubi_vol" ]; then
		echo "format type[${MTD_TYPE}] not ubi_vol"
		return 2
	fi
	
	if [ ! -e ${NAND_MNT_DIR} ]; then
		echo "no mnt dir -- mkdir -p ${NAND_MNT_DIR}"
		mkdir -p ${NAND_MNT_DIR}
	fi	
	
	echo "mtd_ubi1_init.sh Try mount ubifs ${PART_NAME_NEW}"
	mount -t ubifs ${VOL_NAME}:${PART_NAME_NEW} ${NAND_MNT_DIR} -o sync

	if [ $? -ne 0 ]; then                    
		echo "ubimkvol ${PART_NAME_NEW} $PART_NAME_NEW $MTD_SIZE" 
		/sbin/ubimkvol /dev/${VOL_NAME} -N $PART_NAME_NEW -s $MTD_SIZE
		echo "Mount ubifs ${PART_NAME_NEW}"
		mount -t ubifs ${VOL_NAME}:${PART_NAME_NEW} ${NAND_MNT_DIR} -o sync
		
		if [ $? -ne 0 ]; then
			echo "[mtd_init] Mount ubifs Fail...[${NAND_MNT_DIR}]"
			rm -rf ${NAND_MNT_DIR}
			return 3
		fi
	fi
	
	echo "Try mount ubifs ${PART_NAME_NEW} success!"
	return 0
}

# Create dir and Link
# $1 : target path
# $2 : link dir
# return 0 : OK
#        1 : can't find volume name 
#        2 : format type error
#        3 : mount fail
funcLnDir () {
	TARGET=$1
	LINKDIR=$2
	
	if [ ! -e ${TARGET} ]; then
		echo "no target -- mkdir -p ${TARGET}"
		mkdir -p ${TARGET}
	fi
	
	if [ -e ${LINKDIR} ]; then
		echo "link dir exist -- rm ${LINKDIR}"
		rm ${LINKDIR}
	fi
	
	echo "link [${LINKDIR}] -> [${TARGET}]"
	ln -s ${TARGET} ${LINKDIR}
	
	return $?
}

# Create dir and Link
# $1 : target path
# $2 : link dir
# return 0 : OK
#        1 : can't find volume name 
#        2 : format type error
#        3 : mount fail
RmvfuncLnDir () {
	TARGET=$1
	LINKDIR=$2
	
	if [ ! -e ${TARGET} ]; then
		echo "no target -- mkdir -p ${TARGET}"
		rm -rf ${TARGET}
	fi
	
	if [ -e ${LINKDIR} ]; then
		echo "link dir exist -- rm ${LINKDIR}"
		rm -rf ${LINKDIR}
	fi
	
	mkdir ${LINKDIR}
	
	return $?
}

# BUDA
funcUbiAttach ubi1
if [ $? -ne 0 ]; then
	echo "no ubi1"
else
  # Device node for ubi1
  MAJOR_NUM=$( awk -F":"   '{print substr($1,1,3)}' /sys/class/ubi/ubi1/dev)
  MINOR_NUM=$( awk -F":"   '{print substr($2,1,3)}' /sys/class/ubi/ubi1/dev)

  echo "ubi1 MAJOR_NUM is [${MAJOR_NUM}]"
  echo "ubi1 MINOR_NUM is [${MINOR_NUM}]"

  mknod /dev/ubi1 c ${MAJOR_NUM} ${MINOR_NUM}

  RmvfuncLnDir /mnt/ubi_boot/BUDA /mnt/nand_06_0
	funcMntUbiVol BUDA /mnt/nand_06_0
	sync
fi

#
# end
#
exit 0

