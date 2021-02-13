#!/bin/bash

# Copyright (c) 2021, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/bsd/ghostbsd_20_11_28-init.sh

# ghostbsd_20_11_28-init.sh
# Initialize ghostbsd_20_11_28 virtual machine.
# This script will create a new vm into folder ~/kvm-workspace/vm/ghostbsd_20_11_28/


unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.2"
CURRENT_SCRIPT_DATE="2021-02-13"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"


# NOTE to myself: How to get absolute path of file. 
#   ( https://stackoverflow.com/questions/17577093/how-do-i-get-the-absolute-directory-of-a-file-in-bash )

unset CURRENT_SCRIPT CURRENT_SCRIPT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR
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
elif [ ${LM_FUNCTIONS_VER} != "1.3.1" ]; then
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


# TODO: copy FreeBSD-12.2-RELEASE-amd64-dvd1.iso into folder 'iso'
# https://www.freebsd.org/where.html
# https://download.freebsd.org/ftp/releases/amd64/amd64/ISO-IMAGES/12.2/
KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
lm_create_folder_recursive "${KVM_WORKSPACE_ISO}"  || lm_failure

URL_FILE="GhostBSD-20.11.28.iso"
URL_PLAIN="download.fr.ghostbsd.org/releases/amd64/20.11.28"
URL="${URL_PLAIN}/${URL_FILE}"

LOCAL_FILE="${KVM_WORKSPACE_ISO}/${URL_FILE}"
lm_verify_and_download_to_folder "${URL_FILE}" "${KVM_WORKSPACE_ISO}" "${URL_PLAIN}"  || lm_failure


# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
KVM_WORKSPACE_VM_BSD="${KVM_WORKSPACE}/vm/ghostbsd_20_11_28"
OVMF_VARS_BSD="${KVM_WORKSPACE_VM_BSD}/ghostbsd_20_11_28_VARS.fd"
VM_DISK_BSD="${KVM_WORKSPACE_VM_BSD}/ghostbsd_20_11_28.qcow2"

unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_BSD} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1
		;;
	"FAILED" | * )
		lm_failure_message
		INPUT="FAILED" ;;
esac

# Create Ubuntu vm folder.
lm_create_folder_recursive "${KVM_WORKSPACE_VM_BSD}"  || lm_failure


# OVMF file for vm. UEFI boot.
if [[ -f "${OVMF_VARS}" ]]; then
	if [[ ! -f "${OVMF_VARS_BSD}" ]]; then
		lm_copy_file "${OVMF_VARS}" "${OVMF_VARS_BSD}"  || lm_failure
	else
		echo -e "\n File ${OVMF_VARS_BSD} alrealy exists.\n"
	fi
else
	>&2 echo -e "\n File ${OVMF_VARS} missing. Did you installed OVMF?  Aborting."
	exit 1
fi

# Create Ubuntu vm virtual disk.
if [[ ! -f "${VM_DISK_BSD}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_BSD}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_BSD}" 100G  || lm_failure
else
	echo -e "\n File ${VM_DISK_BSD} alrealy exists.\n"
fi


echo ""
echo "Starting the vm."
echo ""

# -enable-kvm -> enable hardware virtualization
PAR="-enable-kvm"

# Mother board
PAR="${PAR} -M q35"

# Memory
PAR="${PAR} -m 8192"

# CPU
PAR="${PAR} -cpu host,kvm=on"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"

# Display   qxl
PAR="${PAR} -vga qxl"
PAR="${PAR} -display gtk"

# Monitoring screen
PAR="${PAR} -monitor stdio"

# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_BSD},if=pflash,format=raw,unit=1"

# Add pcie bus
PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"

# Virtual disk
PAR="${PAR} -drive file=${VM_DISK_BSD},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"

# FreeBSD ISO file
PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0"
PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"

# Sound card
PAR="${PAR} -soundhw hda"

# Network
# NOTE: Define mac address. Otherwise all vms are using the default one.
# https://www.linux-kvm.org/page/Networking
# Generate a MAC address
RAND_HEX1=$(printf '%02X' $((RANDOM%256)))
RAND_HEX2=$(printf '%02X' $((RANDOM%256)))
MACADDRESS="DE:AD:BE:EF:${RAND_HEX1}:${RAND_HEX2}"
#PAR="${PAR} -netdev user,id=user.0 -device e1000,netdev=user.0"
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
sudo qemu-system-x86_64 ${PAR}


echo ""
echo "End of script '${CURRENT_SCRIPT}'"

