#!/bin/bash

# Copyright (c) 2020, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/linux/compact-linux-qcow2.sh

# compact-linux-qcow2.sh

# Compact vm disk qcow2. Reclaim the space after files are removed from vm disk.


# https://ilearnedhowto.wordpress.com/2016/06/20/how-to-compact-a-qcow2-or-a-vmdk-file/
# https://pve.proxmox.com/wiki/Shrink_Qcow2_Disk_Files



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.2"
CURRENT_SCRIPT_DATE="2020-05-18"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"








# NOTE to myself: How to get absolute path of file. 
#   ( https://stackoverflow.com/questions/17577093/how-do-i-get-the-absolute-directory-of-a-file-in-bash )

unset CURRENT_SCRIPT CURRENT_SCRIPT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR

#CURRENT_SCRIPT_REALPATH="$(realpath ${0})"
#CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
# https://github.com/dgibbs64/SteamCMD-Commands-List
# https://github.com/dgibbs64/SteamCMD-Commands-List/blob/master/steamcmd_commands.sh
CURRENT_SCRIPT_REALPATH="$(readlink -f "${BASH_SOURCE[0]}")"
# NOTE: Should I always use "--canonicalize" ??
# TODO: Test how "--canonicalize" work if handling broken link.

CURRENT_SCRIPT="$(basename ${CURRENT_SCRIPT_REALPATH})"
CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_SCRIPT_REALPATH})"
WORK_DIR="${PWD}"
echo ""
echo "CURRENT_SCRIPT: ${CURRENT_SCRIPT}"
echo "CURRENT_SCRIPT_REALPATH: ${CURRENT_SCRIPT_REALPATH}"
echo "CURRENT_SCRIPT_DIR: ${CURRENT_SCRIPT_DIR}"
echo "WORK_DIR: ${WORK_DIR}"



unset LM_FUNCTIONS_VER LM_FUNCTIONS_DATE
unset LM_FUNCTIONS LM_FUNCTIONS_REALPATH LM_FUNCTIONS_DIR LM_FUNCTIONS_WORK_DIR
unset CALLER_SCRIPT_REALPATH
unset OS_NAME OS_VER OS_ARCH CURRENT_SHELL
unset INPUT

#STORE_REALPATH="$(realpath "${BASH_SOURCE[0]}")"
#STORE_DIRNAME="$(dirname "${STORE_REALPATH}")"
#IMPORT_FUNCTIONS="$(realpath "${STORE_DIRNAME}/../../script/lm_functions.sh")"
CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_SCRIPT_REALPATH})"
LM_TOYS_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/../../submodule/LMToysBash")
IMPORT_FUNCTIONS=$(realpath "${LM_TOYS_DIR}/lm_functions.sh")
#IMPORT_FUNCTIONS="$(realpath "${CURRENT_SCRIPT_DIR}/../../script/lm_functions.sh")"
if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
	exit 1
fi

source ${IMPORT_FUNCTIONS}

if [ ${LM_FUNCTIONS_LOADED} == false ]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Something went wrong with loading funcions."
	exit 1
elif [ ${LM_FUNCTIONS_VER} != "1.2.1" ]; then
	lm_functions_incorrect_version
	if [ "${INPUT}" == "FAILED" ]; then
		lm_failure
	fi
fi







# NOTE to myself: Read more about executeing commands from filename in Bash.
#   ( https://superuser.com/questions/46139/what-does-source-do )

# NOTE to myself: Read more about Bash conditional statements.
#   ( http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html )

# NOTE to myself: Read more about how to get distribuiton info.
#   ( https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script )

unset DISTRO_INFO IS_UBUNTU EXEC_MATE_ABOUT IS_MATE
DISTRO_INFO="/etc/os-release"
if [[ -r "${DISTRO_INFO}" ]] ; then
	source "${DISTRO_INFO}" # Executeing commands from file. Import variables.
else
	echo -e "\n '${DISTRO_INFO}' file missing or is not readable.  Aborting." >&2
	exit 1
fi
#echo -e "\n Distro name: ${NAME}, Version: ${VERSION}"

#if [[ ${NAME} != "Ubuntu" ]] ; then
#	echo -e "\n This script is tested only with Ubuntu.  Aborting." >&2
#	exit 1
#fi

case ${NAME} in
	Ubuntu )
		echo "Distro is Ubuntu" 
		IS_UBUNTU=1 ;;
	* )
		echo -e "\n This script is tested only with Ubuntu.  Aborting." >&2
		exit 1
		;;
esac

