#!/bin/bash

# Copyright (c) 2022, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/windows_7-init.sh

# windows_7-init.sh
# Initialize windows 7 virtual machine. Host Ubuntu 20.04
# This script will create a new vm into folder ~/kvm-workspace/vm/windows_7/

# This is just an test installatioon of win 7.
# I have old PC running Windows 7. I want to create vm from that machine.
# But 1st I need to test if I even can run win 7 in kvm-qemu.


# NOTE: There is problem installing win 7 with UEFI ???
#       Installation hangs at "Expanding Windows Files (0%)"

# TODO: How to installe win 7 
#  ->  https://www.youtube.com/watch?v=mnVbbD7G0Bo
#  ->  https://www.youtube.com/watch?v=OSZlG04W2_w


unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.7"
CURRENT_SCRIPT_DATE="2022-11-21"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"




# NOTE to myself: How to get absolute path of file. 
#   ( https://stackoverflow.com/questions/17577093/how-do-i-get-the-absolute-directory-of-a-file-in-bash )

unset CURRENT_SCRIPT CURRENT_SCRIPT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR
#CURRENT_SCRIPT_REALPATH="$(realpath ${0})"
CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
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
elif [ ${LM_FUNCTIONS_VER} != "1.3.4" ]; then
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









# TODO: copy Win10_1703_English_x64.iso into folder 'iso'
# NOTE: Direct download link is valid only for while :(
#       Ask user to download file separately.

# TODO: Create python script for parsering the download page.


# https://www.microsoft.com/en-us/software-download/windows10ISO

# https://software-download.microsoft.com/pr/Win10_1703_English_x64.iso?t=53af494a-1bb5-43ad-a806-bdc2399c5a07&e=1500853983&h=706602d2b095fc8350559ee957afe432


# 4,3 GB (4334315520 bytes) (2017-06-23) Win10_1703_English_x64.iso
# 4,7 GB (4697362432 bytes) (2018-02-11) Win10_1709_English_x64.iso
# 5,4 GB (5421459456 bytes) (2019-12-02) Win10_1909_English_x64.iso



KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
lm_create_folder_recursive "${KVM_WORKSPACE_ISO}"  || lm_failure




# TODO: Check if there is newer version of file in the server.


# TODO: Create win10.iso file with MediaCreationTool.exe
# https://www.microsoft.com/en-us/software-download/windows10
# Windows10_DVD_2018-02-11.iso
# Windows10_USB_2018-02-11.iso

# NOTE: DVD one will not start installation correctly ?!?!?!
#       Downloaded is DVD one ???


# NOTE(2018-08-05): Downloaded DVD iso file works with parameter -cdrom 

# NOTE: I broke the created USB win10 installer ???  Files missing?
# Created a new one: that refuses to boot ??? WFT


#URL_FILE="Win10_1703_English_x64.iso"
#URL_FILE="Win10_1709_English_x64.iso"
#URL_FILE="Win10_1909_English_x64.iso"
#URL_FILE="Win10_2004_English_x64.iso"
#URL_FILE="Windows10_USB_2018-02-11.iso"
#URL_PLAIN="https://software-download.microsoft.com/pr"
#URL="${URL_PLAIN}/${URL_FILE}"

# NOTE: I was not able to download Windows 7 iso file from M$  :S
#        -> I created iso file from existing DVD   :)
#URL_FILE="Windows7_DVD_Eng_x64.iso"

# NOTE: Windows 7 iso file can be downloaded.
#       https://www.partitionwizard.com/partitionmanager/windows-7-iso-file-download.html
#       https://windowstan.com/

# Testing windowstan iso version. My DVD is enteprise so ...
#  -> https://windowstan.com/win/download-windows-7-enterprise-iso/
#  -> https://windowstan.com/get/windows-7-enterprise/
#  -> https://windowstan.com/download/windows-7-enterprise-x64/
URL_FILE="windowstan_en_7x64_entp.iso"

# NOTE: windowstan iso will not boot with UEFI?!
# TODO: create UEFI bootable iso
#        -> https://www.youtube.com/watch?v=8PkACdxjXWs


LOCAL_FILE="${KVM_WORKSPACE_ISO}/${URL_FILE}"

