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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/host/ubuntu-mate_16_04_1_LTS/scan_gpus.sh

# Scan all GPUs of host system.
# Create file with information about GPUs.
# Create vfio configuration file. It can be used by /etc/modprobe.d/



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.2"
CURRENT_SCRIPT_DATE="2017-10-08"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"


# NOTE to myself: Read more about Bash exit codes.
#   ( http://tldp.org/LDP/abs/html/exitcodes.html )

unset OS_NAME OS_VER OS_ARCH CURRENT_SHELL
OS_NAME="$(uname)"
OS_VER="$(uname -r)"
OS_ARCH="$(uname -m)"
if [[ ${OS_NAME} != "Linux" ]] ; then
	echo -e "\n System is not Linux. This script is tested only with Linux.  Aborting." >&2
	exit 1 # 127
fi

CURRENT_SHELL="$(basename $SHELL)"
if [[ ${CURRENT_SHELL} != "bash" ]] ; then
	echo -e "\n This script is tested only with Bash.  Aborting." >&2
	exit 1 # 127
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







# Output file will contain information about found applications.
unset MY_GPUS_TXT OUTPUT_FILE TEXT VFIO_CONF_FILE OUTPUT_VFIO_CONF_FILE
LANG="en_US.UTF-8" # Prevent output localization. Not really required ;)
MY_GPUS_TXT="MyGPUs.txt"
OUTPUT_FILE="${CURRENT_SCRIPT_DIR}/${MY_GPUS_TXT}"
echo ""
echo "MY_GPUS_TXT: ${MY_GPUS_TXT}"
echo "OUTPUT_FILE: ${OUTPUT_FILE}"


# vfio.conf will contain settings for vfio-pci driver.
# Copy this file into /etc/modprobe.d/
VFIO_CONF_FILE="vfio.conf"
OUTPUT_VFIO_CONF_FILE="${CURRENT_SCRIPT_DIR}/${VFIO_CONF_FILE}"






# Check OUTPUT_FILE
unset USER_INPUT
if [ -a "${OUTPUT_FILE}" ] ; then
	echo ""
	echo "File exists:  ${OUTPUT_FILE}"
	while [[ -z ${USER_INPUT} ]]; do
		echo -n "Do you want to overwrite the file (Yes/[No]): "
		read USER_INPUT
		case "${USER_INPUT}" in
			Yes | YES | yes | y )
				USER_INPUT="YES" ;;
			No | NO | no | n | "" )
				USER_INPUT="NO"
				unset OUTPUT_FILE # Clear file name. No file to overwrite.
				;;
			* )
				unset USER_INPUT ;; # Clear input ( = stay in while loop )
		esac
	done
fi

if [ -z "${OUTPUT_FILE}" ] ; then
	echo "No output file will be created."
else
	echo "Writing info into file:"
	echo "${OUTPUT_FILE}"
fi



echo "" | tee ${OUTPUT_FILE} # Clear the output file


#echo "Result of script: ${CURRENT_SCRIPT_REALPATH}" | tee -a ${OUTPUT_FILE}
echo "Result of script: ${CURRENT_SCRIPT}" | tee -a ${OUTPUT_FILE}
TEXT="Script version: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"
echo "${TEXT}"  | tee -a ${OUTPUT_FILE}
echo "-----------------------------------------------"  | tee -a ${OUTPUT_FILE}


#NVIDIA_VGA=$(lspci -nn | grep -i nvidia | grep -i vga)
VGA=$(lspci -nn | grep -i vga)

COUNT=0
HAS_NVIDIA=0
NVIDIA_DEVICES=""

# Set array separator as newline.
BACKUP_IFS="${IFS}"
IFS='
'

