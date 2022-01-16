
# Use Kill-Update app to kill Windows auto update and auto boot.


Thanks to David Le Bansais for creating the app.

  https://kill-update.en.softonic.com/
  
  https://github.com/dlebansais/Kill-Update



NOTE: Setting Windows update to not auto install with registery settings did not work :(

  https://github.com/lordmikefin/kvm-gpu-guide/blob/master/guest/windows/Windows%20auto%20update%20-%20notify%20only.reg


## Install Kill-Update

NOTE: Run Command Prompt As Administrator

  https://www.isunshare.com/windows-10/2-ways-to-run-command-prompt-as-administrator-in-win-10.html

.. code-block:: batch

 C:
 
 mkdir "C:\Program Files\Kill-Update"
 cd "C:\Program Files\Kill-Update"
 
 PowerShell -Command "& {$client = new-object System.Net.WebClient; $client.DownloadFile('https://github.com/dlebansais/Kill-Update/releases/download/v1.1.0/Kill-Update.exe','.\Kill-Update.exe')}"

 Kill-Update.exe


