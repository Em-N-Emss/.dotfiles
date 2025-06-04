@echo off
cd /d "%UserProfile%\.config\kanata"

echo Stopping kanata and kanawin...

:: Kill the processes silently
taskkill /f /im kanata.exe >nul 2>&1
taskkill /f /im kanawin.exe >nul 2>&1

:: Delete log files
del /f /q kanata.log >nul 2>&1
del /f /q kanawin.log >nul 2>&1

echo Done.
