#!/bin/bash

# Copyright (c) 2017, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# All rights reserved.
# 
# License of this script file:
#   BSD 2-Clause License
# 
# License is available online:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/mac/mac_os_10_13_6_u20.sh

# mac_os_10_13_6_u20.sh
# Run Mac OS X High Sierra 10.13.6 virtual machine.  Host Ubuntu 20.04
# This script will run the vm into folder ~/kvm-workspace/vm/mac/

# Create BaseSystem_High_Sierra_10.13.6.img with kholia's script:
# https://github.com/kholia/OSX-KVM

# TODO: down load drivers
# https://github.com/kholia/OSX-KVM/blob/master/notes.md
# http://www.macvidcards.com/drivers.html#
# https://docs.nvidia.com/cuda/archive/9.2/cuda-installation-guide-mac-os-x/index.html
# https://www.nvidia.com/en-us/drivers/cuda/macosx-cuda-396-148-driver/

# https://www.nvidia.com/en-us/drivers/cuda/macosx-cuda-418-105-driver/
# https://docs.nvidia.com/cuda/archive/10.1/cuda-installation-guide-mac-os-x/index.html
# https://developer.nvidia.com/cuda-10.1-download-archive-base

# TODO: passthrough
# https://github.com/kholia/OSX-KVM/blob/master/notes.md
# https://github.com/kholia/OSX-KVM/blob/master/boot-passthrough.sh
# Must use /OpenCore-Catalina/OpenCore-Passthrough.qcow2   ?!?!?

unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.10"
CURRENT_SCRIPT_DATE="2021-02-14"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"







#exit 1;




# QEMU Emulator User Documentation
# http://download.qemu.org/qemu-doc.html


# TODO: This script is copied form Win10/Ubuntu script.
# So change all win/linux related to mac lines         :)




# TODO: mac vm guide links here

# ( https://www.contrib.andrew.cmu.edu/~somlo/OSXKVM/ )




#exit 1;





# https://gist.github.com/gordonturner/2a2e5ecde5e7860b52e2

# NOTE(Mikko): I think I have done this already in vfio.conf
#    Ignore MSR readout on host by VM:

# sudo su -
# echo 1 > /sys/module/kvm/parameters/ignore_msrs





#exit 1;



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









# TODO:		Download mac os X 10.11.6  installing files.
#			Torrent linki in file:  Mac OS X El Capitan v10 11 6_magnet-link.txt

# TODO: 	Create bootable usb mac installation USB stick with Clover
#			create_clover_usb.txt




#exit 1;






KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
lm_create_folder_recursive "${KVM_WORKSPACE_ISO}"  || lm_failure





#URL_FILE="Win10_1703_English_x64.iso"
#URL_FILE="Win10_1709_English_x64.iso"
#URL_FILE="Windows10_USB_2018-02-11.iso"
#URL_PLAIN="https://software-download.microsoft.com/pr"
#URL="${URL_PLAIN}/${URL_FILE}"

#URL_FILE="mac_10_11_6_clover_usb.img"
#URL_FILE="mac_os_10_8.iso"
URL_FILE="BaseSystem_High_Sierra_10.13.6.img"
# TODO: Read BaseSystem_High_Sierra_10.13.6.img.txt


LOCAL_FILE="${KVM_WORKSPACE_ISO}/${URL_FILE}"

#OSX_DRIVER_DISK="${KVM_WORKSPACE_ISO}/OSX-driver-disk.img"
# TODO: create new driver disk with:
# CUDA driver "CUDA 418.105 driver for MAC"
# https://www.nvidia.com/en-us/drivers/cuda/mac-driver-archive/
# https://www.nvidia.com/object/macosx-cuda-418.105-driver.html
# https://www.nvidia.com/content/DriverDownload-March2009/confirmation.php?url=/Mac/cuda_418/cudadriver_418.105_macos.dmg&lang=us&type=GeForce
# Download the Driver File 
# https://us.download.nvidia.com/Mac/cuda_418/cudadriver_418.105_macos.dmg


