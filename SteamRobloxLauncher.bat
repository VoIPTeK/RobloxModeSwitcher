@echo off
setlocal

set PS64=%WINDIR%\Sysnative\WindowsPowerShell\v1.0\powershell.exe

if exist "%PS64%" (
    "%PS64%" -ExecutionPolicy Bypass -File "C:\RobloxModeSwitcher\RobloxPCmodesSteam.ps1"
) else (
    powershell.exe -ExecutionPolicy Bypass -File "C:\RobloxModeSwitcher\RobloxPCmodesSteam.ps1"
)

echo.
echo [ModeSwitcher] Closing in 3 seconds... (press Y to keep this window open)

choice /C YN /D N /T 3 /N >nul

if errorlevel 2 (
    goto :eof
)

echo.
echo [ModeSwitcher] Keeping window open. Press any key to close...
pause >nul

endlocal