# Look for Nvidia and Intel GPUs. Write info into 'MyDevices.txt' file.
#for i in ${NVIDIA_VGA} ; do
for i in ${VGA} ; do
	let COUNT=COUNT+1
	echo "loop counter: ${COUNT}"
	echo "loop var i: ${i}"

	PCI_BUS_VGA=""
	PCI_BUS_AUDIO=""
	DEVICE_TYPE=""
	DEVICE_TYPE_AUDIO=""
	IS_NVIDIA=0
	IS_INTEL=0
	IFS=' '
	for x in ${i} ; do
		#echo ${x}
		if [[ ${x} == *":"*"."* ]] ; then
			#echo "pci bus: ${x}"
			PCI_BUS_VGA=${x}
		fi
		if [[ ${x} == "["*":"*"]" ]] ; then
			#echo "device type [ManufactureID:DeviceTypeID]: ${x}"
			DEVICE_TYPE=${x}
		fi
		if [ ${x} == "NVIDIA" ] ; then
			#echo "is nvidia: ${x}"
			IS_NVIDIA=1
			HAS_NVIDIA=1
		fi
		if [ ${x} == "Intel" ] ; then
			#echo "is nvidia: ${x}"
			IS_INTEL=1
		fi
	done
	echo 
	#echo ${IS_NVIDIA}
	if [ ${IS_NVIDIA} == 1 ] ; then
		echo "Card is NVIDIA"
		echo "pci bus: ${PCI_BUS_VGA}"
		echo "device type [ManufactureID:DeviceTypeID]: ${DEVICE_TYPE}"
		lspci -nnk -s ${PCI_BUS_VGA}
		IFS='.' # Set array separator as period.
		for x in ${PCI_BUS_VGA} ; do
			#echo ${x}
			if [[ ${x} == *":"* ]] ; then
				#echo ${x}
				# Nvidia audio device is usually in XX.00.1 address
				PCI_BUS_AUDIO=${x}.1 
				IFS=' ' # Set non array separator.
				#echo ${PCI_BUS_AUDIO}
				lspci -nnk -s ${PCI_BUS_AUDIO}
				for z in $(lspci -nn -s ${PCI_BUS_AUDIO}) ; do
					#echo ${z}
					if [[ ${z} == "["*":"*"]" ]] ; then
						#echo ${z}
						echo "device type [ManufactureID:DeviceTypeID]: ${z}"
						DEVICE_TYPE_AUDIO=${z}
					fi
				done
			fi
		done
		
		IFS='' # Set non array separator.
		echo $(lspci -nnk -s ${PCI_BUS_VGA})  | tee -a ${OUTPUT_FILE}
		echo $(lspci -nnk -s ${PCI_BUS_AUDIO})  | tee -a ${OUTPUT_FILE}
		#NVIDIA_DEVICES=${NVIDIA_DEVICES},${DEVICE_TYPE},${DEVICE_TYPE_AUDIO}
		NVIDIA_DEVICES=${NVIDIA_DEVICES}${DEVICE_TYPE}${DEVICE_TYPE_AUDIO}
	fi
	if [ ${IS_INTEL} == 1 ] ; then
		echo "Card is Intel"
		echo "pci bus: ${PCI_BUS_VGA}"
		echo "device type [ManufactureID:DeviceTypeID]: ${DEVICE_TYPE}"
		lspci -nnk -s ${PCI_BUS_VGA}
		echo $(lspci -nnk -s ${PCI_BUS_VGA})  | tee -a ${OUTPUT_FILE}
	fi
	echo 
done



IFS="${BACKUP_IFS}"

# End file    OUTPUT_FILE






# Check OUTPUT_VFIO_CONF_FILE
unset USER_INPUT
if [ -a "${OUTPUT_VFIO_CONF_FILE}" ] ; then
	echo ""
	echo "File exists:  ${OUTPUT_VFIO_CONF_FILE}"
	while [[ -z ${USER_INPUT} ]]; do
		echo -n "Do you want to overwrite the file (Yes/[No]): "
		read USER_INPUT
		case "${USER_INPUT}" in
			Yes | YES | yes | y )
				USER_INPUT="YES" ;;
			No | NO | no | n | "" )
				USER_INPUT="NO"
				unset OUTPUT_VFIO_CONF_FILE # Clear file name. No file to overwrite.
				;;
			* )
				unset USER_INPUT ;; # Clear input ( = stay in while loop )
		esac
	done
fi

if [ -z "${OUTPUT_VFIO_CONF_FILE}" ] ; then
	echo "No output file will be created."
else
	echo "Writing info into file:"
	echo "${OUTPUT_VFIO_CONF_FILE}"
fi



echo "" | tee ${OUTPUT_VFIO_CONF_FILE} # Clear the output file


#echo "Result of script: ${CURRENT_SCRIPT_REALPATH}" | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# Result of script: ${CURRENT_SCRIPT}" | tee -a ${OUTPUT_VFIO_CONF_FILE}
TEXT="Script version: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"
echo "# ${TEXT}"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# -----------------------------------------------"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# "  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# Set this file into folder:"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# /etc/modprobe.d/"  | tee -a ${OUTPUT_VFIO_CONF_FILE}


# You need to set the host to ignore MSRS, or your OS X will bootloop.
# ( https://zllovesuki.git.sx/essays/tags/qemu/ )
echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# You need to set the host to ignore MSRS, or your OS X will bootloop."  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "# ( https://zllovesuki.git.sx/essays/tags/qemu/ )"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "options kvm_intel nested=1"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "options kvm_intel emulate_invalid_guest_state=0"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
echo "options kvm ignore_msrs=1"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
#echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}




# Write Nvidia GPU device ids into 'vfio.conf' file.
if [ ${IS_NVIDIA} == 1 ] ; then
	echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}
	echo "blacklist nouveau"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
	#VFIO_OPTIONS="options vfio-pci ids="
	VFIO_OPTIONS=""
	# Set array separators.
	IFS='[]'
	echo "list of device types: ${NVIDIA_DEVICES}"
	for i in ${NVIDIA_DEVICES} ; do
		#echo ${i}
		if [ ! -z ${i} ] ; then # Not empty
			#echo ${i}
			if [ -z ${VFIO_OPTIONS} ] ; then # Is empty
				VFIO_OPTIONS=${i}
			else
				VFIO_OPTIONS=${VFIO_OPTIONS},${i}
			fi
		fi
	done
	
	#echo "options vfio-pci ids=${VFIO_OPTIONS}"
	echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}
	echo "options vfio-pci ids=${VFIO_OPTIONS}"  | tee -a ${OUTPUT_VFIO_CONF_FILE}
fi

echo ""  | tee -a ${OUTPUT_VFIO_CONF_FILE}





echo ""
echo "End of script '${CURRENT_SCRIPT}'"

