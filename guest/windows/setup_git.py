# -*- coding: UTF-8 -*-
"""
    setup_git.py
    ~~~~~~~~~~~~

    This script will install and setup 'git'.

    All rights reserved.

    License of this script file:
       BSD 2-Clause License

    License is available online:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst

    Latest version of this script file:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_git.py


    :copyright: (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
    :license: BSD 2-Clause License

    :todo: Verity that folder D:\apps\ exists
    :todo: Install Notepad++ first.
"""

# https://thomas-cokelaer.info/tutorials/sphinx/docstring_python.html
# http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
__license__ = "BSD 2-Clause License"
#__revision__ = " $Id: actor.py 1586 2009-01-30 15:56:25Z cokelaer $ "
__version__ = "0.0.8"
__revision__ = "setup_git.py  v" + __version__ + " (2018-08-26)"
#__docformat__ = 'reStructuredText'

import os
import sys

# https://stackoverflow.com/questions/7791574/how-can-i-print-a-python-files-docstring-when-executing-it




def is_installed_git():
    command = 'git --version'
    res = int(os.system(command))
    if res > 0:
        print('Git NOT installed.')
        return False

    print('Git already installed.')
    return True


def install_git():
    # Install git

    # TODO: Check if we already have the installer
    # \\192.168.122.1\sambashare\windows\Git-2.18.0-64-bit
    # By now \\192.168.122.1\sambashare\windows\ should be bind to W: drive

    # https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
    # TODO: download file from web
    #         Werify downloaded file is what we were downloading.

    installer_file = "Git-2.18.0-64-bit"
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

    # NOTE: I like to use Notepad++ as default editor.
    # TODO: Install Notepad++ first.

    # http://www.jrsoftware.org/ishelp/index.php?topic=setupcmdline
    # os.system(str(installer_file_fullname) + ' /?')



    # /SAVEINF="filename"
    #os.system(str(installer_file_fullname) + ' /SAVEINF="git.inf"')
    # /LOADINF="filename"
    #os.system(str(installer_file_fullname) + ' /LOADINF="git.inf"')
    #command = str(str(installer_file_fullname) + ' /VERYSILENT /LOADINF="git.inf"')
    command = str(str(installer_file_fullname) + ' /SILENT /LOADINF="git.inf" /LOG="git.log"')
    print('Git will not show the installer view!')
    print(command)
    print('')
    print(' Installing ... wait ... wait ... ')
    print('')
    res = int(os.system(command))
    print('')
    if res > 0:
        print('Git installation FAILED.')
        sys.exit(1)
    else:
        print('Git installation done.')

    '''
    #exit(res)
    print('os.environ.get("RESULT") : ' + str(os.environ.get("RESULT")))
    #return res
    print('res : ' + str(res))
    os.environ['RESULT'] = str(res)
    print('os.environ.get("RESULT") : ' + str(os.environ.get("RESULT")))
    '''
    

if __name__ == '__main__':
    #print('main')
    #print(__doc__)
    print(__license__)
    print(__revision__)
    print(__version__)
    #print(__docformat__)
    #import doctest
    #print(str(doctest.testmod()))

    from argparse import ArgumentParser
    parser = ArgumentParser(description=__doc__)
    # Add your arguments here
    '''
    parser.add_argument("-f", "--file", dest="myFilenameVariable",
                        required=True,
                        help="write report to FILE", metavar="FILE")
    '''
    args = parser.parse_args()
    #print(args.myFilenameVariable)
    
    if not is_installed_git():
        install_git()
        # return True
    
    # return False

    # https://stackoverflow.com/questions/3815860/python-how-to-exit-main-function
