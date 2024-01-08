#! /bin/sh

#
# functions
#
# $1 : partition name
# $2 : path
# return 0 : OK
#        1 : can't find partition name 
#        2 : mount yaffs2 or ubifs error
#        3 : mkdir fail
funcMntAndLink () {
    # find partition by name
    PART_NAME=\"$1\"
    PART_NAME_NEW=$1
    MTD_ID=$(awk -v v1=${PART_NAME} '$4==v1 {print substr($1,4,length($1)-4)}' /proc/mtd)

    MTD_SIZE=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($3,2,10)}' /proc/part_info_tbl)
    MTD_TYPE=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($5,2,7)}' /proc/part_info_tbl)
    VOL_NAME=$(awk -F"," -v v1=${PART_NAME_NEW} 'substr($7,3,length($7)-3)==v1 {print substr($6,3,4)}' /proc/part_info_tbl)

 
    echo "[MTD_SIZE] is...[${MTD_SIZE}]"
    echo "[MTD_TYPE] is...[${MTD_TYPE}]"
    echo "[VOL_NAME] is...[${VOL_NAME}]"
    
    NAND_MNT_DIR=$2

    if [ "${MTD_ID}" = "" ]; then
        echo "[mtd_init] Can't find partition $1"
        #return 1
    fi

    # mount yaffs2 & ubifs
    if [ "${NAND_MNT_DIR}" = "" ]; then
        echo "[mtd_init] NAND_MNT_DIR is an empty string."
    else
        if [ ! -e ${NAND_MNT_DIR} ]; then
            echo "[mtd_init] folder ${NAND_MNT_DIR} does not exist"
            mkdir -p ${NAND_MNT_DIR}
            
            if [ $? -ne 0 ]; then
                echo "[mtd_init] mkdir fail... [${NAND_MNT_DIR}]"
                return 3
            fi
        fi
        
        echo "Mounting $1"
        if [ "${MTD_TYPE}" = "mtd_ubi" ]; then          
           echo "ubiattach mtd${MTD_ID}"  
           /sbin/ubiattach /dev/ubi_ctrl -m $MTD_ID 
           if [ $? -ne 0 ]; then
               echo "ubiattach mtd${MTD_ID} fail"  
           else
               echo "ubiattach mtd${MTD_ID} success" 
               return 0; 
           fi
        fi          
        if [ "${MTD_TYPE}" = "ubi_vol" ]; then                 
           echo "Try mount ubifs ${PART_NAME_NEW}"
           mount -t ubifs ${VOL_NAME}:${PART_NAME_NEW} ${NAND_MNT_DIR}
           if [ $? -ne 0 ]; then                    
               echo "ubimkvol ${PART_NAME_NEW}" 
               /sbin/ubimkvol /dev/${VOL_NAME} -N $PART_NAME_NEW -s $MTD_SIZE
               echo "Mount ubifs ${PART_NAME_NEW}"     
               mount -t ubifs ${VOL_NAME}:${PART_NAME_NEW} ${NAND_MNT_DIR} -o sync
               if [ $? -ne 0 ]; then
                   echo "[mtd_init] Mount ubifs Fail...[${NAND_MNT_DIR}]"
                   rm -rf ${NAND_MNT_DIR}
                   return 2
               else
                   return 0
               fi
           else
               echo "Try mount ubifs ${PART_NAME_NEW} success!"
               return 0
           fi                       
        fi                    
            
            
        echo "Mount yaffs2 fs"
        mount -t yaffs2 /dev/mtdblock$MTD_ID ${NAND_MNT_DIR}
        if [ $? -ne 0 ]; then
            echo "[mtd_init] Mount yaffs2 Fail...[${NAND_MNT_DIR}]"
            rm -rf ${NAND_MNT_DIR}
            return 2            
        fi          
    fi
    return 0;
}

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
	
	echo "Try mount ubifs ${PART_NAME_NEW}"
	mount -t ubifs ${VOL_NAME}:${PART_NAME_NEW} ${NAND_MNT_DIR} -o sync

	if [ $? -ne 0 ]; then                    
		echo "ubimkvol ${PART_NAME_NEW}" 
		/sbin/ubimkvol /dev/${VOL_NAME} -N $PART_NAME_NEW -s $MTD_SIZE
		if [ $? -ne 0 ]; then
			echo "ubirmvol ubi_boot" 
			/sbin/ubirmvol /dev/ubi0 -n 0
			echo "ubimkvol ${PART_NAME_NEW}" 
			/sbin/ubimkvol /dev/${VOL_NAME} -N $PART_NAME_NEW -s $MTD_SIZE
		fi		
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


