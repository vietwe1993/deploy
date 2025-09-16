@echo off
setlocal EnableDelayedExpansion
set "TARGET_DIR=C:\Users\Public"
set "EXE=monitorUrlnew.exe"
set "LOG=C:\Users\Public\monitorUrl_task.log"

cd /d "%TARGET_DIR%"
echo [!date! !time!] START wrapper >> "%LOG%"

for /l %%i in (1,1,5) do (
  if exist "%EXE%" (
    start "" /b "%EXE%" >> "%LOG%" 2>>&1
    timeout /t 2 >nul
    tasklist /fi "imagename eq %EXE%" | find /i "%EXE%" >nul && (
      echo [!date! !time!] RUNNING ok >> "%LOG%"
      exit /b 0
    )
  )
  echo [!date! !time!] RETRY %%i >> "%LOG%"
  timeout /t 5 >nul
)

echo [!date! !time!] FAIL start >> "%LOG%"
exit /b 1