#URL_FILE_UBUNTU="ubuntu-mate-16.04.3-desktop-amd64.iso"
#LOCAL_FILE_UBUNTU="${KVM_WORKSPACE_ISO}/${URL_FILE_UBUNTU}"

#ISO_FILE="/media/4TB_Store/kvm-qemu-backup/iso-install/Win10_1703_English_x64.iso"
#ISO_FILE_USB="/media/4TB_Store/kvm-qemu-backup/iso-install/windows10.iso"



# Ask user to download file Win10_1703_English_x64.iso
#if [[ ! -f "${LOCAL_FILE}" ]]; then
#	echo ""
#	echo "Download win 10 iso file into ${LOCAL_FILE}"
#	echo ""
#	echo "https://www.microsoft.com/en-us/software-download/windows10ISO"
#	echo ""
#	unset INPUT
#	lm_read_to_INPUT "Do you wanna continue?"
#	case "${INPUT}" in
#		"YES" )
#			INPUT="YES" ;;
#		"NO" )
#			exit 1
#			;;
#		"FAILED" | * )
#			lm_failure ;;
#	esac
#else
#	echo -e "\n File ${LOCAL_FILE} alrealy exists.\n"
#fi

# Verify that user has downloaded the iso file.
if [[ ! -f "${LOCAL_FILE}" ]]; then
	echo ""
	echo "File missing:  ${LOCAL_FILE}"
	echo ""
	exit 1;
fi



#lm_download_to_folder "${KVM_WORKSPACE_ISO}" "${URL}"  || lm_failure

#lm_verify_and_download_to_folder "${URL_FILE}" "${KVM_WORKSPACE_ISO}" "${URL_PLAIN}"  || lm_failure













# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
KVM_WORKSPACE_VM_WIN7="${KVM_WORKSPACE}/vm/windows_7"
OVMF_VARS_WIN7="${KVM_WORKSPACE_VM_WIN7}/windows_7_VARS.fd"
VM_DISK_WIN7="${KVM_WORKSPACE_VM_WIN7}/windows_7.qcow2"
VM_DISK_DATA="${KVM_WORKSPACE_VM_WIN7}/windows_7_data_d_drive.qcow2"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN7} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1
		;;
	"FAILED" | * )
		lm_failure ;;
esac

# Create Windows vm folder.
lm_create_folder_recursive "${KVM_WORKSPACE_VM_WIN7}"  || lm_failure

# OVMF file for vm. UEFI boot.
if [[ -f "${OVMF_VARS}" ]]; then
	if [[ ! -f "${OVMF_VARS_WIN7}" ]]; then
		lm_copy_file "${OVMF_VARS}" "${OVMF_VARS_WIN7}"  || lm_failure
	else
		echo -e "\n File ${OVMF_VARS_WIN7} alrealy exists.\n"
	fi
else
	>&2 echo -e "\n File ${OVMF_VARS} missing. Did you installed OVMF?  Aborting."
	exit 1
fi

# Create Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN7}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_WIN7}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_WIN7}" 50G  || lm_failure
else
	echo -e "\n File ${VM_DISK_WIN7} alrealy exists.\n"
fi


