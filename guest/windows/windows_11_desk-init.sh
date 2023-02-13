#!/bin/bash

# Copyright (c) 2023, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/windows_11_desk-init.sh

# windows_11_desk-init.sh
# Initialize windows 11 virtual machine.
# This will be my new main desktop. I will be setting all things from my old win7 physical desktop into this vm :)
# This script will create a new vm into folder ~/kvm-workspace/vm/windows_11_desk/

# https://www.tecklyfe.com/how-to-create-a-windows-11-virtual-machine-in-qemu/

unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.4"
CURRENT_SCRIPT_DATE="2023-01-23"
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
# https://www.microsoft.com/en-us/software-download/windows11


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


# NOTE(2023-01-23): Just download "English International" from 
#                   https://www.microsoft.com/en-us/software-download/windows11

# NOTE(2023-01-23): Current win11 iso version (22H2) will not boot :(
# TODO: Is there way to fix booting issue:
#       https://www.spinics.net/linux/fedora/fedora-users/msg515006.html
#       https://serverfault.com/questions/1096400/qemu-win11-this-pc-cant-run-windows-11
#         "Firmware change the default bios to : UEFI ... .secboot.fd"
#       https://getlabsdone.com/how-to-install-windows-11-on-kvm/
#       https://gitlab.com/qemu-project/qemu/-/issues/1225
#       https://gitlab.com/qemu-project/qemu/-/issues/1246
#         "it requires a trivial hack (AutoUnattend.xml file) to bypass the Win11 checks (google for it)."

# TODO: is AutoUnattend.xml the correct solution?
#       https://www.elevenforum.com/t/sharing-some-helpful-answer-files-to-bypass-win-11-setup-requirements-and-more.3300/

# TODO: is secure boot needed "OVMF_CODE.secboot.fd"
#       https://www.labbott.name/blog/2016/09/15/secure-ish-boot-with-qemu/

#URL_FILE="Win10_1703_English_x64.iso"
#URL_FILE="Win10_1709_English_x64.iso"
#URL_FILE="Win10_2004_English_x64.iso"
# NOTE(2023-01-23): Using older installation ISO :(
URL_FILE="Win11_English_x64v1.iso" # This is version 21H2 and it works. What is wrong with 22H2 ?!
#URL_FILE="Win11_22H2_EnglishInternational_x64v1.iso"
#URL_FILE="Win11_22H2_English_x64v1.iso"
#URL_FILE="Windows10_USB_2018-02-11.iso"
#URL_PLAIN="https://software-download.microsoft.com/pr"
#URL="${URL_PLAIN}/${URL_FILE}"

LOCAL_FILE="${KVM_WORKSPACE_ISO}/${URL_FILE}"

#URL_FILE_UBUNTU="ubuntu-mate-16.04.3-desktop-amd64.iso"
#LOCAL_FILE_UBUNTU="${KVM_WORKSPACE_ISO}/${URL_FILE_UBUNTU}"

#ISO_FILE="/media/4TB_Store/kvm-qemu-backup/iso-install/Win10_1703_English_x64.iso"
#ISO_FILE_USB="/media/4TB_Store/kvm-qemu-backup/iso-install/windows10.iso"



# Ask user to download file Win10_1703_English_x64.iso
if [[ ! -f "${LOCAL_FILE}" ]]; then
	echo ""
	echo "Download win 11 iso file into ${LOCAL_FILE}"
	echo ""
	echo "https://www.microsoft.com/en-us/software-download/windows11"
	echo ""
	unset INPUT
	lm_read_to_INPUT "Do you wanna continue?"
	case "${INPUT}" in
		"YES" )
			INPUT="YES" ;;
		"NO" )
			exit 1
			;;
		"FAILED" | * )
			lm_failure ;;
	esac
else
	echo -e "\n File ${LOCAL_FILE} alrealy exists.\n"
fi

# Verify that user has downloaded the iso file.
if [[ ! -f "${LOCAL_FILE}" ]]; then
	echo ""
	echo "File missing:  ${LOCAL_FILE}"
	echo ""
	exit 1;
