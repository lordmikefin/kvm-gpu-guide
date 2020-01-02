#!/bin/bash

# Copyright (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/shrink_qcow2_disk.sh

# shrink_qcow2_disk.sh
# Shrink the qcow2 vm disk of windows 10 virtual machine.

# NOTE: This only process disk of new clean installatioon of win 10.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.1"
CURRENT_SCRIPT_DATE="2020-01-03"
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





# TODO: Download Nvidia drivers.




# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_WIN10="${KVM_WORKSPACE}/vm/windows_10_clean"
OVMF_VARS_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10_clean_VARS.fd"
VM_DISK_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10_clean.qcow2"
KVM_WORKSPACE_SOFTWARE="${KVM_WORKSPACE}/software"
VM_DISK_DATA="${KVM_WORKSPACE_VM_WIN10}/windows_10_clean_data_d_drive.qcow2"

# Get 'virtio' iso file.
KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
VIRTIO_FILE="${KVM_WORKSPACE_ISO}/virtio-win-0.1.126.iso"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN10} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1 ;;
	"FAILED" | * )
		lm_failure ;;
esac




# Check Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN10}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_WIN10} does not exists."
	exit 1
fi


# Check data disk d-drive.
if [[ ! -f "${VM_DISK_DATA}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_DATA} does not exists."
	exit 1
fi


# TODO: Make sure all vm's uses TRIM to discard unused space.
# https://chrisirwin.ca/posts/discard-with-kvm/



# https://pve.proxmox.com/wiki/Shrink_Qcow2_Disk_Files

#Shrink your disk without compression (better performance, larger disk size):
# $ qemu-img convert -O qcow2 image.qcow2_backup image.qcow2

#Shrink your disk with compression:
#(smaller disk size, takes longer to shrink, performance impact on slower systems)
# $ qemu-img convert -O qcow2 -c image.qcow2_backup image.qcow2

VM_DISK_WIN10_TEMP="${VM_DISK_WIN10}.tmp"
echo ""
echo "Rename '${VM_DISK_WIN10}' as temporary file."
mv -v "${VM_DISK_WIN10}" "${VM_DISK_WIN10_TEMP}"

echo ""
echo "Recreate '${VM_DISK_WIN10}'"
qemu-img convert -O qcow2 "${VM_DISK_WIN10_TEMP}" "${VM_DISK_WIN10}"


VM_DISK_DATA_TEMP="${VM_DISK_DATA}.tmp"
echo ""
echo "Rename '${VM_DISK_DATA}' as temporary file."
mv -v "${VM_DISK_DATA}" "${VM_DISK_DATA_TEMP}"

echo ""
echo "Recreate '${VM_DISK_DATA}'"
qemu-img convert -O qcow2 "${VM_DISK_DATA_TEMP}" "${VM_DISK_DATA}"


echo ""
echo "End of script '${CURRENT_SCRIPT}'"

