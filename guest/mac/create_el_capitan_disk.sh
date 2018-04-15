#!/bin/bash

NAME="El-Capitan-disk"
MOUNT_NODE="/mnt/${NAME}"
DRIVER_DISK="./${NAME}.qcow2"
DISK_TYPE="qcow2"
DISK_NODE="/dev/nbd1"
PARTITION="${DISK_NODE}p1"


modprobe nbd
#qemu-img create -f qcow2 OSX.qcow2 40G
qemu-img create -f ${DISK_TYPE} ${DRIVER_DISK} 30G
qemu-nbd -f ${DISK_TYPE} -c ${DISK_NODE} ${DRIVER_DISK}

echo ""
echo "Create partition to the new virtual disk."
echo " ( http://www.tldp.org/HOWTO/Partition/fdisk_partitioning.html ) "
echo ""
echo "Command lists:"
echo "p ; n ; p ; 1 ; <RETURN> ( = default ) ; <RETURN>  ( = default )"
echo "t ; 7 ; p ; w"
echo ""
fdisk ${DISK_NODE}


# Format the partition with exFAT
mkfs.exfat -n ${NAME} ${PARTITION}

mkdir -p ${MOUNT_NODE}
mount -t exfat -o force,rw ${PARTITION} ${MOUNT_NODE}

cp -v "./Mac OS X El Capitan v10 11 6_magnet-link.txt" ${MOUNT_NODE}
cp -v "./OS X El Capitan 10.11.6 (15G31).dmg" ${MOUNT_NODE}


umount ${MOUNT_NODE}
qemu-nbd -d ${DISK_NODE}

# Sample code
# ( https://zllovesuki.git.sx/essays/tags/qemu/ )

# modprobe nbd
# qemu-nbd -c /dev/nbd0 /vm/OSX.qcow2
# mkdir -p /mnt/osx-kvm
# mount -t hfsplus -o force,rw /dev/nbd0p2 /mnt/osx-kvm
# mkdir /mnt/osx-kvm/Extra
# cp /vm/*.pkg /mnt/osx-kvm/Extra/
# umount /mnt/osx-kvm
# qemu-nbd -d /dev/nbd0


