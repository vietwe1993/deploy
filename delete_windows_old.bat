@echo off
SET FOLDER=%~1

:: Xóa lần đầu
RD /S /Q "%FOLDER%"

:: Nếu còn tồn tại thì chiếm quyền và xóa lại
IF EXIST "%FOLDER%" (
    takeown /F "%FOLDER%" /R /D Y
    icacls "%FOLDER%" /grant Administrators:F /T
    RD /S /Q "%FOLDER%"
)

exit /b 0
echo DONE > C:\Users\Public\delete_done.txt
echo 🏁 Đã tạo file marker báo hiệu hoàn thành!
