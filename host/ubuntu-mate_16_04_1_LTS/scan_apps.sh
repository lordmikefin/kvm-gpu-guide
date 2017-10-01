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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/host/ubuntu-mate_16_04_1_LTS/scan_apps.sh

# Scan all applications needed for host system.
# And list version of all applications.
# All information is listed into console and text file.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.11"
CURRENT_SCRIPT_DATE="2017-08-13"
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




#echo -e "\n This script is in test mode :)  Aborting." >&2
#exit 1








function print_dpkg_version() {
	unset DPKG_VER
	DPKG_VER="$(echo "${DPKG_INFO}" | awk '/Version:/ {print $2}')"
	echo "" | tee -a ${OUTPUT_FILE}
	echo "Package '${DPKG}' is installed. OK" | tee -a ${OUTPUT_FILE}
	echo "Version: ${DPKG_VER}" | tee -a ${OUTPUT_FILE}
}


#DPKG_MISSING=""
unset DPKG_MISSING DPKG_MISSING_OPT
function dpkg_version() {
	unset METHOD_TYPE DPKG DPKG_INFO
	METHOD_TYPE="${1}"
	DPKG="${2}"
	
	case ${METHOD_TYPE} in
		required )
			DPKG_INFO="$(dpkg -s ${DPKG}  2>/dev/null )" && {
				print_dpkg_version # Operation succeeded
			} || {
				echo ""
				echo "Package '${DPKG}' is missing. FAILED" >&2
				echo "Package '${DPKG}' is required, but it's not installed.  Aborting." >&2
				DPKG_MISSING="${DPKG_MISSING} ${DPKG}"
			}
			;;
		optional )
			DPKG_INFO="$(dpkg -s ${DPKG}  2>/dev/null )" && {
				print_dpkg_version # Operation succeeded
			} || {
				echo ""
				echo "Package '${DPKG}' is optional. Not really needed, but is recommended."
				DPKG_MISSING_OPT="${DPKG_MISSING_OPT} ${DPKG}"
			}
			;;
		* )
			echo ""
#			echo "Script ${0}  FAILED" >&2
			echo "Script ${CURRENT_SCRIPT}  FAILED" >&2
			echo "First parameter for function '${FUNCNAME[ 0 ]}' must be 'optional' or 'required'.  Aborting." >&2
			exit 1; 
			;;
	esac
}






function print_app_version_core() {
	unset APP_CALLER APP_PARAM
	APP_CALLER="${1}"
	APP_PARAM="${2}"
	
	if [ -z "${VERSION_PRINT}" ] ; then
		VERSION_PRINT="$(${APP_CALL} ${APP_PARAM}  2>/dev/null )"
	fi
	
}

function print_app_version() {
	unset APP_CALL VERSION_PRINT
	APP_CALL="${1}"
	
	print_app_version_core "${APP_CALL}" "--version"

#	echo ""
	if [ -n "${VERSION_PRINT}" ] ; then
		echo "${VERSION_PRINT}" | tee -a ${OUTPUT_FILE}
	else
		echo "FAILED: Can not get version."
		echo " $ ${EXEC_APP} --version"
		${APP_CALL} --version
	fi
}

# NOTE to myself: Read more about how to test if application exists.
#   ( https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script )

function app_version() {
	unset METHOD_TYPE APP EXEC_APP
	METHOD_TYPE="${1}"
	APP="${2}"
	
	EXEC_APP="$(which ${APP})"
	
	echo "" | tee -a ${OUTPUT_FILE};
	case ${METHOD_TYPE} in
		required )
			if [[ -n ${EXEC_APP} ]] ; then
				echo "'${APP}' Application exists. OK" | tee -a ${OUTPUT_FILE};
				print_app_version ${EXEC_APP}
			else
				echo "Application missing. FAILED" >&2
				echo "'${APP}' is required, but it's not installed.  Aborting." >&2
				echo "'${APP}' is not installed."
			fi
			;;
		optional )
			if [[ -n ${EXEC_APP} ]] ; then
				echo "'${APP}' Application exists. OK" | tee -a ${OUTPUT_FILE};
				print_app_version ${EXEC_APP}
			else
				echo "'${APP}' is optional. Not really needed, but is recommended." >&2
				echo "'${APP}' is not installed."
			fi
			;;
		* )
