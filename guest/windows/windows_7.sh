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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/windows_7.sh

# windows_7.sh
# Start windows 7 virtual machine. Host Ubuntu 20.04



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.4"
CURRENT_SCRIPT_DATE="2022-12-05"
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
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_7.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_7_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_WIN7="${KVM_WORKSPACE}/vm/windows_7"
OVMF_VARS_WIN7="${KVM_WORKSPACE_VM_WIN7}/windows_7_VARS.fd"
VM_DISK_WIN7="${KVM_WORKSPACE_VM_WIN7}/windows_7.qcow2"
#KVM_WORKSPACE_SOFTWARE="${KVM_WORKSPACE}/software"
VM_DISK_DATA="${KVM_WORKSPACE_VM_WIN7}/windows_7_data_d_drive.qcow2"

# Get 'virtio' iso file.
KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
VIRTIO_FILE="${KVM_WORKSPACE_ISO}/virtio-win-0.1.221.iso"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN7} for virtual machine?"
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
#lm_create_folder_recursive "${KVM_WORKSPACE_VM_WIN10}"  || lm_failure



# OVMF file for vm. UEFI boot.
if [[ ! -f "${OVMF_VARS_WIN7}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${OVMF_VARS_WIN7} does not exists."
	exit 1
fi

# Check Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN7}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_WIN7} does not exists."
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




echo ""
echo "Starting the vm."
echo ""



# Select GPU device (bus address).
VM_GPUS_CONF_FILE="$(realpath "${CURRENT_SCRIPT_DIR}/../../host/ubuntu-mate_20_04_1_LTS/vm_GPUs.conf")"
unset GPU_BUS GPU_SOUND SELECTED
lm_select_gpu_GPU_BUS_and_GPU_SOUND "${VM_GPUS_CONF_FILE}"  || lm_failure

if [[ ! -z ${GPU_BUS} ]]; then
    # NOTE: use virtual display instead of spice with real display
    VIRTUAL_DISPLAY=true
fi




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
PAR="${PAR} -M q35"
#PAR="${PAR} -M pc"

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

# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl" # NOTE: Install 'qxl' driver from 'virtio' iso disk.
#PAR="${PAR} -vga std"
#PAR="${PAR} -vga virtio"
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display none"

if [[ -n ${VIRTUAL_DISPLAY} ]]; then
	PAR="${PAR} -vga std"
	#PAR="${PAR} -vga qxl"
	# NOTE: Use 'gtk' instead of 'sdl'
	#PAR="${PAR} -display sdl"
	PAR="${PAR} -display gtk"
	
	PAR="${PAR} -device nec-usb-xhci,id=usb"
	PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
else
	SPICE_PORT=5924
	PAR="${PAR} -vga qxl"
fi

# Display 'spice'
#SPICE_PORT=5924
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
#USB_REDIR=true
#USB_REDIR_TYPE="USB3"
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
#PAR="${PAR} -usbdevice tablet"

# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_WIN7},if=pflash,format=raw,unit=1"
#PAR="${PAR} -bios ${OVMF_CODE}"

# NOTE: For machine 'pc' I get error: "Bus 'pcie.0' not found"
# TODO: Must use machine 'q35'
# Add pcie bus
#PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"

# VGA passthrough. GPU and sound.
#GPU_BUS="01:00.0"
#GPU_SOUND="01:00.1"
if [[ ! -z ${GPU_BUS} ]]; then
	PAR="${PAR} -device vfio-pci,host=${GPU_BUS},bus=root.1,addr=00.0,multifunction=on,x-vga=on"
fi

if [[ ! -z ${GPU_SOUND} ]]; then
	PAR="${PAR} -device vfio-pci,host=${GPU_SOUND},bus=root.1,addr=00.1"
fi

# Samba share. As default samba server address is  \\10.0.2.4\qemu\
if [[ ! -z ${KVM_WORKSPACE_SOFTWARE} ]]; then
	PAR="${PAR} -smb ${KVM_WORKSPACE_SOFTWARE}"
fi

# TODO: Use 9p instead of cifs-samba share
# -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=opt-kvm,bus=pcie.0,addr=0x9 
# $ sudo mount opt-kvm /opt/kvm -t 9p -o trans=virtio


# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_WIN7},format=qcow2 "
#PAR="${PAR} -drive file=${VM_DISK_WIN7},format=qcow2,if=none,id=drive-ide0-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"
PAR="${PAR} -hda ${VM_DISK_WIN7}"

# Virtual data disk d-drive
#PAR="${PAR} -drive file=${VM_DISK_DATA},format=qcow2,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"

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
	echo " $ spicy --title Windows 127.0.0.1 -p ${SPICE_PORT}"
	echo "You could also use 'remote-viewer'"
	echo " $ remote-viewer --title Windows spice://127.0.0.1:${SPICE_PORT}"
fi

echo ""
#qemu-system-x86_64 ${PAR}
sudo qemu-system-x86_64 ${PAR}


echo ""
echo "End of script '${CURRENT_SCRIPT}'"

