@echo off
SET FOLDER=%1

echo [INFO] Đang xóa thư mục: %FOLDER%

:: Thử xóa nhanh trước
RD /S /Q "%FOLDER%" 2>nul
IF NOT EXIST "%FOLDER%" (
    echo ✅ Đã xóa thành công thư mục ngay lần đầu.
    exit /b 0
)

:: Nếu chưa xóa được, chiếm quyền và thử lại
echo [INFO] Chiếm quyền thư mục để xóa lại...
takeown /F "%FOLDER%" /R /D Y >nul 2>&1
icacls "%FOLDER%" /grant Administrators:F /T /C /Q >nul 2>&1

echo [INFO] Đang xóa lại thư mục sau khi chiếm quyền...
RD /S /Q "%FOLDER%" 2>nul

:: Kiểm tra lần cuối
IF EXIST "%FOLDER%" (
    echo ❌ Không thể xóa hoàn toàn thư mục %FOLDER%
    exit /b 1
) ELSE (
    echo DONE > C:\Users\Public\delete_done.txt
    echo 🏁 Đã tạo file marker báo hiệu hoàn thành!
    exit /b 0
)
