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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/...



# lm_functions.sh
# This is collectons of shell script functions.

# This script itself does not do anything.
# This script is used as source from other scripts.

# Some functions are using 'subshell' to protect variables.
# We do not want accidentally overwrite data set in caller script.



unset LM_FUNCTIONS_VER LM_FUNCTIONS_DATE
LM_FUNCTIONS_VER="0.0.1"
LM_FUNCTIONS_DATE="2017-11-12"
echo "LM functions version: ${LM_FUNCTIONS_VER} (${LM_FUNCTIONS_DATE})"

LM_FUNCTIONS_RALATIVE_PATH="${BASH_SOURCE[0]}"
echo ""
echo "LM_FUNCTIONS_RALATIVE_PATH : ${LM_FUNCTIONS_RALATIVE_PATH}"
echo "BASH_SOURCE[0] : ${BASH_SOURCE[0]}"
echo "BASH_SOURCE[1] : ${BASH_SOURCE[1]}"

unset LM_FUNCTIONS LM_FUNCTIONS_REALPATH LM_FUNCTIONS_DIR LM_FUNCTIONS_WORK_DIR
#CURRENT_SCRIPT_REALPATH="$(realpath ${0})"
LM_FUNCTIONS_REALPATH="$(realpath ${BASH_SOURCE[0]})"
#LM_FUNCTIONS_REALPATH="$(realpath ${LM_FUNCTIONS_RALATIVE_PATH})"
LM_FUNCTIONS="$(basename ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_DIR="$(dirname ${LM_FUNCTIONS_REALPATH})"
LM_FUNCTIONS_WORK_DIR="${PWD}"
echo ""
echo "LM_FUNCTIONS: ${LM_FUNCTIONS}"
echo "LM_FUNCTIONS_REALPATH: ${LM_FUNCTIONS_REALPATH}"
echo "LM_FUNCTIONS_DIR: ${LM_FUNCTIONS_DIR}"
echo "LM_FUNCTIONS_WORK_DIR: ${LM_FUNCTIONS_WORK_DIR}"