#
# get major number
#
#MAJOR_C=$(awk '$2=="mtd" {print $1}' /proc/devices)
#MAJOR_B=$(awk '$2=="mtdblock" {print $1}' /proc/devices)

#echo "MAJOR_C = [${MAJOR_C}], MAFOR_B=[${MAJOR_B}]"

#
# mknod
#
#for MINOR in $(awk '$3~/^mtdblock/ {print $2}' /proc/diskstats); do
#    echo "MINOR=[$MINOR]"
#    mknod /dev/mtd${MINOR} c ${MAJOR_C} `expr ${MINOR} + ${MINOR}`
#    mknod /dev/mtdblock${MINOR} b ${MAJOR_B} ${MINOR}
#done


#
# mount squash
#

#
# mount ubi
#

# Device node for ubi_ctrl
MAJOR_NUM=$( awk -F":"   '{print substr($1,1,3)}' /sys/class/misc/ubi_ctrl/dev)
MINOR_NUM=$( awk -F":"   '{print substr($2,1,3)}' /sys/class/misc/ubi_ctrl/dev)

echo "ubi_ctrl MAJOR_NUM is [${MAJOR_NUM}]"
echo "ubi_ctrl MINOR_NUM is [${MINOR_NUM}]"

mknod /dev/ubi_ctrl c ${MAJOR_NUM} ${MINOR_NUM}

#attach ubi0 partition
funcUbiAttach ubi0

# Device node for ubi0
MAJOR_NUM=$( awk -F":"   '{print substr($1,1,3)}' /sys/class/ubi/ubi0/dev)
MINOR_NUM=$( awk -F":"   '{print substr($2,1,3)}' /sys/class/ubi/ubi0/dev)

echo "ubi0 MAJOR_NUM is [${MAJOR_NUM}]"
echo "ubi0 MINOR_NUM is [${MINOR_NUM}]"

mknod /dev/ubi0 c ${MAJOR_NUM} ${MINOR_NUM}

# mount ubi vol
funcMntUbiVol ubi_boot /mnt/ubi_boot

#funcMntAndLink key_block_1 /mnt/BdpInfo1
#funcLnDir /mnt/ubi_boot/key_block_1 /mnt/BdpInfo1

#funcMntAndLink key_block_2 /mnt/BdpInfo2
#funcLnDir /mnt/ubi_boot/key_block_2 /mnt/BdpInfo2

#funcMntAndLink log /mnt/log
funcLnDir /mnt/ubi_boot/log /mnt/log

#funcMntAndLink APDA /mnt/nand_03_0
funcLnDir /mnt/ubi_boot/APDA /mnt/nand_03_0

# mount ubi vol
#funcMntUbiVol BUDA /mnt/nand_06_0


#funcMntAndLink acfg /acfg
mkdir -p /mnt/ubi_boot/acfg

#funcMntAndLink misc_data /misc
mkdir -p /mnt/ubi_boot/misc_data

#funcMntAndLink CPS_manager /cpsm
mkdir -p /mnt/ubi_boot/CPS_manager

#funcMntAndLink cust_part_1 /cust_part_1
mkdir -p /mnt/ubi_boot/cust_part_1

mkdir -p /mnt/ubi_boot/BUDA

funcLnDir /mnt/ubi_boot/BUDA /mnt/nand_06_0


# BUDA
#funcUbiAttach ubi1
#if [ $? -ne 0 ]; then
#	echo "no buda"
#else
	#funcMntAndLink BUDA /mnt/nand_06_0
	#funcMntUbiVol BUDA /mnt/nand_06_0
#fi

#
# end
#
sync
exit 0

