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
__revision__ = "setup_all.py  v0.0.1 (2018-08-12)"
#__docformat__ = 'reStructuredText'

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

