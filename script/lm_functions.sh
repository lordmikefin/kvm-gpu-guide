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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/script/lm_functions.sh



# lm_functions.sh
# This is collectons of shell script functions.

# This script itself does not do anything.
# This script is used as source from other scripts.

# Some functions are using 'subshell' to protect variables.
# We do not want accidentally overwrite data set in caller script.



# Usage:
# ----------------------------------------------------------------------------
#	CURRENT_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[0]})"
#	CURRENT_SCRIPT_DIR="$(dirname ${CURRENT_SCRIPT_REALPATH})"
#	IMPORT_FUNCTIONS="$(realpath "${CURRENT_SCRIPT_DIR}/../../script/lm_functions.sh")"
#	if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
#		>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
#		exit 1
#	fi
#
#	source ${IMPORT_FUNCTIONS}
#
#	if [ ${LM_FUNCTIONS_VER} != "0.0.3" ]; then
#		lm_functions_incorrect_version
#		if [ "${INPUT}" == "FAILED" ]; then
#			lm_failure
#		fi
#	fi
# ----------------------------------------------------------------------------




# Currently this script provides functions:
# :Functions without subshell:
#  - lm_failure_message ()
#  - lm_failure ()
#  - lm_functions_incorrect_version ()
#  - lm_read_to_INPUT ()
#  - lm_check_KVM_WORKSPACE ()
# :Functions with subshell:
#  - lm_verify_argument ()
#  - lm_max_argument ()
#  - lm_string_to_lower_case ()
#  - lm_create_folder_recursive ()





unset LM_FUNCTIONS_VER LM_FUNCTIONS_DATE
LM_FUNCTIONS_VER="0.0.6"
LM_FUNCTIONS_DATE="2017-11-19"
#echo "LM functions version: ${LM_FUNCTIONS_VER} (${LM_FUNCTIONS_DATE})"


unset LM_FUNCTIONS LM_FUNCTIONS_REALPATH LM_FUNCTIONS_DIR LM_FUNCTIONS_WORK_DIR
unset CALLER_SCRIPT_REALPATH
CALLER_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[1]})"
LM_FUNCTIONS_REALPATH="$(realpath ${BASH_SOURCE[0]})"
LM_FUNCTIONS="$(basename ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_DIR="$(dirname ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_WORK_DIR="${PWD}"
#echo ""
#echo "LM_FUNCTIONS: ${LM_FUNCTIONS}"
#echo "LM_FUNCTIONS_REALPATH: ${LM_FUNCTIONS_REALPATH}"
#echo "LM_FUNCTIONS_DIR: ${LM_FUNCTIONS_DIR}"
#echo "LM_FUNCTIONS_WORK_DIR: ${LM_FUNCTIONS_WORK_DIR}"
#echo ""
#echo "CALLER_SCRIPT_REALPATH: ${CALLER_SCRIPT_REALPATH}"



# NOTE to myself: Read more about Bash exit codes.
#   ( http://tldp.org/LDP/abs/html/exitcodes.html )

unset OS_NAME OS_VER OS_ARCH CURRENT_SHELL INCORRECT_VERSION
OS_NAME="$(uname)"
OS_VER="$(uname -r)"
OS_ARCH="$(uname -m)"
if [[ ${OS_NAME} != "Linux" ]] ; then
	>&2 echo -e "\n System is not Linux. This script is tested only with Linux.  Aborting."
	exit 1
fi

CURRENT_SHELL="$(basename $SHELL)"
if [[ ${CURRENT_SHELL} != "bash" ]] ; then
	>&2 echo -e "\n This script is tested only with Bash.  Aborting."
	exit 1
fi


unset INCORRECT_VERSION

# Check Bash version.
INCORRECT_VERSION=false
if [[ "${BASH_VERSINFO[0]}" -lt  4  ]] ; then
	INCORRECT_VERSION=true
else
	if [[ "${BASH_VERSINFO[1]}" -lt  3  ]] ; then
		INCORRECT_VERSION=true
	else
		if [[ "${BASH_VERSINFO[2]}" -lt  46  ]] ; then
			INCORRECT_VERSION=true
		fi
	fi
fi

#echo "INCORRECT_VERSION : ${INCORRECT_VERSION}"
if [ "${INCORRECT_VERSION}" == true ] ; then
	>&2 echo -e "\n This script is tested only with Bash version 4.3.46 (or higher).  Aborting."
	exit 1
fi







lm_failure_message () {
	
	# Usage:
	#	lm_failure_message
	
	# Secondary usage:
	#	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "${MESSAGE}"
	
	# NOTE: Parameters must be in order. Each are optional.
	
	ARG_BASH_SOURCE="${BASH_SOURCE[1]}"
	if [ -n "$1" ]; then
		ARG_BASH_SOURCE="$1"
	fi
	
	ARG_BASH_LINENO="${BASH_LINENO[0]}"
	if [ -n "$2" ]; then
		ARG_BASH_LINENO="$2"
	fi
	
	ARG_MESSAGE="Script  FAILED"
	if [ -n "$3" ]; then
		ARG_MESSAGE="$3"
	fi
	
	>&2 echo "${ARG_BASH_SOURCE}: line ${ARG_BASH_LINENO}: ${ARG_MESSAGE}"
}

lm_failure () {
	# Will exit the caller script with error 1.
	# Prints error with caller script name and row number.
	
	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}"
	
	exit 1
}