if [[ ${IS_UBUNTU} -eq 1 ]] ; then
	#which mate-about >/dev/null && { echo "Is MATE"; echo "$(mate-about -v)"; }
	EXEC_MATE_ABOUT="$(which mate-about)"
	echo "EXEC_MATE_ABOUT: '${EXEC_MATE_ABOUT}'"
	if [[ -n ${EXEC_MATE_ABOUT} ]] ; then
		IS_MATE=1
		echo "$(${EXEC_MATE_ABOUT} -v)"
	else
		echo -e "\n 'mate-about' is not installed."
		echo -e "\n This script is tested only with MATE.  Aborting." >&2
		exit 1
	fi
else
	echo -e "\n This script is tested only with UBUNTU.  Aborting." >&2
	exit 1
fi








# Check if KVM_WORKSPACE variable is set.

# if not ask user if she/he wants to continue using default path:
#   /home/<USER>/kvm-workspace

unset KVM_WORKSPACE_DEFAULT
lm_check_KVM_WORKSPACE











# Ubuntu eth vm disk
KVM_WORKSPACE_VM_UBUNTU="${KVM_WORKSPACE}/vm/ubuntu-mate_18_04-eth"
VM_DISK_UBUNTU="${KVM_WORKSPACE_VM_UBUNTU}/ubuntu18_04-eth.qcow2"
MOUNT_VM_DISK_UBUNTU="/mnt/vm_disk"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_UBUNTU} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1 ;;
	"FAILED" | * )
		lm_failure ;;
esac



unset INPUT
lm_read_to_INPUT "Do you wanna compact disk ${VM_DISK_UBUNTU} ?"
case "${INPUT}" in
	"YES" ) 
		INPUT="YES" ;;
	"NO" ) 
		exit 1 ;;
	"FAILED" | * )
		lm_failure_message; exit 1 ;;
esac




# https://ilearnedhowto.wordpress.com/2016/06/20/how-to-compact-a-qcow2-or-a-vmdk-file/
# https://pve.proxmox.com/wiki/Shrink_Qcow2_Disk_Files



# TODO: create error checking for each step


# 1st   verify                VM_DISK_UBUNTU
if [[ ! -f "${VM_DISK_UBUNTU}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_UBUNTU} does not exists."
	exit 1
fi


BSIZE="1M"
# TODO: get real free space automaticly <- now manually 
#COUNT_AVAIL=80692580
COUNT_AVAIL=80692


# 2nd   mount                 VM_DISK_UBUNTU
sudo modprobe nbd
DISK_TYPE="qcow2"
DISK_NODE="/dev/nbd1"
#PARTITION="${DISK_NODE}p1"
PARTITION="${DISK_NODE}p2"
echo "Mount disk ${VM_DISK_UBUNTU} into ${MOUNT_VM_DISK_UBUNTU}"

sudo qemu-nbd -f ${DISK_TYPE} -c ${DISK_NODE} ${VM_DISK_UBUNTU}
sudo mkdir -p ${MOUNT_VM_DISK_UBUNTU}
#sudo mount -t exfat -o force,rw ${PARTITION} ${MOUNT_VM_DISK_UBUNTU}
#sudo mount -o force,rw ${PARTITION} ${MOUNT_VM_DISK_UBUNTU}
sudo mount ${PARTITION} ${MOUNT_VM_DISK_UBUNTU}


# 3rd   zero out free space   VM_DISK_UBUNTU
echo "zero out all free space in ${MOUNT_VM_DISK_UBUNTU}"
#sudo dd if=/dev/zero of=${MOUNT_VM_DISK_UBUNTU}/tmp/zerofile.raw status=progress
sudo dd if=/dev/zero of=${MOUNT_VM_DISK_UBUNTU}/tmp/zerofile.raw status=progress bs=${BSIZE} count=${COUNT_AVAIL}
sudo rm -v ${MOUNT_VM_DISK_UBUNTU}/tmp/zerofile.raw

# 4th   unmount               VM_DISK_UBUNTU
echo "Unmount disk ${VM_DISK_UBUNTU} from ${MOUNT_VM_DISK_UBUNTU}"
sudo umount ${MOUNT_VM_DISK_UBUNTU}
sudo qemu-nbd -d ${DISK_NODE}

# 5th   compact               VM_DISK_UBUNTU
echo "Compact the disk  ${VM_DISK_UBUNTU}"
sudo mv -v ${VM_DISK_UBUNTU} ${VM_DISK_UBUNTU}_backup
sudo qemu-img convert -O qcow2 ${VM_DISK_UBUNTU}_backup ${VM_DISK_UBUNTU}
echo "The disk compacted  ${VM_DISK_UBUNTU}"
ls -lh ${VM_DISK_UBUNTU}
echo "Remove the backup file: ${VM_DISK_UBUNTU}_backup"