# Create data disk d-drive.
if [[ ! -f "${VM_DISK_DATA}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_DATA}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_DATA}" 200G  || lm_failure
else
	echo -e "\n File ${VM_DISK_DATA} alrealy exists.\n"
fi



echo ""
echo "Starting the vm."
echo ""
#echo "NOTE: I have not found way to automatically boot from iso."
#echo ""
#echo "When vm is booting you need to enter in to bios and select the cd as boot device."
#echo ""
#echo "Enter to the bios:"
#echo "  Shell> exit"
#echo ""
#echo "Select  'Boot maintenance Manager' -> 'Boot From File'"
#echo ""
#echo "Select '[PciRoot (0x0) /Pci (0x1f,0x2) /Sata (0x0,0x0,0x0) /CDROM(0x1)]'"
#echo ""
#echo "Select '<efi>'"
#echo "         '<boot>'"
#echo "           'grub64.efi'"
#echo ""



# TODO: How to get GPU bus address? Ask from user?
#		Set to common file. Load from there.

# Host device bus address
#NVIDIA_GPU="01:00.0" # Nvidia GeForce GTX 1050 # ASUSTeK Computer Inc. Device
#NVIDIA_SOUND="01:00.1"
#NVIDIA_GPU="02:00.0" # Nvidia GeForce GT 710 # Micro-Star International Co., Ltd. [MSI] Device
#NVIDIA_SOUND="02:00.1"



# TODO: Set parameters for QEMU

# -enable-kvm -> enable hardware virtualization
PAR="-enable-kvm"

# NOTE: I had to define 'bios' first or installation hangs at "Expanding Windows Files (0%)" ?  WTF !?!?!
#PAR="${PAR} -bios ${OVMF_CODE}"

# NOTE: machine 'q35' does not work ???
# What is the default machine ?
# $ qemu-system-x86_64 -machine ?
#   pc                   Standard PC (i440FX + PIIX, 1996) (alias of pc-i440fx-4.2)
#   q35                  Standard PC (Q35 + ICH9, 2009) (alias of pc-q35-4.2)
# Mother board
#PAR="${PAR} -M q35"
PAR="${PAR} -M pc"

# Memory
PAR="${PAR} -m 4096"

# CPU
PAR="${PAR} -cpu host,kvm=off"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"

# fix the clock - Windows and linux handle clock differently
PAR="${PAR} -rtc base=localtime"

# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl"
# ERR: qemu-system-x86_64: Display 'sdl' is not available.
# NOTE: Use 'gtk' instead of 'sdl'
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display gtk"
#PAR="${PAR} -display none"

# Monitoring screen
#PAR="${PAR} -monitor stdio"

# USB passthrough. Keyboard and mouse.
# TODO: parameterize. Or auto find.
#PAR="${PAR} -usb -usbdevice host:046d:c077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=5" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
#PAR="${PAR} -usbdevice tablet"

# OVMF
#PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
#PAR="${PAR} -drive file=${OVMF_VARS_WIN7},if=pflash,format=raw,unit=1"
#PAR="${PAR} -bios ${OVMF_CODE}"

# Add pcie bus
#PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"

# VGA passthrough. GPU and sound.
# TODO: Ask user which card should be used.
#NVIDIA_GPU="01:00.0"
#NVIDIA_SOUND="01:00.1"
#NVIDIA_GPU="02:00.0"
#NVIDIA_SOUND="02:00.1"
if [[ ! -z ${NVIDIA_GPU} ]]; then
	PAR="${PAR} -device vfio-pci,host=${NVIDIA_GPU},bus=root.1,addr=00.0,multifunction=on,x-vga=on"
fi

if [[ ! -z ${NVIDIA_SOUND} ]]; then
	PAR="${PAR} -device vfio-pci,host=${NVIDIA_SOUND},bus=root.1,addr=00.1"
fi

# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_WIN7},format=qcow2 "
#PAR="${PAR} -drive file=${VM_DISK_WIN7},format=qcow2,if=none,id=drive-ide0-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"
PAR="${PAR} -hda ${VM_DISK_WIN7}"

# Virtual data disk d-drive
#PAR="${PAR} -drive file=${VM_DISK_DATA},format=qcow2,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"


# TODO: Make instller image read only
# Windows 10 ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE},id=isocd,format=raw,index=2 "
#PAR="${PAR} -drive file=${ISO_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${ISO_FILE_USB},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"
#PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0,readonly=on,media=cdrom"
#PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0,media=cdrom"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"
PAR="${PAR} -cdrom ${LOCAL_FILE}"

# Ubuntu ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE_UBUNTU},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"


# Sound card
PAR="${PAR} -soundhw hda"

# NOTE: We must disable the net !
# "Confirmed: Windows 10 Setup Now Prevents Local Account Creation" (October 1, 2019, 3:31pm EDT)
# https://www.howtogeek.com/442609/confirmed-windows-10-setup-now-prevents-local-account-creation/

# Network
#PAR="${PAR} -netdev user,id=user.0 -device e1000,netdev=user.0"
#PAR="${PAR} -nic none"

# TODO: parametarize the net
PAR="${PAR} -net none"  # Disable network for windows initialization. Enable local user creation.

# Start the virtual machine with parameters
echo "qemu-system-x86_64 ${PAR}"
echo ""
#qemu-system-x86_64 ${PAR}
sudo qemu-system-x86_64 ${PAR}



echo ""
echo "End of script '${CURRENT_SCRIPT}'"

