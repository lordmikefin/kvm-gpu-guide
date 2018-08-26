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
::  https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/setup_all.bat

:: This script will run setup_all.py with virtual environment 'venv-lm-scripts'


SET CURRENT_SCRIPT=setup_all.bat
SET CURRENT_SCRIPT_VER=0.0.3
SET CURRENT_SCRIPT_DATE=2018-08-26
echo CURRENT_SCRIPT_VER: %CURRENT_SCRIPT_VER% (%CURRENT_SCRIPT_DATE%)
echo.

python --version
echo.
if %errorlevel% neq 0 exit /b %errorlevel%





echo.
echo I will try to use virtual environment 'venv-lm-scripts'.
echo All my python scripts will use this environment.
echo.
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\activate.bat
call workon venv-lm-scripts
SET SUCCESS=0
if %errorlevel% neq 0 ( 
	SET SUCCESS=0
	
	echo.
	echo Virtual environment 'venv-lm-scripts' not found.
	echo.
	echo Run 'setup_python_venv.bat' first.
	echo It will initialize every thing for you.
	echo.
	pause
	call exit /b %errorlevel%
	
) else ( 
	SET SUCCESS=1
	echo.
	echo Now workon venv-lm-scripts
	echo.
)




:: http://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html
echo. 
echo Current virtual environment:
echo %VIRTUAL_ENV%
echo. 



echo. 
echo Install all needed Python modules into venv.
echo (venv-lm-scripts) $ pip3 install -U -r requirements.txt
echo.
call pip3 install -U -r requirements.txt
echo.
echo.
if %errorlevel% neq 0 (
	pause
	exit /b %errorlevel%
)


echo. 
echo (venv-lm-scripts) $ pip3 list
echo.
call pip3 list
echo.


echo.
echo Run script setup_all.py
echo.
call python setup_all.py
echo.
if %errorlevel% neq 0 (
	pause
	exit /b %errorlevel%
)


echo.
echo Exit from virtual environment 'venv-lm-scripts'.
echo  $ deactivate
echo.
::deactivate
::call %USERPROFILE%\Envs\venv-lm-scripts\Scripts\deactivate.bat
call deactivate
if %errorlevel% neq 0 (
	pause
	exit /b %errorlevel%
)
echo.


echo End of script %CURRENT_SCRIPT%
::echo Script DONE.
pause
