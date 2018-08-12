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
::  https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/init.bat

:: This script will install software for my other scripts :)

SET CURRENT_SCRIPT_VER=0.0.2
SET CURRENT_SCRIPT_DATE=2018-08-12
echo CURRENT_SCRIPT_VER: %CURRENT_SCRIPT_VER% (%CURRENT_SCRIPT_DATE%)


:: I assume that you have files in network folder: \\192.168.122.1\sambashare\windows\

:: TODO: Get path from parameter and/or environment variable.

:: https://docs.python.org/3.7/using/windows.html
:: https://docs.python.org/3.7/using/windows.html#installing-without-ui

:: file://192.168.122.1/sambashare/windows/
::CALL explorer \\192.168.122.1\sambashare\windows\
::CALL explorer \\192.168.122.1\sambashare\windows\python-3.7.0a2.exe
::CALL explorer \\192.168.122.1\sambashare\windows\python-3.7.0a2.exe /?
::explorer "\\192.168.122.1\sambashare\windows\python-3.7.0a2.exe /?"


:: https://www.howtogeek.com/118452/how-to-map-network-drives-from-the-command-prompt-in-windows/


echo.
echo Connection network share into drive W:
echo.
::net use W: \\192.168.122.1\sambashare\windows  /persistent:Yes
net use W: \\192.168.122.1\sambashare\windows
W:



echo.
echo I'm installing python into D:\apps\python\python37\
echo This path is added into environment variable PATH
echo.
::CALL python-3.7.0a2.exe /?
::python-3.7.0a2.exe /?

::     python-3.7.0-amd64 InstallAllUsers=1 TargetDir=D:\apps\python\python37\ PrependPath=1
::     python-3.7.0-amd64 InstallAllUsers=1 TargetDir=D:\apps\python\python37\ PrependPath=1 SimpleInstall=1 SimpleInstallDescription="I'm installing python into D:\apps\python\python37\   -- Lord Mike"
python-3.7.0-amd64 /quiet InstallAllUsers=1 TargetDir=D:\apps\python\python37\ PrependPath=1

:: I assume this script is runned from D: driverquery

:: TODO: Check the work folder at begin of this script.
D:



