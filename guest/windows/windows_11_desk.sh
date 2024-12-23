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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/windows_11_desk.sh

# windows_11_desk.sh
# Start windows 11 virtual machine.

# This is win 11 vm. Host Ubuntu 20.04
# This will be my new main desktop. I will be setting all things from my old win7 physical desktop into this vm :)




unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.6"
CURRENT_SCRIPT_DATE="2023-04-24"
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





# TODO: Download Nvidia drivers.




# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_WIN11="${KVM_WORKSPACE}/vm/windows_11_desk"
OVMF_VARS_WIN11="${KVM_WORKSPACE_VM_WIN11}/windows_11_desk_VARS.fd"
VM_DISK_WIN11="${KVM_WORKSPACE_VM_WIN11}/windows_11_desk.qcow2"
#KVM_WORKSPACE_SOFTWARE="${KVM_WORKSPACE}/software"
VM_DISK_DATA="${KVM_WORKSPACE_VM_WIN11}/windows_11_desk_data_d_drive.qcow2"
VM_DISK_GAMES="${KVM_WORKSPACE_VM_WIN11}/disks/windows_11_desk_games_g_drive.qcow2"
VM_DISK_OLD_GAMES="${KVM_WORKSPACE_VM_WIN11}/disks/windows_11_desk_old_games_o_drive.qcow2"
VM_DISK_STEAM_GAMES="${KVM_WORKSPACE_VM_WIN11}/disks/windows_11_desk_steam_games_s_drive.qcow2"

EMULATED_TPM="/tmp/emulated_tpm_windows_11_desk"

# https://getlabsdone.com/how-to-install-windows-11-on-kvm/
# https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/
# https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.221-1/virtio-win-0.1.221.iso
# Get 'virtio' iso file.
KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
#VIRTIO_FILE="${KVM_WORKSPACE_ISO}/virtio-win-0.1.126.iso"
VIRTIO_FILE="${KVM_WORKSPACE_ISO}/virtio-win-0.1.221.iso"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN11} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1 ;;
	"FAILED" | * )
		lm_failure ;;
esac

#unset INPUT
#lm_read_to_INPUT "Do you wanna share folder ${KVM_WORKSPACE_SOFTWARE} with virtual machine?"
#case "${INPUT}" in
#	"YES" ) 
#		echo ""
#		echo " NOTE: This is simple samba share (buildin kvm) works only with"
#		echo "       folowing network setting:"
#		echo ""
#		echo " -netdev user,id=user.0 -device e1000,netdev=user.0"
#		echo ""
#		;;
#	"NO" ) 
#		KVM_WORKSPACE_SOFTWARE="" ;;
#	"FAILED" | * )
#		lm_failure_message; exit 1 ;;
#esac

## Create Ubuntu vm folder.
#lm_create_folder_recursive "${KVM_WORKSPACE_VM_WIN11}"  || lm_failure



