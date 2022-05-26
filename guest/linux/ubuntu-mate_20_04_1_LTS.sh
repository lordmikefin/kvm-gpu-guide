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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/linux/ubuntu-mate_20_04_1_LTS.sh

# ubuntu-mate_20_04_1_LTS.sh
# Start ubuntu-mate_20_04 virtual machine.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.5"
CURRENT_SCRIPT_DATE="2022-05-26"
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
#CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
#CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_SCRIPT_REALPATH})"
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




# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
KVM_WORKSPACE_VM_UBUNTU="${KVM_WORKSPACE}/vm/ubuntu-mate_20_04"
OVMF_VARS_UBUNTU="${KVM_WORKSPACE_VM_UBUNTU}/ubuntu20_04_VARS.fd"
VM_DISK_UBUNTU="${KVM_WORKSPACE_VM_UBUNTU}/ubuntu20_04.qcow2"
#KVM_WORKSPACE_SOFTWARE="${KVM_WORKSPACE}/software"


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



echo ""
echo "Starting the vm."
echo ""



# Select GPU device (bus address).
VM_GPUS_CONF_FILE="$(realpath "${CURRENT_SCRIPT_DIR}/../../host/ubuntu-mate_20_04_1_LTS/vm_GPUs.conf")"
unset GPU_BUS GPU_SOUND SELECTED
lm_select_gpu_GPU_BUS_and_GPU_SOUND "${VM_GPUS_CONF_FILE}"  || lm_failure




# Guide for how to run QEMU
# https://wiki.archlinux.org/index.php/QEMU


# Guide for QEMU monitor (console not the virtual screen ;)
# https://en.wikibooks.org/wiki/QEMU/Monitor


# Great info about PCI passthrough 
# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Setting_up_IOMMU




# TODO: Set parameters for QEMU

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



# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl"
#PAR="${PAR} -display sdl"
#PAR="${PAR} -vga none"
#PAR="${PAR} -display none"
# NOTE: Guest OS (ubuntu) will not write to virtual and physical display card at once ?!
# TODO: Dual gpu system?!
#  https://devtalk.nvidia.com/default/topic/1030445/cuda-setup-and-installation/dual-gpu-system-in-ubuntu-16-04/

echo ""
if [[ "${SELECTED}" == "0" ]]; then
	echo "No desplay device selected. Initialize virtual one."
	PAR="${PAR} -vga qxl"
	# NOTE: start 'spice' only if 'qxl' virtual card is used
	SPICE_PORT=5952
else
	echo "NOTE: Can not use physical and virtal display at same time :("
	PAR="${PAR} -vga none"
fi


# Display 'spice'
#SPICE_PORT=5924 # This port is used by Windows VM
#SPICE_PORT=5925
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


# USB redirection
USB_REDIR=true
USB_REDIR_TYPE="USB3"
#USB_REDIR_TYPE="USB2"
if [[ -n ${USB_REDIR} ]]; then
	# https://www.spice-space.org/usbredir.html
	# NOTE: ... hmmm ... this works wihout installing anything.
	#       Maybe things were alredy installed or was installed with 'spice-vdagent'
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
# TODO: how usb devices are set in QEMU 4.2.1 ???
#PAR="${PAR} -usb -usbdevice host:046d:c077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=3" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
#PAR="${PAR} -usbdevice tablet"

# https://www.qemu.org/docs/master/system/usb.html
# https://git.qemu.org/?p=qemu.git;a=blob_plain;f=docs/usb2.txt;hb=HEAD
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=3" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
if [[ -n ${SPICE_PORT} ]]; then
    echo "NOTE: usb devices are not auto connected with 'spice'"
else 
    #PAR="${PAR} -device usb-host,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
    #PAR="${PAR} -device usb-host,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    
    # pass USB controller only when display card is passed
    USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Fresco Logic FL1100 USB 3.0 Host Controller (rev 10)
fi


# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_UBUNTU},if=pflash,format=raw,unit=1"

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


# USB controller passthrough
if [[ ! -z ${USB_CONTROLLER} ]]; then
    # https://github.com/qemu/qemu/blob/master/docs/pcie.txt
    
    # Add pcie bus 2
    PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1d.0,chassis=2,id=root.2"
    
	#PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.1,addr=00.0,multifunction=on"
	PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.2"
fi



# Samba share. As default samba server address is  \\10.0.2.4\qemu\
if [[ ! -z ${KVM_WORKSPACE_SOFTWARE} ]]; then
	PAR="${PAR} -smb ${KVM_WORKSPACE_SOFTWARE}"
fi

# TODO: Use 9p instead of cifs-samba share
# -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=opt-kvm,bus=pcie.0,addr=0x9 
# $ sudo mount opt-kvm /opt/kvm -t 9p -o trans=virtio


# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_UBUNTU},format=qcow2 "
PAR="${PAR} -drive file=${VM_DISK_UBUNTU},format=qcow2,if=none,id=drive-ide0-0-0"
PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"



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
	echo " $ spicy --title Ubuntu 127.0.0.1 -p ${SPICE_PORT}"
	echo "You could also use 'remote-viewer'"
	echo " $ remote-viewer --title Ubuntu spice://127.0.0.1:${SPICE_PORT}"
fi

if [[ ! -z ${GPU_BUS} ]]; then
	echo ""
	echo "NOTE: qemu-system-x86_64 will notify about missing 'reset'."
	echo "This will happen only with AMD display cards. AMD reset bug !"
	echo " -> vfio: Cannot reset device 0000:01:00.1, no available reset mechanism."
fi


if [[ ! -z ${USB_CONTROLLER} ]]; then
	echo ""
	echo "Bind usb controller to vfio"
	sudo ../../script/vfio-bind.sh 0000:${USB_CONTROLLER}
fi


echo ""
#qemu-system-x86_64 ${PAR}
sudo qemu-system-x86_64 ${PAR}


if [[ ! -z ${USB_CONTROLLER} ]]; then
	echo ""
	echo "Bind usb controller back to xhci_hcd"
	sudo ../../script/vfio-unbind.sh ${USB_CONTROLLER}
	sudo ../../script/xhci_hcd-bind.sh ${USB_CONTROLLER}
fi


#GPU_BUS="01:00.0"
if [[ ! -z ${GPU_BUS} ]]; then
    # This work but is not elegant.
    
    # TODO: should try gnif's reset bug fix:
    # https://github.com/gnif/vendor-reset
	
	# TODO: Not really needed for Nvidia cards !
	#echo "Reset the card."
	#sudo ../../script/reset-device.sh 01:00
	#sudo ../../script/reset-device.sh ${GPU_BUS:0:5}
	
	echo "Installed 'vendor-reset' module in to host"
	echo " -> so now we should not need to suspend the card :)"
	echo "This will happen only with AMD display cards."
fi



echo ""
echo "End of script '${CURRENT_SCRIPT}'"