#			echo "Script ${0}  FAILED" >&2
			echo "Script ${CURRENT_SCRIPT}  FAILED" >&2
			echo "First parameter for function '${FUNCNAME[ 0 ]}' must be 'optional' or 'required'.  Aborting." >&2
			exit 1;
			;;
	esac
}








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
unset MY_APPS_TXT OUTPUT_FILE TEXT
LANG="en_US.UTF-8" # Prevent output localization. Not really required ;)
MY_APPS_TXT="MyApps.txt"
OUTPUT_FILE="${CURRENT_SCRIPT_DIR}/${MY_APPS_TXT}"
echo ""
echo "MY_APPS_TXT: ${MY_APPS_TXT}"
echo "OUTPUT_FILE: ${OUTPUT_FILE}"





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



#echo "This script is in test mode :)  Aborting." >&2
#exit 1 # 127




echo "" | tee ${OUTPUT_FILE} # Clear the output file

#echo "Result of script: ${CURRENT_SCRIPT_REALPATH}" | tee -a ${OUTPUT_FILE}
echo "Result of script: ${CURRENT_SCRIPT}" | tee -a ${OUTPUT_FILE}
TEXT="Script version: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"
echo "${TEXT}"  | tee -a ${OUTPUT_FILE}
echo "-----------------------------------------------"  | tee -a ${OUTPUT_FILE}

# OS
TEXT="OS name: ${OS_NAME}, Kernel version: ${OS_VER}, Arch: ${OS_ARCH}"
echo -e "\n${TEXT}" | tee -a ${OUTPUT_FILE}

# Distribution
echo -e "\nDistro name: ${NAME}, Version: ${VERSION}" | tee -a ${OUTPUT_FILE}

# Desktop Environment
if [[ -n ${EXEC_MATE_ABOUT} ]] ; then
	echo "$(${EXEC_MATE_ABOUT} -v)" | tee -a ${OUTPUT_FILE}
else
	echo -e "\n'MATE Desktop' is not installed." | tee -a ${OUTPUT_FILE}
fi

# Bash
echo -e "\nBash version ${BASH_VERSION}" | tee -a ${OUTPUT_FILE}



# Debian packages 
dpkg_version required ovmf
dpkg_version required qemu-kvm
dpkg_version required virt-manager

dpkg_version optional git
dpkg_version optional gitg
dpkg_version optional joe
dpkg_version optional gparted
dpkg_version optional aptitude
dpkg_version optional keepassx



# Application versions
# TODO: How to get  'ovmf' version ??????
app_version required qemu-system-x86_64
app_version required virsh # NOTE: 'virt-manager' prints version number as error ?!?!?!

app_version optional git
app_version optional gitg
#dpkg_version optional joe # Can not print 'joe' version ??
app_version optional parted # Can not print 'gparted' version ??
app_version optional aptitude
app_version optional keepassx


# TODO: How to get 'retext' version ??
#  Check if it exists. If not point to guide.  TODO: create the guide :)
#    $ which retext
#app_version optional retext




if [[ -n ${DPKG_MISSING} ]] ; then
	echo ""
	echo "Required packages are missing." >&2
	echo "$ sudo apt-cache  show ${DPKG_MISSING}"
	echo "$ sudo apt-get install ${DPKG_MISSING}"
#	exit 1
fi

if [[ -n ${DPKG_MISSING_OPT} ]] ; then
	echo ""
	echo "Optional packages are missing." >&2
	echo "$ sudo apt-cache  show ${DPKG_MISSING_OPT}"
	echo "$ sudo apt-get install ${DPKG_MISSING_OPT}"
fi






#echo "This script is in test mode :)  Aborting." >&2
#exit 1 # 127







echo ""
echo "End of script '${CURRENT_SCRIPT}'"

