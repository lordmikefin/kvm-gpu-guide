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
#   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/script/...


# NOTE: If you are running bash script as sudoer, then all environment variables
#       are not preserved. Use sudo flag '-E, --preserve-env'.
# 
#   $ sudo -E ./script/test.sh"

echo "KVM_WORKSPACE: ${KVM_WORKSPACE}"

if [[ -z "${KVM_WORKSPACE}" ]] ; then
	echo ""
	echo "KVM_WORKSPACE:  Is not set ! "
fi