#URL_FILE_UBUNTU="ubuntu-mate-16.04.3-desktop-amd64.iso"
#LOCAL_FILE_UBUNTU="${KVM_WORKSPACE_ISO}/${URL_FILE_UBUNTU}"

#ISO_FILE="/media/4TB_Store/kvm-qemu-backup/iso-install/Win10_1703_English_x64.iso"
#ISO_FILE_USB="/media/4TB_Store/kvm-qemu-backup/iso-install/windows10.iso"







#lm_download_to_folder "${KVM_WORKSPACE_ISO}" "${URL}"  || lm_failure

#lm_verify_and_download_to_folder "${URL_FILE}" "${KVM_WORKSPACE_ISO}" "${URL_PLAIN}"  || lm_failure




# TODO: Before download check if file already exists.
#       'wget' will creat new file if exists.

# TODO: Verify that whole file was downloaded.





#exit 1;





# $ cd /opt/kvm/vm_storage/
# $ qemu-img create -f qcow2 /opt/kvm/vm_storage/windows_10.qcow2 50G
# $ cp -v /usr/share/OVMF/OVMF_VARS.fd /opt/kvm/vm_storage/windows_10_VARS.fd
# OVMF binary file. Do _NOT_ over write.
OVMF_CODE="/usr/share/OVMF/OVMF_CODE.fd"
OVMF_VARS="/usr/share/OVMF/OVMF_VARS.fd"
#KVM_WORKSPACE_VM_WIN10="${KVM_WORKSPACE}/vm/windows_10"
#KVM_WORKSPACE_VM_MAC10="${KVM_WORKSPACE}/vm/mac_10_u20"
KVM_WORKSPACE_VM_MAC10="${KVM_WORKSPACE}/vm/mac_10_13_6_u20"
#OVMF_VARS_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10_VARS.fd"
#OVMF_VARS_MAC10="${KVM_WORKSPACE_VM_MAC10}/mac_10_u20_VARS.fd"
OVMF_VARS_MAC10="${KVM_WORKSPACE_VM_MAC10}/mac_10_13_6_u20_VARS.fd"
#VM_DISK_WIN10="${KVM_WORKSPACE_VM_WIN10}/windows_10.qcow2"
#VM_DISK_MAC10="${KVM_WORKSPACE_VM_MAC10}/mac_10_u20.qcow2"
VM_DISK_MAC10="${KVM_WORKSPACE_VM_MAC10}/mac_10_13_6_u20.qcow2"
# TODO: how to create OpenCore disk?
# NOTE: copy the OpenCore from kholia's project
#VM_DISK_OPENCORE_BOOT="/home/lordmike/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2"
#VM_DISK_OPENCORE_BOOT="${KVM_WORKSPACE_VM_MAC10}/OpenCore.qcow2"
#VM_DISK_OPENCORE_BOOT="/home/lordmike/OSX-KVM/OpenCore-Catalina/OpenCore-Passthrough.qcow2"
VM_DISK_OPENCORE_BOOT="${KVM_WORKSPACE_VM_MAC10}/OpenCore-Passthrough.qcow2"


unset INPUT
lm_read_to_INPUT "Do you wanna use folder ${KVM_WORKSPACE_VM_MAC10} for virtual machine?"
case "${INPUT}" in
	"YES" )
		INPUT="YES" ;;
	"NO" )
		exit 1 ;;
	"FAILED" | * )
		lm_failure ;;
esac

# Create Ubuntu vm folder.
lm_create_folder_recursive "${KVM_WORKSPACE_VM_MAC10}"  || lm_failure




















# OVMF file for vm. UEFI boot.
if [[ -f "${OVMF_VARS}" ]]; then
	if [[ ! -f "${OVMF_VARS_MAC10}" ]]; then
		lm_copy_file "${OVMF_VARS}" "${OVMF_VARS_MAC10}"  || lm_failure
	else
		echo -e "\n File ${OVMF_VARS_MAC10} alrealy exists.\n"
	fi
