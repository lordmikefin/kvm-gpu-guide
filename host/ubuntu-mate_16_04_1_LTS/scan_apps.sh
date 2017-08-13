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
CURRENT_SCRIPT_VER="0.0.3-alpha"
CURRENT_SCRIPT_DATE="2017-08-13"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"



# NOTE to myself: Read more about Bash exit codes.
#   ( http://tldp.org/LDP/abs/html/exitcodes.html )

unset OS_NAME OS_VER OS_ARCH CURRENT_SHELL
OS_NAME="$(uname)"
OS_VER="$(uname -r)"
OS_ARCH="$(uname -m)"
if [ ${OS_NAME} != "Linux" ] ; then
	echo "System is not Linux. This script is tested only with Linux.  Aborting." >&2
	exit 1 # 127
fi

CURRENT_SHELL="$(basename $SHELL)"
if [ ${CURRENT_SHELL} != "bash" ] ; then
	echo "This script is tested only with Bash.  Aborting." >&2
	exit 1 # 127
fi


LANG="en_US.UTF-8" # Prevent output localization. Not really required :)




# NOTE to myself: How to get absolute path of file. 
#   ( https://stackoverflow.com/questions/17577093/how-do-i-get-the-absolute-directory-of-a-file-in-bash )

unset CURRENT_SCRIPT CURRENT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR
#CURRENT_SCRIPT_DIR="$(dirname $(readlink -f "$0"))"
CURRENT_REALPATH="$(realpath ${0})"
#CURRENT_SCRIPT="$(basename ${0})"
CURRENT_SCRIPT="$(basename ${CURRENT_REALPATH})"
CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_REALPATH})"
WORK_DIR="${PWD}"
echo ""
echo "CURRENT_SCRIPT: ${CURRENT_SCRIPT}"
echo "CURRENT_REALPATH: ${CURRENT_REALPATH}"
echo "CURRENT_SCRIPT_DIR: ${CURRENT_SCRIPT_DIR}"
echo "WORK_DIR: ${WORK_DIR}"





# Output file will contain information about found applications.
unset MY_APPS_TXT OUTPUT_FILE TEXT USER_INPUT
MY_APPS_TXT="MyApps.txt"
OUTPUT_FILE="${CURRENT_SCRIPT_DIR}/${MY_APPS_TXT}"
echo ""
echo "MY_APPS_TXT: ${MY_APPS_TXT}"
echo "OUTPUT_FILE: ${OUTPUT_FILE}"





# NOTE to myself: Read more about Bash conditional statements.
#   ( http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html )

if [ -a "${OUTPUT_FILE}" ] ; then
	echo "File ${OUTPUT_FILE} exists."
	read -p "Do you want to overwrit the file ([Yes]/No): " USER_INPUT
	echo "USER_INPUT: ${USER_INPUT}"
	
	echo "Output file exists.  Aborting." >&2
	exit 1
fi




echo "This script is in test mode :)  Aborting." >&2
exit 1 # 127




echo "" | tee ${OUTPUT_FILE} # Clear the output file
echo "Bash version ${BASH_VERSION}" | tee -a ${OUTPUT_FILE}

echo "" | tee -a ${OUTPUT_FILE}
TEXT="OS name: ${OS_NAME}, Kernel version: ${OS_VER}, Arch: ${OS_ARCH}"
echo "${TEXT}" | tee -a ${OUTPUT_FILE}







#echo "This script is in test mode :)  Aborting." >&2
#exit 1 # 127







echo ""
echo "End of script '${CURRENT_SCRIPT}'"

