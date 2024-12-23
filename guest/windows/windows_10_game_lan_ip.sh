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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/windows_10_game.sh

# windows_10_game.sh
# Start windows 10 virtual machine.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.6"
CURRENT_SCRIPT_DATE="2021-02-15"
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





# TODO: Download Nvidia drivers.




# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10_game.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_game_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_WIN10="${KVM_WORKSPACE}/vm/windows_10_game"
OVMF_VARS_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10_game_VARS.fd"
VM_DISK_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10_game.qcow2"
#KVM_WORKSPACE_SOFTWARE="${KVM_WORKSPACE}/software"
VM_DISK_DATA="${KVM_WORKSPACE_VM_WIN10}/windows_10_game_data_d_drive.qcow2"

# Get 'virtio' iso file.
KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
VIRTIO_FILE="${KVM_WORKSPACE_ISO}/virtio-win-0.1.185.iso"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_WIN10} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1
		;;
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
if [[ ! -f "${OVMF_VARS_WIN10}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${OVMF_VARS_WIN10} does not exists."
	exit 1
fi

# Check Windows vm virtual disk.
if [[ ! -f "${VM_DISK_WIN10}" ]]; then
	lm_failure_message "${BASH_SOURCE[0]}" "${LINENO}" "File ${VM_DISK_WIN10} does not exists."
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
#PAR="${PAR} -m 4096"
#PAR="${PAR} -m 8192"
PAR="${PAR} -m 16384"

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
#PAR="${PAR} -vga virtio"
# ERR: qemu-system-x86_64: Display 'sdl' is not available.
# TODO: what is replacement for sdl display ?
# NOTE: Use 'gtk' instead of 'sdl'
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display none"

if [[ ! -z ${GPU_BUS} ]]; then
    # NOTE: use virtual display instead of spice with real display
    VIRTUAL_DISPLAY=true
fi

if [[ -n ${VIRTUAL_DISPLAY} ]]; then
	PAR="${PAR} -vga std"
	#PAR="${PAR} -vga qxl"
	# NOTE: Use 'gtk' instead of 'sdl'
	#PAR="${PAR} -display sdl"
	PAR="${PAR} -display gtk"
	
    PAR="${PAR} -device nec-usb-xhci,id=usb" # NOTE: USB3 support
	#PAR="${PAR} -usb -usbdevice host:534d:6021" # ID 534d:6021 
	#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=4" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
    PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0x0a17" # Logitech, Inc. G330 Headset
    PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
    PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xca04" # 046d:ca04 Logitech, Inc. Formula Vibration Feedback Wheel
else
	SPICE_PORT=5928
	PAR="${PAR} -vga qxl"
	# TODO: qemu-system-x86_64: -usbdevice tablet: '-usbdevice' is deprecated, please use '-device usb-...' instead
	# TODO: how usb devices are set in QEMU 4.2.1 ???
	#PAR="${PAR} -usbdevice tablet"
fi

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

# USB passthrough. Keyboard and mouse.
# TODO: parameterize. Or auto find.
#PAR="${PAR} -usb -usbdevice host:046d:c077"
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=3"
#PAR="${PAR} -usb -usbdevice host:046d:0a17"  # Logitech, Inc. G330 Headset
#PAR="${PAR} -usbdevice tablet"

# https://www.qemu.org/docs/master/system/usb.html
# https://git.qemu.org/?p=qemu.git;a=blob_plain;f=docs/usb2.txt;hb=HEAD
#PAR="${PAR} -device nec-usb-xhci,id=usb" # NOTE: USB3 support
#PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
#PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0x0a17" # Logitech, Inc. G330 Headset
#PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust

# 046d:ca04 Logitech, Inc. Formula Vibration Feedback Wheel
#PAR="${PAR} -usb -usbdevice host:046d:ca04"


# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_WIN10},if=pflash,format=raw,unit=1"

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
fi

if [[ ! -z ${GPU_SOUND} ]]; then
	PAR="${PAR} -device vfio-pci,host=${GPU_SOUND},bus=root.1,addr=00.1"
fi

# Samba share. As default samba server address is  \\10.0.2.4\qemu\
if [[ ! -z ${KVM_WORKSPACE_SOFTWARE} ]]; then
	PAR="${PAR} -smb ${KVM_WORKSPACE_SOFTWARE}"
fi

# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_WIN10},format=qcow2 "
PAR="${PAR} -drive file=${VM_DISK_WIN10},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"

# Virtual data disk d-drive
PAR="${PAR} -drive file=${VM_DISK_DATA},format=qcow2,if=none,id=drive-ide1-0-0"
PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"

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
# This is User-mode networking
#PAR="${PAR} -netdev user,id=user.0 -device e1000,netdev=user.0"

# Internal networking. Bridged networking.
# NOTE: virbr0 is created by virsh default network
# If virsh is installed it should start at boot.
#  $ virsh net-start default
#PAR="${PAR} -net nic -net bridge,br=virbr0"
#PAR="${PAR} -netdev bridge,br=virbr0,id=user.0"
#PAR="${PAR} -device e1000,netdev=user.0"

# MacVTap networking
# https://ahelpme.com/linux/howto-do-qemu-full-virtualization-with-macvtap-networking/
# https://gist.github.com/mcastelino/43cc733e53d65ef67452ecaf78e936c2
# Setup:
#  $ sudo ip link add link enp4s0 name macvtap0 type macvtap mode bridge
#  $ sudo ip link set macvtap0 up
#
# /dev/tap7   <-- This was created for me (2018-08-15) after setting macvtap0
# 7           <-- This is printed for me by "cat /sys/class/net/macvtap0/ifindex"
#PAR="${PAR} -netdev tap,id=hostnet0,fd=$(cat /sys/class/net/macvtap0/ifindex)"
#PAR="${PAR} -netdev tap,fd=3,id=hostnet0,vhost=on,vhostfd=4 3<>/dev/tap$(cat /sys/class/net/macvtap0/ifindex) 4<>/dev/vhost-net"
#PAR="${PAR} -netdev tap,id=hostnet0,fd=7 "
PAR="${PAR} -device e1000,netdev=hostnet0,id=net0,mac=$(cat /sys/class/net/macvtap0/address)"
PAR="${PAR} -netdev tap,id=hostnet0,fd=3 3<>/dev/tap$(cat /sys/class/net/macvtap0/ifindex) "
#PAR="${PAR} -net nic,model=virtio,addr=1a:46:0b:ca:bc:7b -net tap,fd=3 3<>/dev/tap$(cat /sys/class/net/macvtap0/ifindex) "

# NOTE: running 3<>/dev/tapX with sudo will cause error:
#   Could not open '3<>/dev/tap7': No such file or directory
# but it works if I first run "sudo su" = Running command as root


# Start the virtual machine with parameters
echo "qemu-system-x86_64 ${PAR}"
#qemu-system-x86_64 ${PAR}
#sudo qemu-system-x86_64 ${PAR}

if [[ -n ${SPICE_PORT} ]]; then
	echo ""
	echo "Connect to 'spice' remote server."
	echo " $ spicy --title 'Windows 10 game lan ip' 127.0.0.1 -p ${SPICE_PORT}"
	echo "You could also use 'remote-viewer'"
	echo " $ remote-viewer --title 'Windows 10 game lan ip' spice://127.0.0.1:${SPICE_PORT}"
fi

echo ""
#echo " $ sudo ip link add link enp4s0 name macvtap0 type macvtap mode bridge"
echo " $ sudo ip link add link enp7s0 name macvtap0 type macvtap mode bridge"
echo " $ sudo ip link set macvtap0 up"

echo ""
echo "$ sudo 3<>/dev/tap7
bash: /dev/tap7: Permission denied
"
echo "WTF !?!?"
echo ""
echo "qemu must be run as root ! ???"
echo " $ sudo su"
echo " $ qemu-system-x86_64 ..."
echo ""





echo ""
echo "End of script '${CURRENT_SCRIPT}'"