else
	>&2 echo -e "\n File ${OVMF_VARS} missing. Did you installed OVMF?  Aborting."
	exit 1
fi

# Create Windows vm virtual disk.
if [[ ! -f "${VM_DISK_MAC10}" ]]; then
	echo ""
	echo "Createing file ${VM_DISK_MAC10}"
	echo ""
	qemu-img create -f qcow2 "${VM_DISK_MAC10}" 50G  || lm_failure
else
	echo -e "\n File ${VM_DISK_MAC10} alrealy exists.\n"
fi












echo ""
echo "Starting the vm."
echo ""
#echo "Use Disk Utility to partition the disk."
#echo ""
#echo ""
#echo "TODO: Could partition be done automatically at Linux?"
#echo ""



# Host device bus address
#GPU_BUS="01:00.0" # Nvidia GeForce GTX 1050 # ASUSTeK Computer Inc. Device
#GPU_SOUND="01:00.1"
#GPU_BUS="02:00.0" # Nvidia GeForce GT 710 # Micro-Star International Co., Ltd. [MSI] Device
#GPU_SOUND="02:00.1"

VM_GPUS_CONF_FILE="$(realpath "${CURRENT_SCRIPT_DIR}/../../host/ubuntu-mate_20_04_1_LTS/vm_GPUs.conf")"
unset GPU_BUS GPU_SOUND SELECTED
lm_select_gpu_GPU_BUS_and_GPU_SOUND "${VM_GPUS_CONF_FILE}"  || lm_failure



# TODO: Set parameters for QEMU

# -enable-kvm -> enable hardware virtualization
PAR=" -enable-kvm"
#PAR='-device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"'
#PAR="${PAR} -enable-kvm"

# Mother board
#PAR="${PAR} -M q35"
#PAR="${PAR} -machine pc-q35-2.4"
#PAR="${PAR} -machine q35"
PAR="${PAR} -machine pc-q35-2.9"

# Memory
PAR="${PAR} -m 4096"

# CPU
#PAR="${PAR} -cpu host,kvm=off"
#PAR="${PAR} -cpu Penryn,kvm=on,vendor=GenuineIntel"
PAR="${PAR} -cpu host,kvm=on,vendor=GenuineIntel,vmware-cpuid-freq=on,+invtsc,+hypervisor"
PAR="${PAR} -smp 4,sockets=1,cores=4,threads=1"

# Boot menu
PAR="${PAR} -boot menu=on"


# -device isa-applesmc,osk="insert-real-64-char-OSK-here" 
#PAR="${PAR} -device isa-applesmc,osk=\"ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc\""
PAR="${PAR} -device isa-applesmc,osk=ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
PAR="${PAR} -smbios type=2"

PAR="${PAR} -device ich9-intel-hda"
PAR="${PAR} -device hda-duplex"
PAR="${PAR} -device ich9-ahci,id=sata"

# Display   qxl
# TODO: Ask user if virtual display is needed.
#PAR="${PAR} -vga qxl"
#PAR="${PAR} -display sdl"
#PAR="${PAR} -display none"
#PAR="${PAR} -vga none"

# TODO: can mac show image in virtual and real display at once ???
echo ""
if [[ "${SELECTED}" == "0" ]]; then
	echo "No desplay device selected. Initialize virtual one."
	PAR="${PAR} -vga qxl"
	# NOTE: start 'spice' only if 'qxl' virtual card is used
	SPICE_PORT=5975
else
	echo "NOTE: Can not use physical and virtal display at same time :("
	PAR="${PAR} -vga none"
	PAR="${PAR} -display none"
fi



