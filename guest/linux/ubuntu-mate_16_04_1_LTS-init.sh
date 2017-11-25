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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/linux/ubuntu-mate_16_04_1_LTS-init.sh

# ubuntu-mate_16_04_1_LTS-init.sh
# Initialize ubuntu-mate_16_04 virtual machine.
# This script will create a new vm into folder ~/kvm-workspace/ubuntu-mate_16_04/



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.9"
CURRENT_SCRIPT_DATE="2017-11-25"
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
IMPORT_FUNCTIONS="$(realpath "${CURRENT_SCRIPT_DIR}/../../script/lm_functions.sh")"
if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
	exit 1
fi

source ${IMPORT_FUNCTIONS}

if [ ${LM_FUNCTIONS_LOADED} == false ]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Something went wrong with loading funcions."
	exit 1
elif [ ${LM_FUNCTIONS_VER} != "0.0.3" ]; then
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




## NOTE to myself: How to get absolute path of file. 
##   ( https://stackoverflow.com/questions/17577093/how-do-i-get-the-absolute-directory-of-a-file-in-bash )
#
#unset CURRENT_SCRIPT CURRENT_SCRIPT_REALPATH CURRENT_SCRIPT_DIR WORK_DIR
##CURRENT_SCRIPT_REALPATH="$(realpath ${0})"
#CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
#CURRENT_SCRIPT="$(basename ${CURRENT_SCRIPT_REALPATH})"
#CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_SCRIPT_REALPATH})"
#WORK_DIR="${PWD}"
#echo ""
#echo "CURRENT_SCRIPT: ${CURRENT_SCRIPT}"
#echo "CURRENT_SCRIPT_REALPATH: ${CURRENT_SCRIPT_REALPATH}"
#echo "CURRENT_SCRIPT_DIR: ${CURRENT_SCRIPT_DIR}"
#echo "WORK_DIR: ${WORK_DIR}"






# Check if KVM_WORKSPACE variable is set.

# if not ask user if she/he wants to continue using default path:
#   /home/<USER>/kvm-workspace

unset KVM_WORKSPACE_DEFAULT
lm_check_KVM_WORKSPACE






# TODO: copy ubuntu-mate-16.04.1-desktop-amd64.iso into folder 'iso'

#   https://ubuntu-mate.org/download/

#   cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso

#   magnet:?xt=urn:btih:fa5a86377cc38d2bd75339ebe5c0ebc5f593cb90&dn=ubuntu-mate-16.04.3-desktop-amd64.iso&tr=http%3A%2F%2Ftorrent.ubuntu.com%3A6969%2Fannounce



KVM_WORKSPACE_ISO="${KVM_WORKSPACE}/iso"
lm_create_folder_recursive "${KVM_WORKSPACE_ISO}"  || lm_failure


# $ wget cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso

# $ wget --spider cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/
# $ wget --spider cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso

# $ wget --spider --server-response cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso

# $ wget --spider cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.1-desktop-amd64.iso


# wget --spider -r --no-parent cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/

# --accept-regex=REGEX

# $ wget --spider -r --no-parent --accept-regex=.*-desktop-amd64.iso cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/

# $ wget --spider -r --no-parent --accept-regex=.*-desktop-amd64.iso cdimage.ubuntu.com/ubuntu-mate/releases/*/*/
URL_FILE="ubuntu-mate-16.04.3-desktop-amd64.iso"
URL_PLAIN="cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release"
URL="${URL_PLAIN}/${URL_FILE}"

LOCAL_FILE="${KVM_WORKSPACE_ISO}/${URL_FILE}"

#lm_download_to_folder "${KVM_WORKSPACE_ISO}" "${URL}"  || lm_failure


lm_verify_and_download_to_folder "${URL_FILE}" "${KVM_WORKSPACE_ISO}" "${URL_PLAIN}"  || lm_failure


# TODO: Before download check if file already exists.
#       'wget' will creat new file if exists.

# TODO: Verify that whole file was downloaded.


#TEST="$(wget --spider cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso 2>&1)"  || lm_failure
#TEST=$(wget --spider cdimage.ubuntu.com/ubuntu-mate/releases/16.04.3/release/ubuntu-mate-16.04.3-desktop-amd64.iso 2>&1)  || lm_failure
#echo ""
#echo "TEST : ${TEST}" | grep -i "Length:"
#LENGTH="$(echo "${TEST}" | grep -i "Length:")"
#LENGTH=$(echo "${TEST}" | grep -i "Length:")
#echo "LENGTH[0] : ${LENGTH[0]}"
#echo "LENGTH[1] : ${LENGTH[1]}"

#ATEST=(${LENGTH})
#echo "ATEST[0] : ${ATEST[0]}"


#ARRAY=(${LENGTH})
#	IFS_BACKUP="${IFS}"
#	IFS=" "
#	unset ARRAY
#	#for XXX in "${TEST}"
#	i=0
#	for XXX in ${LENGTH}; do
#		echo "XXX : ${XXX}"
#		ARRAY[i]="${XXX}"
#		i=$i+1
#	done
#	IFS="${IFS_BACKUP}"

#REGEX_INTEGER="^[0-9]+$"
#REGEX=""
#if [  "aa${ARRAY[1]}" > 0 ]; then
#if [[  "${ARRAY[1]}" =~ "^[0-9]+$" ]]; then
#if [[  123 =~ ^[0-9]+$ ]]; then
#if [[  "${ARRAY[1]}" =~ "${REGEX}" ]]; then
#if [[ "${REGEX_INTEGER}" != "" ]] && [[  "${ARRAY[1]}" =~ ${REGEX_INTEGER} ]]; then
#	echo "ARRAY[1]   is number ??"
#else
#	echo "ARRAY[1]   is NOT number ??"
#fi

#echo "ARRAY[1] : ${ARRAY[1]}"
#URL_SIZE="${ARRAY[1]}"



#LS_LOCAL_FILE="$(ls -l "${LOCAL_FILE}")"
#
#IFS_BACKUP="${IFS}"
#IFS=" "
#unset ARRAY
#i=0
#for XXX in ${LS_LOCAL_FILE}; do
#	echo "XXX : ${XXX}"
#	ARRAY[i]="${XXX}"
#	i=$i+1
#done
#IFS="${IFS_BACKUP}"

#echo "ARRAY : ${ARRAY[4]}"
#LOCAL_SIZE="${ARRAY[4]}"


#echo "URL_SIZE   : ${URL_SIZE}"
#echo "LOCAL_SIZE : ${LOCAL_SIZE}"


#if [ "${URL_SIZE}" == "${LOCAL_SIZE}" ]; then
#	echo "File download complete."
#else
#	>&2 echo "FAILED: File download was not completed."
#	lm_failure
#fi



echo ""
echo "End of script '${CURRENT_SCRIPT}'"