lm_functions_incorrect_version () {
	
	>&2 echo ""
	lm_failure_message "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "Source script '${LM_FUNCTIONS}' is incorrect version!" # echo into stderr
	>&2 echo ""
	
	echo ""
	echo "Something has changed in ${LM_FUNCTIONS}."
	echo "Everything might not run correctly."
	echo ""
	
	unset INPUT
	lm_read_to_INPUT "Do you want to run this script as is?"
	
	case "${INPUT}" in
		"YES" )
			echo "OK then. Let's run and see what happens." ;;
		"NO" )
			echo "OK then. bye."
			exit 1 ;;
		"FAILED" | * )
			lm_failure_message ;;
	esac
}

lm_read_to_INPUT () {
	# Read input from user until we get acceptable answer.
	
	# WARNING: 
	#   This fuction will over write variables INPUT and STRING_LOW_CASE !!!
	
	# Usage:
	#	unset INPUT
	#	lm_read_to_INPUT "Do you wanna do something?"
	#	case "${INPUT}" in
	#		"YES" )
	#			INPUT="YES" ;;
	#		"NO" )
	#			INPUT="NO" ;;
	#		"FAILED" | * )
	#			lm_failure_message
	#			INPUT="FAILED" ;;
	#	esac
	
	unset INPUT
	while [[ -z ${INPUT} ]]; do
		echo -n "$1 ( Yes / [No] ): "
		read INPUT
		
		STRING_LOW_CASE="$(lm_string_to_lower_case "${INPUT}")"  || { STRING_LOW_CASE="FAILED";  lm_failure_message; }
		
		case "${STRING_LOW_CASE}" in
			"yes" | "ye" | "y" )
				INPUT="YES" ;;
			"no" | "n" | "" )
				INPUT="NO" ;;
			"FAILED" )
				INPUT="FAILED" ;;
			* )
				unset INPUT ;; # Clear input ( = stay in while loop )
		esac
	done
}

lm_check_KVM_WORKSPACE () {
	# Check if KVM_WORKSPACE variable is set.
	# If it is not, then ask what user wants to do.
	
	# Usage:
	#	unset KVM_WORKSPACE_DEFAULT
	#	lm_check_KVM_WORKSPACE
	
	if [[ -z "${KVM_WORKSPACE}" ]] ; then
		KVM_WORKSPACE_DEFAULT="${HOME}/kvm-workspace"
		
		echo ""
		echo "Variable 'KVM_WORKSPACE' is not set."
		echo "  I will use the default path: ${KVM_WORKSPACE_DEFAULT}"
		echo ""
		
		unset INPUT
		lm_read_to_INPUT "Do you want to use defalut path?"
		if [ "${INPUT}" == "YES" ]; then
			KVM_WORKSPACE="${KVM_WORKSPACE_DEFAULT}"
		fi
	fi
	
	if [[ -z "${KVM_WORKSPACE}" ]] ; then
		>&2 echo -e "\n Variable 'KVM_WORKSPACE' not set.  Aborting."
		exit 1
	fi
}



######################################################################
#                                                                    #
#  Following functions are using 'subshell' to protect variables.    #
#  We do not want accidentally overwrite data set in caller script.  #
#                                                                    #
######################################################################

lm_verify_argument () {
	# Verify the argument.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   STRING="$(lm_verify_argument "${1}")"  || lm_failure
	
	( # subshell
		STRING="$1"
		
		if [ "${STRING}" == "" ]; then
			>&2 echo "Argument can not be empty."
			exit 1
		fi
		
		echo "${STRING}"
	)
}

lm_max_argument () {
	# Verify that the there is no more arguments than max.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   lm_max_argument "${1}"  || lm_failure
	
	( # subshell
		STRING="$1"
		
		if [ "${STRING}" != "" ]; then
			>&2 echo "Too many argument has been set."
			exit 1
		fi
	)
}

lm_string_to_lower_case () {
	# Create given folder. Recursively.
	
	# NOTE: Do not echo enything into stdout! All stdout echoes are used as return value.
	
	# Usage:
	#   STRING_LOW_CASE="$(lm_string_to_lower_case "${STRING}")"  || lm_failure
	
	( # subshell
		
		#STRING="$(lm_verify_argument "${1}")"  || lm_failure
		STRING="${1}"
		
		lm_max_argument "${2}"  || lm_failure
		
		#$(echo "${STRING,,}")  || lm_failure
		#echo "${STRING,,} ${foo&#}"  || lm_failure
		
		echo "${STRING,,}"
		#exit 1
	)
}

lm_create_folder_recursive () {
	# Create given folder. Recursively.
	
	# Usage:
	#   lm_create_folder_recursive "${HOME}/kvm-workspace/iso"  || lm_failure
	
	( # subshell
		PATH_FOLDER="$(lm_verify_argument "${1}")"  || lm_failure
		
		lm_max_argument "${2}"  || lm_failure
		
		if [ ! -d "${PATH_FOLDER}" ]; then
			echo ""
			echo "Directory '${PATH_FOLDER}' does not exist."
			
			unset INPUT
			lm_read_to_INPUT "Do you want to create the folder?"
			case "${INPUT}" in
				"YES" )
					# No error if existing, make parent directories as needed.
					mkdir -p "${PATH_FOLDER}"  || lm_failure
					echo "Directory '${PATH_FOLDER}' and parents are created."
					INPUT="YES" ;;
				"NO" )
					echo "Folder not created."
					exit 1 ;;
				"FAILED" | * )
					lm_failure ;;
			esac
		fi
	)
}




#echo ""
#echo "Functions loaded from: '${LM_FUNCTIONS}'"
#echo ""

