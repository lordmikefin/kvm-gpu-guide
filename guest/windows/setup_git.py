# -*- coding: UTF-8 -*-
"""
    setup_git.py
    ~~~~~~~~~~~~

    This script will install install and setup 'git'.

    All rights reserved.

    License of this script file:
       BSD 2-Clause License

    License is available online:
       https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst

    Latest version of this script file:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_git.py


    :copyright: (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
    :license: BSD 2-Clause License

"""

# Install git

# TODO: Check if we already have the installer
# \\192.168.122.1\sambashare\windows\Git-2.18.0-64-bit
# By now \\192.168.122.1\sambashare\windows\ should be bind to W: drive

# https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
# TODO: download file from web
# 		Werify downloaded file is what we were downloading.

installer_file = "Git-2.18.0-64-bit"
installer_path = "W:/"

print(str(installer_path) + str(installer_file))