fi



#lm_download_to_folder "${KVM_WORKSPACE_ISO}" "${URL}"  || lm_failure

#lm_verify_and_download_to_folder "${URL_FILE}" "${KVM_WORKSPACE_ISO}" "${URL_PLAIN}"  || lm_failure




# TODO: Before download check if file already exists.
#       'wget' will creat new file if exists.

# TODO: Verify that whole file was downloaded.





# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_VARS.fd
# OVMF binary file. Do _NOT_ over write.
# NOTE: Using secureboot UEFI !
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
#OVMF_CODE="/usr/share/OVMF/OVMF_CODE.secboot.fd"
OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
KVM_WORKSPACE_VM_WIN11="${KVM_WORKSPACE}/vm/windows_11_desk"
OVMF_VARS_WIN11="${KVM_WORKSPACE_VM_WIN11}/windows_11_desk_VARS.fd"
VM_DISK_WIN11="${KVM_WORKSPACE_VM_WIN11}/windows_11_desk.qcow2"

EMULATED_TPM="/tmp/emulated_tpm_windows_11_desk"

unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN11} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1
		;;
	"FAILED" | * )
		lm_failure ;;
esac

# Create Ubuntu vm folder.
lm_create_folder_recursive "${KVM_WORKSPACE_VM_WIN11}"  || lm_failure

# OVMF file for vm. UEFI boot.
if [[ -f "${OVMF_VARS}" ]]; then
	if [[ ! -f "${OVMF_VARS_WIN11}" ]]; then
		lm_copy_file "${OVMF_VARS}" "${OVMF_VARS_WIN11}"  || lm_failure
	else
		echo -e "\n File ${OVMF_VARS_WIN11} alrealy exists.\n"
	fi
else
	>&2 echo -e "\n File ${OVMF_VARS} missing. Did you installed OVMF?  Aborting."
	exit 1
fi

# Create Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN11}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_WIN11}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_WIN11}" 64G  || lm_failure
else
	echo -e "\n File ${VM_DISK_WIN11} alrealy exists.\n"
fi



# TODO: install swtpm
# https://github.com/stefanberger/swtpm
# https://askubuntu.com/questions/1396067/how-do-i-install-swtpm-on-ubuntu-21-10
# $ sudo add-apt-repository ppa:itrue/swtpm
# $ sudo apt-get update
# $ sudo apt-get install swtpm swtpm-tools

# TODO: install screen
# $ sudo apt install screen


# https://www.tecklyfe.com/how-to-create-a-windows-11-virtual-machine-in-qemu/

# create a temp directory for the SWTPM simulator and create the socket in TPM2 mode 

# mkdir /tmp/emulated_tpm
# swtpm socket --tpmstate dir=/tmp/emulated_tpm --ctrl type=unixio,path=/tmp/emulated_tpm/swtpm-sock --log level=20 --tpm2
if [[ ! -d "${EMULATED_TPM}" ]]; then
	echo ""
	echo "Createing direcotry ${EMULATED_TPM}"
	echo ""
    mkdir ${EMULATED_TPM}
else
	echo -e "\n Direcotry ${EMULATED_TPM} alrealy exists.\n"
fi

echo ""
echo "create the socket in TPM2 mode. Run command in screen in detached mode."
#swtpm socket --tpmstate dir=${EMULATED_TPM} --ctrl type=unixio,path=${EMULATED_TPM}/swtpm-sock --log level=20 --tpm2
screen -dmS "emulated_tpm_windows_11_desk" bash -c "swtpm socket --tpmstate dir=${EMULATED_TPM} --ctrl type=unixio,path=${EMULATED_TPM}/swtpm-sock --log level=20 --tpm2"

echo ""
echo "List all screens."
echo " $ screen -list"
echo "Connect to screens."
echo " $ screen -xS emulated_tpm_windows_11_desk"


