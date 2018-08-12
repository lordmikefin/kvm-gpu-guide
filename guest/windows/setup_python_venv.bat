::C:\Windows\SysWOW64\cmd.exe
@echo off

:: Copyright (c) 2017, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
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


SET CURRENT_SCRIPT_VER=0.0.1
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

echo I will try to use virtual environment 'venv-lm-scripts'.
echo All my python scripts will use this environment.
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\activate.bat
call workon venv-lm-scripts
if %errorlevel% neq 0 ( 
	pause
	::if %errorlevel% neq 0 ( echo "Still error" )
	::cmd /c "exit /b 0"
	::if %errorlevel% neq 0 ( echo "Still error" )
	echo.
	echo.
	echo I will create a new virtual environment 'venv-lm-scripts'
	::echo "Press enter to contitue."
	echo.
	pause
	echo.
	call mkvirtualenv --python=C:\Python\Python34\python.exe venv-lm-scripts
	echo.
	
	echo Python 3.7 should be installed into C:\Python\Python34\
	echo https://www.python.org/ftp/python/3.4.4/python-3.4.4.amd64.msi
	echo.
	echo Run this script again.
	call deactivate
	exit /b 0
	
	:: NOTE(Mikko): I can not clear the %errorlevel%
	::              No matter what 'mkvirtualenv' returns code is still in error mode ???
	pause
	echo.
	if %errorlevel% neq 0 ( 
		::echo "This script will now exit. Just becaus. TODO: fix this."
		echo Python 3.4 should be installed into C:\Python\Python34\
		echo https://www.python.org/ftp/python/3.4.4/python-3.4.4.amd64.msi
		exit /b %errorlevel% 
	) else (  
		call workon venv-lm-scripts
		if %errorlevel% neq 0 ( 
			exit /b %errorlevel% 
		) else ( 
			echo Now workon venv-lm-scripts
		)
	)
	echo.
	pause
	
) else ( 
	echo Now workon venv-lm-scripts
)


echo Exit from virtual environment 'venv-lm-scripts'.
echo  $ deactivate
echo.
::deactivate
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\deactivate.bat
call deactivate
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

pause
