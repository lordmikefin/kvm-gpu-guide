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
#	IMPORT_FUNCTIONS="$(dirname $(realpath ${BASH_SOURCE[0]}))/../../script/lm_functions.sh"
#	if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
#		>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!" # echo into stderr 
#		exit 1
#	fi
#
#	source ${IMPORT_FUNCTIONS}
#
#	if [ ${LM_FUNCTIONS_VER} != "1.2.3" ]; then
#		lm_functions_incorrect_version
#	fi
# ----------------------------------------------------------------------------



# Currently this script provides functions:
# :Functions without subshell:
#  - lm_functions_incorrect_version ()
#  - lm_read_to_INPUT ()
#  - lm_check_KVM_WORKSPACE ()
# :Functions with subshell:
#  - 



unset LM_FUNCTIONS_VER LM_FUNCTIONS_DATE
LM_FUNCTIONS_VER="0.0.3"
LM_FUNCTIONS_DATE="2017-11-12"
echo "LM functions version: ${LM_FUNCTIONS_VER} (${LM_FUNCTIONS_DATE})"


unset LM_FUNCTIONS LM_FUNCTIONS_REALPATH LM_FUNCTIONS_DIR LM_FUNCTIONS_WORK_DIR
unset CALLER_SCRIPT_REALPATH
CALLER_SCRIPT_REALPATH="$(realpath ${BASH_SOURCE[1]})"
LM_FUNCTIONS_REALPATH="$(realpath ${BASH_SOURCE[0]})"
LM_FUNCTIONS="$(basename ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_DIR="$(dirname ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_WORK_DIR="${PWD}"
echo ""
echo "LM_FUNCTIONS: ${LM_FUNCTIONS}"
echo "LM_FUNCTIONS_REALPATH: ${LM_FUNCTIONS_REALPATH}"
echo "LM_FUNCTIONS_DIR: ${LM_FUNCTIONS_DIR}"
echo "LM_FUNCTIONS_WORK_DIR: ${LM_FUNCTIONS_WORK_DIR}"
echo ""
echo "CALLER_SCRIPT_REALPATH: ${CALLER_SCRIPT_REALPATH}"




lm_functions_incorrect_version () {
	>&2 echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: Source script '${LM_FUNCTIONS}' is incorrect version!" # echo into stderr
	echo ""
	echo "Something has changed in ${LM_FUNCTIONS}."
	echo "Everything might not run correctly."
	echo ""
	
	unset INPUT
	lm_read_to_INPUT "Do you want to run this script as is?"
	if [ "${INPUT}" == "YES" ]; then
		echo "OK then. Let's run and see what happens."
	else
		echo "OK then. bye."
		exit 1
	fi
}

lm_read_to_INPUT () {
	# Read input from user until we get acceptable answer.
	
	# WARNING: This fuction will over write variable INPUT !!!
	
	# Usage:
	#	unset INPUT
	#   lm_read_to_INPUT "Do you wanna do something?"
	#	if [ "${INPUT}" == "YES" ]; then
	#		do_something_function
	#	else
	#		echo "NO ..."
	#	fi
	
	unset INPUT
	while [[ -z ${INPUT} ]]; do
		echo -n "$1 ( Yes / [No] ): "
		read INPUT
		
		case "${INPUT}" in
			Yes | YES | yes | y )
				INPUT="YES" ;;
			No | NO | no | n | "" )
				INPUT="NO" ;;
			* )
				unset INPUT ;; # Clear input ( = stay in while loop )
		esac
	done
}

lm_check_KVM_WORKSPACE () {
	# Check if KVM_WORKSPACE variable is set.
	# If it is not, then ask what user wants to do.
	
	# Usage:
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





echo ""
#echo "End of script '${CURRENT_SCRIPT}'"
echo "Functions loaded from: '${LM_FUNCTIONS}'"