echo ""
echo "Starting the vm."
echo ""
echo "NOTE: I have not found way to automatically boot from iso."
echo ""
echo "When vm is booting you need to enter in to bios and select the cd as boot device."
echo ""
echo "Enter to the bios:"
echo "  Shell> exit"
echo ""
echo "Select  'Boot maintenance Manager' -> 'Boot From File'"
echo ""
echo "Select '[PciRoot (0x0) /Pci (0x1f,0x2) /Sata (0x0,0x0,0x0) /CDROM(0x1)]'"
echo ""
echo "Select '<efi>'"
echo "         '<boot>'"
echo "           'grub64.efi'"
echo ""




# -enable-kvm -> enable hardware virtualization
PAR="-enable-kvm"

# Mother board
PAR="${PAR} -M q35"
## NOTE: Using secureboot UEFI !
#PAR="${PAR} -M q35,smm=on,accel=kvm"
## Due to the way some of the models work in edk2, we need to disable
## s3 resume. Without this option, qemu will appear to silently hang
## althouh it emits an error message on the ovmf_log
#PAR="${PAR} -global ICH9-LPC.disable_s3=1"
## Secure!
#PAR="${PAR} -global driver=cfi.pflash01,property=secure,value=on"


# Memory
PAR="${PAR} -m 4096"

# CPU
PAR="${PAR} -cpu host,kvm=off"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"

# fix the clock - Windows and linux handle clock differently
PAR="${PAR} -rtc base=localtime"

# Enable TPM and Secure Boot
PAR="${PAR} -chardev socket,id=chrtpm,path=${EMULATED_TPM}/swtpm-sock"
PAR="${PAR} -tpmdev emulator,id=tpm0,chardev=chrtpm"
PAR="${PAR} -device tpm-tis,tpmdev=tpm0"

# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl"
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display none"
PAR="${PAR} -display gtk"

# Monitoring screen
PAR="${PAR} -monitor stdio"

# USB passthrough. Keyboard and mouse.
# TODO: parameterize. Or auto find.
#PAR="${PAR} -usb -usbdevice host:046d:c077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=4" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
#PAR="${PAR} -usbdevice tablet"

# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_WIN11},if=pflash,format=raw,unit=1"

# Add pcie bus
PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"

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
#PAR="${PAR} -drive file=${VM_DISK_WIN11},format=qcow2 "
PAR="${PAR} -drive file=${VM_DISK_WIN11},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"


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

# Network
# NOTE: Disable network during install.
# TODO: Is this still the way to create a local account?
#       Nope. Now windows installer will requires the connection?!?!? WHY!!!
# https://www.groovypost.com/howto/install-windows-11-without-an-internet-connection/
#  !!! bypassing the network selection is now hiden !!!
# -> When the “Let’s connect you to a network” screen appears, press Shift + F10 on your keyboard.
# -> In the Command Prompt window that appears, type the following command "OOBE\BYPASSNRO", and hit Enter.
# -> Your PC will restart and begin the OOBE again – When the “Let’s connect you to a network” screen appears, click the "I don’t have internet" link.
#MACADDRESS="$(lm_generate_mac_address)"  || lm_failure
#PAR="${PAR} -netdev user,id=user.0 -device e1000,netdev=user.0"
#PAR="${PAR} -netdev bridge,br=virbr0,id=user.0"
#PAR="${PAR} -device e1000,netdev=user.0,mac=${MACADDRESS}"

# NOTE: Use "No Thank You" Method to skip M$ account  ->  no@thankyou.com
#   https://www.tomshardware.com/how-to/install-windows-11-without-microsoft-account
# "Using the "No Thank You" Method to Install Windows 11 with a Local Account"

# TODO: parametarize the net
PAR="${PAR} -net none"  # Disable network for windows initialization. Enable local user creation.

# Start the virtual machine with parameters
echo "qemu-system-x86_64 ${PAR}"
echo ""
#qemu-system-x86_64 ${PAR}
sudo qemu-system-x86_64 ${PAR}


echo ""
echo "Stoping the screen with running the socket in TPM2 mode."
echo " $ screen -S emulated_tpm_windows_11_desk -X quit"
screen -S emulated_tpm_windows_11_desk -X quit

echo ""
echo "End of script '${CURRENT_SCRIPT}'"