# Display 'spice'
#SPICE_PORT=5975
if [[ -n ${SPICE_PORT} ]]; then
	# https://wiki.gentoo.org/wiki/QEMU/Linux_guest
	# https://www.spice-space.org/download.html
	# TODO: How to do spice with mac ?
	# 
	PAR="${PAR} -spice port=${SPICE_PORT},disable-ticketing"
	# 
	PAR="${PAR} -device virtio-serial"
	PAR="${PAR} -chardev spicevmc,id=vdagent,name=vdagent"
	PAR="${PAR} -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
	
    PAR="${PAR} -usb -device usb-kbd -device usb-tablet"
    PAR="${PAR} -device usb-ehci,id=ehci"
    PAR="${PAR} -device usb-kbd,bus=ehci.0"
    PAR="${PAR} -device usb-mouse,bus=ehci.0"
    PAR="${PAR} -device nec-usb-xhci,id=xhci"
    
    #PAR="${PAR} -device usb-host,bus=xhci.0,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    #PAR="${PAR} -device usb-host,bus=xhci.0,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
    
    # Passthrough wholw USB controller
    #USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Renesas Technology Corp. uPD720201 USB 3.0 Host Controller (rev 03)
else
    # NOTE: connection host usb devices causes errors and does not work !?
    # libusb: error [_open_sysfs_attr] open /sys/bus/usb/devices/1-1/bConfigurationValue failed ret=-1 errno=2
    # qemu-system-x86_64: libusb_release_interface: -4 [NO_DEVICE]
    # libusb: error [udev_hotplug_event] ignoring udev action bind
    
    # https://bugzilla.redhat.com/show_bug.cgi?id=980415
    # https://forums.unraid.net/topic/42679-usb-pass-through-problems/
    # ... hmmm ... macOS High Sierra is reseting all usb deviced during boot !?!?
    
    # Passthrough wholw USB controller
    USB_CONTROLLER="05:00.0" # 05:00.0 USB controller: Renesas Technology Corp. uPD720201 USB 3.0 Host Controller (rev 03)
    
    #PAR="${PAR} -usb"
    #PAR="${PAR} -device usb-ehci,id=ehci"
    #PAR="${PAR} -device usb-kbd,bus=ehci.0"
    #PAR="${PAR} -device usb-mouse,bus=ehci.0"
    PAR="${PAR} -device nec-usb-xhci,id=xhci"
    #PAR="${PAR} -device usb-host,bus=xhci.0,vendorid=0x046d,productid=0xc077" # Bus 001 Device 006: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
    #PAR="${PAR} -device usb-host,bus=xhci.0,vendorid=0x1a2c,productid=0x2c27" # 1a2c:2c27 China Resource Semico Co., Ltd USB Keyboard    a.k.a Trust
    
    #PAR="${PAR} -device usb-host,bus=xhci.0,hostbus=1,hostport=15"
    #PAR="${PAR} -device usb-host,bus=xhci.0,hostbus=1,hostport=14"
    
    #PAR="${PAR} -device usb-kbd"
    #PAR="${PAR} -device usb-tablet"
fi


# Monitoring screen
PAR="${PAR} -monitor stdio"


# USB redirection
#USB_REDIR=true
#USB_REDIR_TYPE="USB3"
#USB_REDIR_TYPE="USB2"
if [[ -n ${USB_REDIR} ]]; then
	# https://www.spice-space.org/usbredir.html
	# TODO: How to do spice with mac ?
	# 
	case "${USB_REDIR_TYPE}" in
		"USB3" )
			# NOTE: USB3 support
			#PAR="${PAR} -device nec-usb-xhci,id=usb"
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
#PAR="${PAR} -device usb-host,hostbus=1,hostaddr=3" # Bus 001 Device 007: ID 046d:c31c Logitech, Inc. Keyboard K120
#PAR="${PAR} -usbdevice tablet"

# OVMF
PAR="${PAR} -drive file=${OVMF_CODE},if=pflash,format=raw,unit=0,readonly=on"
PAR="${PAR} -drive file=${OVMF_VARS_MAC10},if=pflash,format=raw,unit=1"

# Add pcie bus 1
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

