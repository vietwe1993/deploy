@echo off
SET FOLDER=%1

:: Hiển thị thư mục cần xóa
echo Đang xóa thư mục: %FOLDER%

:: Thử xóa nhanh trước
RD /S /Q "%FOLDER%"

:: Nếu còn tồn tại, chiếm quyền và thử lại
IF EXIST "%FOLDER%" (
    echo [INFO] Chiếm quyền thư mục...
    takeown /F "%FOLDER%" /R /D Y >nul 2>&1
    icacls "%FOLDER%" /grant Administrators:F /T /C /Q >nul 2>&1

    echo [INFO] Đang xóa lần cuối...
    RD /S /Q "%FOLDER%"
)

:: Kiểm tra lần cuối
IF EXIST "%FOLDER%" (
    echo ❌ Không thể xóa thư mục %FOLDER%
) ELSE (
    echo ✅ Đã xóa thành công %FOLDER%
)

:: Tạo file marker báo hiệu đã hoàn tất
echo DONE > C:\Users\Public\delete_done.txt
