# -*- coding: UTF-8 -*-
"""
    setup_all.py
    ~~~~~~~~~~~~

    This script will install all apps.

    All rights reserved.

    License of this script file:
       BSD 2-Clause License

    License is available online:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst

    Latest version of this script file:
      https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_all.py


    :copyright: (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
    :license: BSD 2-Clause License

"""

# https://thomas-cokelaer.info/tutorials/sphinx/docstring_python.html
# http://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html
__license__ = "BSD 2-Clause License"
#__revision__ = " $Id: actor.py 1586 2009-01-30 15:56:25Z cokelaer $ "
__revision__ = "setup_all.py  v0.0.2 (2018-08-12)"
#__docformat__ = 'reStructuredText'

import sys
import os

# https://stackoverflow.com/questions/7791574/how-can-i-print-a-python-files-docstring-when-executing-it

if __name__ == '__main__':
    #print('main')
    #print(__doc__)
    print(__license__)
    print(__revision__)
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


#print('PATH : ' + str(os.environ.get('PATH')))
# echo %VIRTUAL_ENV%
print('VIRTUAL_ENV : ' + str(os.environ.get('VIRTUAL_ENV')))
print('')


print('Python version: ' + str(sys.version))
print('')
print('sys.prefix : ' + str(sys.prefix))
print('')

# http://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html
#os.system('lsvirtualenv')

#https://docs.python.org/3/tutorial/venv.html
#py_home = '/var/www/venv-lm-scripts/env'
#activate_this = py_home + '/bin/activate_this.py'
py_home = 'C:/Users/lordmike/Envs/venv-lm-scripts'
activate_this = py_home + '/Scripts/activate_this.py'

with open(activate_this) as file_:
    exec(file_.read(), dict(__file__=activate_this))

print('VIRTUAL_ENV : ' + str(os.environ.get('VIRTUAL_ENV')))
print('')
print('Python version: ' + str(sys.version))
print('')
print('sys.prefix : ' + str(sys.prefix))
print('')

# https://stackoverflow.com/questions/14894993/running-windows-shell-commands-with-python

os.system('cmd /c "workon venv-lm-scripts && python --version && echo %VIRTUAL_ENV%"')
os.system('cmd /c "python --version && echo %VIRTUAL_ENV%"')
#os.system('python --version')
#os.system('dir')
#os.system('cd .. && dir')

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

print('')
print(' Executing setup_git.py')
print('')
#python setup_git.py
exec(open("./setup_git.py").read())

