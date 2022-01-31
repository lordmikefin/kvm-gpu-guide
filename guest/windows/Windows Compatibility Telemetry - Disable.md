
# Disable Windows Compatibility Telemetry 

Links about Windows task scheduler

  https://docs.microsoft.com/en-us/answers/questions/459823/how-can-i-turn-off-telemetry.html
  
  https://docs.microsoft.com/en-us/troubleshoot/windows-client/system-management-components/use-at-command-to-schedule-tasks
  
  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks
  
  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-query
  
  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-change


## Disable tasks using compattelrunner.exe

```bat
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
```

## Enable tasks using compattelrunner.exe

```bat
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /ENABLE
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /ENABLE
```

## List tasks using compattelrunner.exe

NOTE: Run this in "bash".

Command 'grep' is part of git bash.

  https://git-scm.com/download/win
  

```bash
schtasks //query //fo LIST //v  | grep -B15 -A25 compattelrunner | grep 'TaskName\|State\|Task To Run'
```


