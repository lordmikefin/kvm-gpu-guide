::C:\Windows\SysWOW64\cmd.exe
@echo off

:: Copyright (c) 2018, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
:: All rights reserved.
:: 
:: License of this script file:
::   BSD 2-Clause License
:: 
:: License is available online:
::   https://github.com/lordmikefin/kvm-gpu-guide/blob/master/LICENSE.rst
:: 
:: Latest version of this script file:
::  https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_python_venv.bat

:: This script will setup Python virtual environment for my scripts :)


SET CURRENT_SCRIPT=setup_python_venv.bat
SET CURRENT_SCRIPT_VER=0.0.6
SET CURRENT_SCRIPT_DATE=2018-08-12
echo CURRENT_SCRIPT_VER: %CURRENT_SCRIPT_VER% (%CURRENT_SCRIPT_DATE%)
echo.

python --version
echo.
if %errorlevel% neq 0 exit /b %errorlevel%


echo Installing root environment (Python) modules.
echo.
call pip install -U -r root_environment_requirements_win.txt
echo.
echo.
if %errorlevel% neq 0 exit /b %errorlevel%


echo List of 'Root' environment modules
echo  $ pip list --format=columns
echo.
call pip list --format=columns
::pip list 
echo.
echo.
if %errorlevel% neq 0 exit /b %errorlevel%


:: TODO: list all virtual environments


echo.
echo I will try to use virtual environment 'venv-lm-scripts'.
echo All my python scripts will use this environment.
echo.
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\activate.bat
call workon venv-lm-scripts
SET SUCCESS=0
if %errorlevel% neq 0 ( 
	SET SUCCESS=0
	
	:: clear the error level
	::cmd /c exit 0
	::call cmd /c "exit /b 0"
	::VERIFY > nul
	::echo errorlevel: %errorlevel%
	echo.
	echo Virtual environment 'venv-lm-scripts' not found.
	echo Next I will create the venv.
	echo.
	pause
	
) else ( 
	SET SUCCESS=1
	echo.
	echo Virtual environment 'venv-lm-scripts' already exists.
	echo Now workon venv-lm-scripts
	echo.
)


:: clear the error level
::(call)
:: (call )
::VERIFY > nul
::set errorlevel=
echo SUCCESS: %SUCCESS%
::echo errorlevel: %errorlevel%
::exit /b 0

if %SUCCESS% neq 1 ( 
	echo errorlevel: %errorlevel%
	echo I will create a new virtual environment 'venv-lm-scripts'
	echo  $ mkvirtualenv --python=C:\Python\Python37\python.exe venv-lm-scripts
	echo.
	
	call mkvirtualenv --python=D:\apps\python\python37\python.exe venv-lm-scripts
	:: Batch will not catch the error within if statement?!?!?! WTF!
	::if %errorlevel% neq 0 ( 
	::	echo errorlevel: %errorlevel%
	::	pause
	::	exit /b %errorlevel%
	::)
)

echo errorlevel: %errorlevel%

:: Handle possible errors from 'call mkvirtualenv...'
if %errorlevel% neq 0 ( 
	echo errorlevel: %errorlevel%
	echo.
	echo Python 3.7 should be installed into D:\apps\python\python37\
	echo https://www.python.org/ftp/python/3.7.0/python-3.7.0-amd64.exe
	echo.
	echo Please run init.bat first. It should install Python in my way.
	echo.
	pause
	call exit /b %errorlevel%
)



:: http://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html
echo. 
echo Current virtual environment:
echo %VIRTUAL_ENV%
echo. 


echo. 
echo (venv-lm-scripts) $ pip3 list --format=columns
echo.
call pip3 list --format=columns
echo.
echo.


echo. 
echo Install all needed Python modules into venv.
echo (venv-lm-scripts) $ pip3 install -U -r requirements.txt
echo.
call pip3 install -U -r requirements.txt
echo.
echo.
if %errorlevel% neq 0 exit /b %errorlevel%

echo.
echo List all outdated modules.
echo (venv-lm-scripts) $ pip3 list -o --format=columns 
echo.
call pip3 list -o --format=columns 
echo.
echo.
if %errorlevel% neq 0 exit /b %errorlevel%


echo.
echo Exit from virtual environment 'venv-lm-scripts'.
echo  $ deactivate
echo.
::deactivate
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\deactivate.bat
call deactivate
if %errorlevel% neq 0 exit /b %errorlevel%
echo.


echo End of script %CURRENT_SCRIPT%
::echo Script DONE.
pause
