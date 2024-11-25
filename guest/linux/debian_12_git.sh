#!/bin/bash

# Copyright (c) 2024, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/linux/debian_12_git.sh

# debian_12_git.sh
# Start debian_12_git virtual machine. Git server.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.2"
CURRENT_SCRIPT_DATE="2024-11-25"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"



unset CURRENT_SCRIPT CURRENT_SCRIPT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR

CURRENT_SCRIPT_REALPATH="$(readlink -f "${BASH_SOURCE[0]}")"

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

LM_TOYS_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/../../submodule/LMToysBash")
IMPORT_FUNCTIONS=$(realpath "${LM_TOYS_DIR}/lm_functions.sh")

if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
	exit 1
fi

source ${IMPORT_FUNCTIONS}

if [ ${LM_FUNCTIONS_LOADED} == false ]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Something went wrong with loading funcions."
	exit 1
elif [ ${LM_FUNCTIONS_VER} != "1.3.4" ]; then
	lm_functions_incorrect_version
	if [ "${INPUT}" == "FAILED" ]; then
		lm_failure
	fi
fi





unset DISTRO_INFO IS_UBUNTU EXEC_MATE_ABOUT IS_MATE
DISTRO_INFO="/etc/os-release"
if [[ -r "${DISTRO_INFO}" ]] ; then
	source "${DISTRO_INFO}" # Executeing commands from file. Import variables.
else
	echo -e "\n '${DISTRO_INFO}' file missing or is not readable.  Aborting." >&2
	exit 1
fi


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




# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_UBUNTU="${KVM_WORKSPACE}/vm/debian_12_git"
OVMF_VARS_UBUNTU="${KVM_WORKSPACE_VM_UBUNTU}/debian_12_git_VARS.fd"
VM_DISK_UBUNTU="${KVM_WORKSPACE_VM_UBUNTU}/debian_12_git.qcow2"


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




# OVMF file for vm. UEFI boot.
if [[ ! -f "${OVMF_VARS_UBUNTU}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${OVMF_VARS_UBUNTU} does not exists."
	exit 1
fi


# Create Ubuntu vm virtual disk.
if [[ ! -f "${VM_DISK_UBUNTU}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_UBUNTU} does not exists."
	exit 1
fi


# NOTE: I installed debian whout net. So keep disk in :)
ISO_FILE="debian-12.8.0-amd64-DVD-1.iso"
LOCAL_FILE="${KVM_WORKSPACE_ISO}/${ISO_FILE}"




echo ""
echo "Starting the vm."
echo ""


# -enable-kvm -> enable hardware virtualization
PAR="-enable-kvm"


# Mother board
PAR="${PAR} -M q35"


# Memory
PAR="${PAR} -m 4096"

# CPU
PAR="${PAR} -cpu host,kvm=off"
#PAR="${PAR} -cpu host"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"



PAR="${PAR} -vga qxl"
# NOTE: start 'spice' only if 'qxl' virtual card is used
SPICE_PORT=5960


# Display 'spice'
if [[ -n ${SPICE_PORT} ]]; then
	# https://wiki.gentoo.org/wiki/QEMU/Linux_guest
	# https://www.spice-space.org/download.html
	# $ sudo apt-get install spice-vdagent
	# -> This will add bidirectonal clipboard among other stuff ;)
	PAR="${PAR} -spice port=${SPICE_PORT},disable-ticketing"
	# 
	PAR="${PAR} -device virtio-serial"
	PAR="${PAR} -chardev spicevmc,id=vdagent,name=vdagent"
	PAR="${PAR} -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
fi

# Monitoring screen
PAR="${PAR} -monitor stdio"



# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_UBUNTU},if=pflash,format=raw,unit=1"

# Add pcie bus
PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"


# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_UBUNTU},format=qcow2 "
PAR="${PAR} -drive file=${VM_DISK_UBUNTU},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"

# ISO file
PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0"
PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"


# Network
MACADDRESS="$(lm_generate_mac_address)"  || lm_failure

# Internal networking. Bridged networking.
# NOTE: virbr0 is created by virsh default network
# If virsh is installed it should start at boot.
#  $ virsh net-start default
PAR="${PAR} -netdev bridge,br=virbr0,id=user.0"
PAR="${PAR} -device e1000,netdev=user.0,mac=${MACADDRESS}"


# Start the virtual machine with parameters
echo ""
echo "qemu-system-x86_64 ${PAR}"
echo ""
echo "https://en.wikibooks.org/wiki/QEMU/Monitor"
echo " (qemu) help"
echo " (qemu) info pci"
echo ""

if [[ -n ${SPICE_PORT} ]]; then
	echo ""
	echo "Connect to 'spice' remote server."
	echo " $ spicy --title 'Debian 12 git server' 127.0.0.1 -p ${SPICE_PORT}"
	echo "You could also use 'remote-viewer'"
	echo " $ remote-viewer --title Ubuntu spice://127.0.0.1:${SPICE_PORT}"
fi



echo ""
sudo qemu-system-x86_64 ${PAR}



echo ""
echo "End of script '${CURRENT_SCRIPT}'"

