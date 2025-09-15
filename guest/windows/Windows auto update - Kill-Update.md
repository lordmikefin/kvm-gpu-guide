
# Use Kill-Update app to kill Windows auto update and auto boot.


Thanks to David Le Bansais for creating the app.

  https://kill-update.en.softonic.com/
  
  https://github.com/dlebansais/Kill-Update



NOTE: Setting Windows update to not auto install with registery settings did not work :(

  https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/Windows%20auto%20update%20-%20notify%20only.reg


## Install Kill-Update

NOTE: Run Command Prompt As Administrator

  https://www.isunshare.com/windows-10/2-ways-to-run-command-prompt-as-administrator-in-win-10.html

```bat
C:

mkdir "C:\Program Files\Kill-Update"
cd "C:\Program Files\Kill-Update"

PowerShell -Command "& {$client = new-object System.Net.WebClient; $client.DownloadFile('https://github.com/dlebansais/Kill-Update/releases/download/v1.1.2/Kill-Update.exe','.\Kill-Update.exe')}"

Kill-Update.exe
```


## Create startup link for the Kill-Update

NOTE: For some reason Kill-Update does not always start at startup.

Maybe there is something wrong with 'Load at startup' feature. I do not know :(

You can make sure Kill-Update starts after login by creating link into directory:
  %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\

Here is script which will create the link for you:

NOTE: Run Command Prompt As Administrator

```bat
:: Full path of Kill-Update executable
set KILL_UPDATE_EXE=C:\Program Files\Kill-Update\Kill-Update.exe
:: PowerShell will be used to create the link
set PWS_EXE=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
:: This is the link file full path
set LINK_FILE=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Kill-Update.lnk

:: Run command to create the link file

%PWS_EXE% -Command $ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%LINK_FILE%'); $s.TargetPath = '%KILL_UPDATE_EXE%'; $s.Save(); 

:: Now make this new link file to run as administrator
:: https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell
:: "In short, you need to read the .lnk file in as an array of bytes. Locate byte 21 (0x15) and change bit 6 (0x20) to 1. This is the RunAsAdministrator flag. Then you write you byte array back into the .lnk file."

%PWS_EXE% -Command $bytes = [System.IO.File]::ReadAllBytes('%LINK_FILE%'); $bytes[0x15] = $bytes[0x15] -bor 0x20; [System.IO.File]::WriteAllBytes('%LINK_FILE%', $bytes); 
```

