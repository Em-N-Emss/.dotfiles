@echo off
cd /d "%UserProfile%\.config\kanata"

:: Create a temporary VBS file on the fly
set "vbsfile=%temp%\kanata_launcher.vbs"

> "%vbsfile%" echo Set WshShell = CreateObject("WScript.Shell")
>> "%vbsfile%" echo WshShell.Run "cmd /c kanata.exe -p 1028 --cfg dvorak_vim_motions.kbd > kanata.log 2^>^&1", 0, False
>> "%vbsfile%" echo WshShell.Run "cmd /c kanawin.exe -p 1028 -c kanawin.yaml > kanawin.log 2^>^&1", 0, False

:: Run the temporary VBS file silently
wscript.exe "%vbsfile%"

:: Delete the temporary file
del "%vbsfile%" >nul 2>&1
exit /b
