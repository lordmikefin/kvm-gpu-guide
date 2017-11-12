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





