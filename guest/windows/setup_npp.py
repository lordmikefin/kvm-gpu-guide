# -*- coding: UTF-8 -*-
"""
    setup_git.py
    ~~~~~~~~~~~~

    This script will install and setup 'notepad++'.

    All rights reserved.

    License of this script file:
       BSD 2-Clause License

    License is available online:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst

    Latest version of this script file:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_npp.py


    :copyright: (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
    :license: BSD 2-Clause License

    :todo: Verity that folder D:\apps\ exists
"""

# https://thomas-cokelaer.info/tutorials/sphinx/docstring_python.html
# http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
__license__ = "BSD 2-Clause License"
__version__ = "0.0.1"
__revision__ = "setup_npp.py  v" + __version__ + " (2018-08-26)"

import os

# https://stackoverflow.com/questions/7791574/how-can-i-print-a-python-files-docstring-when-executing-it

if __name__ == '__main__':
    print(__license__)
    print(__revision__)
    print(__version__)

    from argparse import ArgumentParser
    parser = ArgumentParser(description=__doc__)
    # Add your arguments here
    '''
    parser.add_argument("-f", "--file", dest="myFilenameVariable",
                        required=True,
                        help="write report to FILE", metavar="FILE")
    '''
    args = parser.parse_args()



# Install notepad++

# TODO: Check if we already have the installer
# \\192.168.122.1\sambashare\windows\Git-2.18.0-64-bit
# By now \\192.168.122.1\sambashare\windows\ should be bind to W: drive

# https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
# TODO: download file from web
#         Werify downloaded file is what we were downloading.

installer_file = "npp.7.5.8.Installer.x64"
installer_path = "W:/"
installer_file_fullname = str(installer_path) + str(installer_file)

print(str(installer_file_fullname))

#print('PATH : ' + str(os.environ.get('PATH')))
# echo %VIRTUAL_ENV%
print('VIRTUAL_ENV : ' + str(os.environ.get('VIRTUAL_ENV')))
print('')


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

# NOTE: This script assumes that folder D:\apps\ exists
# TODO: Verity that folder D:\apps\ exists

# https://notepad-plus-plus.org/download
# TODO: download file from web
#         Werify downloaded file is what we were downloading.


# https://stackoverflow.com/questions/42792305/trying-to-set-up-a-deployment-package-for-silent-uninstall-of-notepad-and-inst#
# https://www.itninja.com/software/open-source-1/notepad-2/5-1399


command = str(str(installer_file_fullname) + ' /S /D=D:\apps\Notepad++ ')
print('Start notepad++ installer.')
print(command)
print('')
print(' Installing ... wait ... wait ... ')
print('')
res = int(os.system(command))
print('')
if res > 0:
    print('notepad++ installation FAILED.')
else:
    print('notepad++ installation done.')

#exit(res)
print('os.environ.get("RESULT") : ' + str(os.environ.get("RESULT")))
#return res
print('res : ' + str(res))
os.environ['RESULT'] = str(res)
print('os.environ.get("RESULT") : ' + str(os.environ.get("RESULT")))

