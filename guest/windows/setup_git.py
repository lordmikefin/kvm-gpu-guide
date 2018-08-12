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

import os

# Install git

# TODO: Check if we already have the installer
# \\192.168.122.1\sambashare\windows\Git-2.18.0-64-bit
# By now \\192.168.122.1\sambashare\windows\ should be bind to W: drive

# https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
# TODO: download file from web
# 		Werify downloaded file is what we were downloading.

installer_file = "Git-2.18.0-64-bit"
installer_path = "W:/"
installer_file_fullname = str(installer_path) + str(installer_file)

print(str(installer_file_fullname))

print('PATH : ' + str(os.environ.get('PATH')))
# echo %VIRTUAL_ENV%
print('VIRTUAL_ENV : ' + str(os.environ.get('VIRTUAL_ENV')))

# https://stackoverflow.com/questions/14894993/running-windows-shell-commands-with-python

'''
print('Print out from "subprocess"')
from subprocess import check_output
result = check_output("dir C:", shell=True)
print(str(result))
print('')
'''
'''
print('Print out from os.system("dir C:\\")')
import os
os.system('dir C:\\')
print('')
'''

# NOTE: I like to use Notepad++ as default editor.
# TODO: Install Notepad++ first.

# http://www.jrsoftware.org/ishelp/index.php?topic=setupcmdline
# os.system(str(installer_file_fullname) + ' /?')

# /SAVEINF="filename"
#os.system(str(installer_file_fullname) + ' /SAVEINF="git.inf"')
# /LOADINF="filename"
#os.system(str(installer_file_fullname) + ' /LOADINF="git.inf"')
#command = str(str(installer_file_fullname) + ' /VERYSILENT /LOADINF="git.inf"')
command = str(str(installer_file_fullname) + ' /SILENT /LOADINF="git.inf"')
print('Git will not show the installer view!')
print(command)
print('')
print(' Installing ... wait ... wait ... ')
print('')
os.system(command)
print('')
print('Git installation done.')