# TODO: samba share


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
if [[ ! -z ${USB_CONTROLLER} ]]; then
    # https://github.com/qemu/qemu/blob/master/docs/pcie.txt
    
    # Add pcie bus 2
    PAR="${PAR} -device ioh3420,bus=pcie.0,addr=1e.0,chassis=2,id=root.2"
    
	#PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.1,addr=00.0,multifunction=on"
	PAR="${PAR} -device vfio-pci,host=${USB_CONTROLLER},bus=root.2"
fi






#  -device ide-hd,bus=sata.2,drive=OpenCoreBoot
#  -drive id=OpenCoreBoot,if=none,snapshot=on,format=qcow2,file="$REPO_PATH/OpenCore-Catalina/OpenCore.qcow2"
PAR="${PAR} -device ide-hd,bus=sata.2,drive=OpenCoreBoot"
PAR="${PAR} -drive id=OpenCoreBoot,if=none,snapshot=on,format=qcow2,file=${VM_DISK_OPENCORE_BOOT}"

#  -device ide-hd,bus=sata.3,drive=InstallMedia
#  -drive id=InstallMedia,if=none,file="$REPO_PATH/BaseSystem.img",format=raw
PAR="${PAR} -device ide-hd,bus=sata.3,drive=InstallMedia"
PAR="${PAR} -drive id=InstallMedia,if=none,file=${LOCAL_FILE},format=raw"

#  -device ide-hd,bus=sata.4,drive=MacHDD
#  -drive id=MacHDD,if=none,file="$REPO_PATH/mac_hdd_ng.img",format=qcow2
PAR="${PAR} -device ide-hd,bus=sata.4,drive=MacHDD"
PAR="${PAR} -drive id=MacHDD,if=none,file=${VM_DISK_MAC10},format=qcow2"


# Virtual disk
#PAR="${PAR} -drive file=${VM_DISK_MAC10},format=qcow2 "
#PAR="${PAR} -drive file=${VM_DISK_MAC10},format=qcow2,if=none,id=drive-ide0-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0"

# Windows 10 ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE},id=isocd,format=raw,index=2 "
#PAR="${PAR} -drive file=${ISO_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${ISO_FILE_USB},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -drive file=${LOCAL_FILE},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"
#PAR="${PAR} -drive id=MacDVD,if=none,snapshot=on,file=${LOCAL_FILE} "
#PAR="${PAR} -device ide-drive,bus=ide.1,drive=MacDVD "


# OSX_DRIVER_DISK
#PAR="${PAR} -device ide-drive,bus=ide.2,drive=MacDriver "
#PAR="${PAR} -drive id=MacDriver,if=none,format=raw,file=${OSX_DRIVER_DISK} "


# Ubuntu ISO file
#PAR="${PAR} -drive file=${LOCAL_FILE_UBUNTU},format=raw,if=none,id=drive-ide1-0-0"
#PAR="${PAR} -device ide-hd,bus=ide.1,unit=0,drive=drive-ide1-0-0,id=ide1-0-0"

# Sound card
#PAR="${PAR} -soundhw hda"

# Network
MACADDRESS="$(lm_generate_mac_address)"  || lm_failure
#PAR="${PAR} -netdev user,id=user.0"
#PAR="${PAR} -device e1000,netdev=user.0"
#PAR="${PAR} -device e1000-82545em,id=net0,mac=52:54:00:c9:18:27,netdev=user.0"



# Internal networking. Bridged networking.
# NOTE: virbr0 is created by virsh default network
# If virsh is installed it should start at boot.
#  $ virsh net-start default
#PAR="${PAR} -net nic -net bridge,br=virbr0"
PAR="${PAR} -netdev bridge,br=virbr0,id=user.0"
#PAR="${PAR} -device e1000-82545em,id=net0,mac=52:54:00:c9:18:27,netdev=user.0"
PAR="${PAR} -device vmxnet3,netdev=user.0,mac=${MACADDRESS}"


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

# TODO: How to set applesmc into varible
#sudo qemu-system-x86_64 ${PAR}  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"


echo ""
echo "End of script '${CURRENT_SCRIPT}'"