# OVMF file for vm. UEFI boot.
if [[ ! -f "${OVMF_VARS_WIN11}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${OVMF_VARS_WIN11} does not exists."
	exit 1
fi

# Check Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN11}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_WIN11} does not exists."
	exit 1
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


# Create games disk g-drive.
if [[ ! -f "${VM_DISK_GAMES}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_GAMES}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_GAMES}" 500G  || lm_failure
else
	echo -e "\n File ${VM_DISK_GAMES} alrealy exists.\n"
fi


# Create "old games" disk o-drive.
if [[ ! -f "${VM_DISK_OLD_GAMES}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_OLD_GAMES}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_OLD_GAMES}" 500G  || lm_failure
else
	echo -e "\n File ${VM_DISK_OLD_GAMES} alrealy exists.\n"
fi


# Create "steam games" disk s-drive.
if [[ ! -f "${VM_DISK_STEAM_GAMES}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_STEAM_GAMES}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_STEAM_GAMES}" 500G  || lm_failure
else
	echo -e "\n File ${VM_DISK_STEAM_GAMES} alrealy exists.\n"
fi


# Make sure the TPM socket directory exists
if [[ ! -d "${EMULATED_TPM}" ]]; then
	echo ""
	echo "Createing direcotry ${EMULATED_TPM}"
	echo ""
    mkdir ${EMULATED_TPM}
else
	echo -e "\n Direcotry ${EMULATED_TPM} alrealy exists.\n"
fi

# https://www.tecklyfe.com/how-to-create-a-windows-11-virtual-machine-in-qemu/
# TODO: how to verify that TPM socket is running?
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



# Select GPU device (bus address).
#VM_GPUS_CONF_FILE="$(realpath "${CURRENT_SCRIPT_DIR}/../../host/ubuntu-mate_16_04_1_LTS/vm_GPUs.conf")"
VM_GPUS_CONF_FILE="$(realpath "${CURRENT_SCRIPT_DIR}/../../host/ubuntu-mate_20_04_1_LTS/vm_GPUs.conf")"
unset GPU_BUS GPU_SOUND SELECTED
lm_select_gpu_GPU_BUS_and_GPU_SOUND "${VM_GPUS_CONF_FILE}"  || lm_failure



# TODO: Set parameters for QEMU

# -enable-kvm -> enable hardware virtualization
PAR="-enable-kvm"

# Mother board
PAR="${PAR} -M q35"

# Memory
PAR="${PAR} -m 8192"

# CPU
PAR="${PAR} -cpu host,kvm=off"
#PAR="${PAR} -cpu host"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"

# fix the clock - Windows and linux handle clock differently
PAR="${PAR} -rtc base=localtime"

# Enable TPM and Secure Boot
PAR="${PAR} -chardev socket,id=chrtpm,path=${EMULATED_TPM}/swtpm-sock"
PAR="${PAR} -tpmdev emulator,id=tpm0,chardev=chrtpm"
PAR="${PAR} -device tpm-tis,tpmdev=tpm0"


#echo "VIRTUAL_DISPLAY ${VIRTUAL_DISPLAY}"
if [[ ! -z ${GPU_BUS} ]]; then
    # NOTE: use virtual display instead of spice with real display
    VIRTUAL_DISPLAY=true
fi
#echo "VIRTUAL_DISPLAY ${VIRTUAL_DISPLAY}"


# TODO: parametirize - ask from user
# testing - LIDEDE USB to HDMI Adapter
#LIDEDE_USB_HDMI=true
#VIRTUAL_DISPLAY=true
if [[ -n ${LIDEDE_USB_HDMI} ]]; then
	PAR="${PAR} -vga none"
	PAR="${PAR} -display none"
	# testing - LIDEDE USB to HDMI Adapter
	PAR="${PAR} -usb -usbdevice host:534d:6021" # ID 534d:6021 
	PAR="${PAR} -device usb-host,hostbus=1,hostaddr=4" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
elif [[ -n ${VIRTUAL_DISPLAY} ]]; then
	PAR="${PAR} -vga std"
	#PAR="${PAR} -vga qxl"
	# NOTE: Use 'gtk' instead of 'sdl'
	#PAR="${PAR} -display sdl"
	PAR="${PAR} -display gtk"
	
	#PAR="${PAR} -device nec-usb-xhci,id=usb"
	#PAR="${PAR} -usb -usbdevice host:534d:6021" # ID 534d:6021 
	#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=4" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
	#PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    #PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
    
    # USB controller passthrough
    USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Fresco Logic FL1100 USB 3.0 Host Controller (rev 10)
else
	SPICE_PORT=5932
	PAR="${PAR} -vga qxl"
	# TODO: qemu-system-x86_64: -usbdevice tablet: '-usbdevice' is deprecated, please use '-device usb-...' instead
	# TODO: how usb devices are set in QEMU 4.2.1 ???
	#PAR="${PAR} -usbdevice tablet"
	#PAR="${PAR} -device nec-usb-xhci,id=usb"
fi

# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl" # NOTE: Install 'qxl' driver from 'virtio' iso disk.
#PAR="${PAR} -vga std"
#PAR="${PAR} -vga virtio"
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display none"

# Display 'spice'
#SPICE_PORT=5926
if [[ -n ${SPICE_PORT} ]]; then
	# https://wiki.gentoo.org/wiki/QEMU/Windows_guest
	# https://www.spice-space.org/download.html
	# Install 'spice-guest-tools-latest.exe'
	# -> This will add bidirectonal clipboard among other stuff ;)
	PAR="${PAR} -spice port=${SPICE_PORT},disable-ticketing"
	# NOTE: Install 'VirtIO Servial Driver' driver from 'virtio' iso disk.
	PAR="${PAR} -device virtio-serial"
	PAR="${PAR} -chardev spicevmc,id=vdagent,name=vdagent"
	PAR="${PAR} -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
fi

# Monitoring screen
PAR="${PAR} -monitor stdio"


# USB redirection
USB_REDIR=true
USB_REDIR_TYPE="USB3"
#USB_REDIR_TYPE="USB2"
if [[ -n ${USB_REDIR} ]]; then
	# https://www.spice-space.org/usbredir.html
	# https://www.spice-space.org/download/windows/usbdk/
	# Install 'UsbDk_1.0.21_x64.msi'
	case "${USB_REDIR_TYPE}" in
		"USB3" )
			# NOTE: USB3 support
			PAR="${PAR} -device nec-usb-xhci,id=usb"
			;;
		"USB2" )
			# NOTE: USB2 support
			PAR="${PAR} -device ich9-usb-ehci1,id=usb"
			PAR="${PAR} -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,multifunction=on"
			PAR="${PAR} -device ich9-usb-uhci2,masterbus=usb.0,firstport=2"
			PAR="${PAR} -device ich9-usb-uhci3,masterbus=usb.0,firstport=4"
			;;
		"FAILED" | * )
			lm_failure ;;
	esac
	
	PAR="${PAR} -chardev spicevmc,name=usbredir,id=usbredirchardev1"
	PAR="${PAR} -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1"
	PAR="${PAR} -chardev spicevmc,name=usbredir,id=usbredirchardev2"
	PAR="${PAR} -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2"
	PAR="${PAR} -chardev spicevmc,name=usbredir,id=usbredirchardev3"
	PAR="${PAR} -device usb-redir,chardev=usbredirchardev3,id=usbredirdev3"
	
	# Filtering ?
	#PAR="${PAR} -device usb-redir,filter='0x03:-1:-1:-1:0|-1:-1:-1:-1:1',chardev=usbredirchardev1,id=usbredirdev1"
fi

# USB passthrough. Keyboard and mouse.
# TODO: parameterize. Or auto find.
#PAR="${PAR} -usb -usbdevice host:046d:c077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=4" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
#PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
#PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse

# Always passthrough HP printer and scanner to this VM.
PAR="${PAR} -device usb-host,vendorid=0x03f0,productid=0x4717" # Bus 001 Device 074: ID 03f0:4717 HP, Inc Color LaserJet CP1215
PAR="${PAR} -device usb-host,vendorid=0x03f0,productid=0x1d05" # Bus 001 Device 075: ID 03f0:1d05 HP, Inc    (I guess this is the hp scanjet 300)

# Passthrough Logitech G330 Headset
PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0x0a17" # Bus 001 Device 117: ID 046d:0a17 Logitech, Inc. G330 Headset

#PAR="${PAR} -usb -usbdevice host:0e8d:2008" # Bus 001 Device 005: ID 0e8d:2008 MediaTek Inc. (BV6000 Transfer files)
#PAR="${PAR} -usb -usbdevice host:0e8d:200b" # Bus 001 Device 009: ID 0e8d:200b MediaTek Inc. (BV6000 Transfer photos)
#PAR="${PAR} -usbdevice tablet"



# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_WIN11},if=pflash,format=raw,unit=1"

# Add pcie bus
PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"

# VGA passthrough. GPU and sound.
# TODO: Ask user which card should be used.
#GPU_BUS="01:00.0"
#GPU_SOUND="01:00.1"
#GPU_BUS="02:00.0"
#GPU_SOUND="02:00.1"
if [[ ! -z ${GPU_BUS} ]]; then
	PAR="${PAR} -device vfio-pci,host=${GPU_BUS},bus=root.1,addr=00.0,multifunction=on,x-vga=on"
	#PAR="${PAR} -device vfio-pci,host=${GPU_BUS},bus=root.1,addr=00.0,multifunction=on,x-vga=on,romfile=/media/4TB_Store/kvm-workspace/software/linux/vga_bios/Sapphire.RX570.8192.180123_1.rom"
	#PAR="${PAR} -device vfio-pci,host=${GPU_BUS},bus=root.1,addr=00.0,multifunction=on,x-vga=on,romfile=/media/4TB_Store/kvm-workspace/software/linux/vga_bios/Sapphire.RX570.8192.180105.rom"
	#PAR="${PAR} -device vfio-pci,host=${GPU_BUS},bus=root.1,addr=00.0,multifunction=on,x-vga=on,romfile=/media/4TB_Store/kvm-workspace/software/linux/vga_bios/Sapphire.RX570.8192.170629.rom"
fi

if [[ ! -z ${GPU_SOUND} ]]; then
	PAR="${PAR} -device vfio-pci,host=${GPU_SOUND},bus=root.1,addr=00.1"
fi


# QEMU #4: How to add a USB controller to a QEMU/KVM virtual machine
# https://www.youtube.com/watch?v=IYOmuPzrdXk

# USB controller passthrough
# 03:00.0 USB controller: Renesas Technology Corp. uPD720201 USB 3.0 Host Controller (rev 03)
#
#qemu-system-x86_64: -device vfio-pci,host=03:00.0,bus=root.1,addr=00.0,multifunction=on: vfio: error opening /dev/vfio/7: No such file or directory
#qemu-system-x86_64: -device vfio-pci,host=03:00.0,bus=root.1,addr=00.0,multifunction=on: vfio: failed to get group 7
#
# NOTE: Controller was not alone in group 7. I moded the card into diff PCIe slot
#  -> Now it is alone in group7 and other devices moved into group 8
#  -> And controller address changed from 03:00.0 to 04:00.0
#

# TODO: ask user - do you wanna to connect the USB controller :)
# TOOD: verify controller exists
#USB_CONTROLLER="03:00.0"
#USB_CONTROLLER="04:00.0"
#USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Renesas Technology Corp. uPD720201 USB 3.0 Host Controller (rev 03)

# TODO: When usb controller is passed and vm is shutdown the host os will crash! What is wrong with windows shutdown?!?!?!
# TODO: Update windows driver? Sonnet Technologies  Fresco Logic FL1100 USB 3.0 Host Controller [1b73:1100]
# NOTE: Driver from Fresco is buggy !!!  :(
#       If it was installed, then remove it and let windows update to install generic M$ driver!!! WTF!?!?!?
# http://www.sonnettech.com/support/kb/kb.php?cat=473&expand=&action=a3#a3
# https://support.frescologic.com/portal/en/kb/fresco-logic
# https://support.frescologic.com/portal/en/kb/articles/usb

# NOTE: It looks like reseting usb controller helps??? maybe?  sudo ../../script/reset-device.sh 05:00

# Reset all PCI cards at once
# $ sudo ../../script/reset-devices.sh 01:00 02:00 03:00 05:00

#USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Fresco Logic FL1100 USB 3.0 Host Controller (rev 10)
if [[ ! -z ${USB_CONTROLLER} ]]; then
    # https://github.com/qemu/qemu/blob/master/docs/pcie.txt
    
    # Add pcie bus 2
    PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1d.0,chassis=2,id=root.2"
    
	#PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.1,addr=00.0,multifunction=on"
	PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.2"
fi


# Samba share. As default samba server address is  \\10.0.2.4\qemu\
if [[ ! -z ${KVM_WORKSPACE_SOFTWARE} ]]; then
	#PAR="${PAR} -smb ${KVM_WORKSPACE_SOFTWARE}"
	echo "TODO: built-in SMB server conf has changed !"
	echo " https://wiki.archlinux.org/index.php/QEMU#QEMU's_built-in_SMB_server"
fi

# TODO: Use 9p instead of cifs-samba share
# -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=opt-kvm,bus=pcie.0,addr=0x9 
# $ sudo mount opt-kvm /opt/kvm -t 9p -o trans=virtio


# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_WIN11},format=qcow2 "
PAR="${PAR} -drive file=${VM_DISK_WIN11},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"

# Virtual data disk d-drive
PAR="${PAR} -drive file=${VM_DISK_DATA},format=qcow2,if=none,id=drive-ide1-0-0"
PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"


PAR="${PAR} -device ahci,id=ahci"

# Virtual games disk g-drive.
#PAR="${PAR} -drive file=${VM_DISK_GAMES},format=qcow2,if=none,id=drive-ide2-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.2,unit=0,drive=drive-ide2-0-0,id=ide2-0-0"
PAR="${PAR} -drive file=${VM_DISK_GAMES},if=none,id=disk-g"
PAR="${PAR} -device ide-hd,drive=disk-g,bus=ahci.1"

# Virtual "old games" disk o-drive.
PAR="${PAR} -drive file=${VM_DISK_OLD_GAMES},if=none,id=disk-o"
PAR="${PAR} -device ide-hd,drive=disk-o,bus=ahci.2"

# Virtual "steam games" disk s-drive.
PAR="${PAR} -drive file=${VM_DISK_STEAM_GAMES},if=none,id=disk-s"
PAR="${PAR} -device ide-hd,drive=disk-s,bus=ahci.3"


# Windows 10 ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE},id=isocd,format=raw,index=2 "
#PAR="${PAR} -drive file=${ISO_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${ISO_FILE_USB},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"

# 'virtio' driver disk
PAR="${PAR} -cdrom ${VIRTIO_FILE}"

# Ubuntu ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE_UBUNTU},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"


# Passthrough physical DVD/BluRay drive to the vm
#  https://github.com/stevenewbs/blog/blob/master/libvirtd%20qemu%20Blu%20Ray%20passthrough.md
#  https://forums.unraid.net/topic/33851-blu-ray-dvd-rom-passthrough/
#  https://lists.nongnu.org/archive/html/qemu-devel/2011-11/msg00627.html
#  https://wiki.gentoo.org/wiki/QEMU/Options
#  https://www.reddit.com/r/VFIO/comments/v9eian/qemukvm_with_vfio_passthrough_kinda_slow/
#  https://discussion.fedoraproject.org/t/how-to-acces-to-a-physical-dvd-drive-from-a-vm/67590/2
#   $ lsscsi
#     [6:0:0:0]    cd/dvd  HL-DT-ST BDDVDRW GGC-H20L 1.03  /dev/sr0 
#PAR="${PAR} -drive file=/dev/sr0,if=scsi"
# Qemu error: " -drive file=/dev/sr0,if=scsi: machine type does not support if=scsi,bus=0,unit=0"
#PAR="${PAR} -device ahci,id=ahci"
# TODO: This will cause stuttering/latency in the VM! Why???
#PAR="${PAR} -drive file=/dev/sr0,if=none,media=cdrom,id=drive-cd-1"
#PAR="${PAR} -device ide-cd,bus=ahci.0,drive=drive-cd-1"


# Sound card
PAR="${PAR} -soundhw hda"


# Network
MACADDRESS="$(lm_generate_mac_address)"  || lm_failure
# This is User-mode networking
#PAR="${PAR} -netdev user,id=user.0 -device e1000,netdev=user.0"
#PAR="${PAR} -netdev user,hostfwd=tcp::10022-:22,id=user.0"
#PAR="${PAR} -device e1000,netdev=user.0"
# https://unix.stackexchange.com/questions/124681/how-to-ssh-from-host-to-guest-using-qemu
# ssh vmuser@localhost -p10022
# $ ssh localhost -p10022
#PAR="${PAR} -net user,hostfwd=tcp::10022-:22"
#(qemu) Warning: vlan 0 with no nics
# NOTE(Mikko): Remember to install sshd on the quest
#               $ sudo apt-get install openssh-server

# (2018-07-19) hmmm ... I have broken the network.
# From guest DNS works, but traffic is not passed through NAT.
# I disabled the default virsh network
#  $ virsh net-destroy default
# And I just realized that it is not used by default ;)

#PAR="${PAR} -net nic,macaddr=52:54:00:12:24:57"
#PAR="${PAR} -net vde"

#PAR="${PAR} -netdev tap,fd=26,id=hostnet0"
#PAR="${PAR} -device rtl8139,netdev=hostnet0,id=net0,mac=52:54:00:47:ed:af,bus=pci.0,addr=0x3"
#PAR="${PAR} -netdev tap,id=hostnet0,ifname=vnet0"
#PAR="${PAR} -device e1000,netdev=hostnet0,id=net0,mac=52:54:00:47:ed:af"


# Internal networking. Bridged networking.
# NOTE: virbr0 is created by virsh default network
# If virsh is installed it should start at boot.
#  $ virsh net-start default
#PAR="${PAR} -net nic -net bridge,br=virbr0"
PAR="${PAR} -netdev bridge,br=virbr0,id=user.0"
PAR="${PAR} -device e1000,netdev=user.0,mac=${MACADDRESS}"

# TODO: parametarize the net
#PAR="${PAR} -net none"


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
	echo " $ spicy --title 'Windows 11 desk' 127.0.0.1 -p ${SPICE_PORT}"
	echo "You could also use 'remote-viewer'"
	echo " $ remote-viewer --title 'Windows 11 desk' spice://127.0.0.1:${SPICE_PORT}"
fi


if [[ ! -z ${USB_CONTROLLER} ]]; then
	echo ""
	echo "Bind usb controller to vfio"
	sudo ../../script/vfio-bind.sh 0000:${USB_CONTROLLER}
fi


echo ""
#qemu-system-x86_64 ${PAR}
sudo qemu-system-x86_64 ${PAR}

# TODO: When usb controller is passed and vm is shutdown the host os will crash! What is wrong with windows shutdown?!?!?!
echo ""
echo "Test logging after qemu closed."
echo ""


if [[ ! -z ${USB_CONTROLLER} ]]; then
	echo ""
	#echo "Bind usb controller back to xhci_hcd"
	#sudo ../../script/vfio-unbind.sh ${USB_CONTROLLER}
	#sudo ../../script/xhci_hcd-bind.sh ${USB_CONTROLLER}
fi


echo ""
echo "Stoping the screen with running the socket in TPM2 mode."
echo " $ screen -S emulated_tpm_windows_11_desk -X quit"
screen -S emulated_tpm_windows_11_desk -X quit

echo ""
echo "End of script '${CURRENT_SCRIPT}'"

