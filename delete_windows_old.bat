@echo off
chcp 65001 >nul  & REM Chuyển sang UTF-8 để hỗ trợ hiển thị tốt hơn

SET "FOLDER=%~1"

:: Kiểm tra tham số đầu vào
IF "%FOLDER%"=="" (
    echo ❌ Lỗi: Không nhận được thư mục để xóa!
    exit /b 1
)

echo 🔍 Đang kiểm tra thư mục: %FOLDER%
IF NOT EXIST "%FOLDER%" (
    echo ✅ Thư mục không tồn tại, không cần xóa.
    exit /b 0
)

:: Thử xóa nhanh trước
echo 🗑️ Đang xóa thư mục: %FOLDER% (Lần 1)
RD /S /Q "%FOLDER%"
timeout /t 2 >nul

:: Nếu còn tồn tại, chiếm quyền và thử lại
IF EXIST "%FOLDER%" (
    echo 🛑 [INFO] Không thể xóa ngay, cần chiếm quyền...
    takeown /F "%FOLDER%" /R /D Y
    icacls "%FOLDER%" /grant Administrators:F /T /C /Q
    echo 🔄 Đang thử xóa lại lần cuối...
    RD /S /Q "%FOLDER%"
    timeout /t 2 >nul
)

:: Kiểm tra lần cuối
IF EXIST "%FOLDER%" (
    echo ❌ Không thể xóa thư mục %FOLDER%
    exit /b 1
) ELSE (
    echo ✅ Đã xóa thành công %FOLDER%
)

:: Tạo file marker báo hiệu đã hoàn tất
echo DONE > C:\Users\Public\delete_done.txt
echo 🏁 Đã tạo file marker báo hiệu hoàn thành!
