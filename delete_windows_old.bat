@echo off
setlocal enabledelayedexpansion

echo [INFO] Đang kiểm tra và xóa tất cả thư mục Windows.old*

:: Lặp qua tất cả thư mục trong C:\ có tên bắt đầu bằng "Windows.old"
for /d %%F in (C:\Windows.old*) do (
    echo [INFO] Đang xử lý thư mục: "%%F"

    :: Thử xóa nhanh trước
    RD /S /Q "%%F" 2>nul
    IF NOT EXIST "%%F" (
        echo ✅ Đã xóa thành công thư mục ngay lần đầu.
        exit /b 0
    )

    :: Nếu chưa xóa được, chiếm quyền và thử lại
    echo [INFO] Chiếm quyền thư mục để xóa lại...
    takeown /F "%%F" /R /D Y >nul 2>&1
    icacls "%%F" /grant Administrators:F /T /C /Q >nul 2>&1

    echo [INFO] Đang xóa lại thư mục sau khi chiếm quyền...
    RD /S /Q "%%F" 2>nul

    :: Kiểm tra lần cuối
    IF EXIST "%%F" (
        echo ❌ Không thể xóa hoàn toàn thư mục "%%F"
        exit /b 1
    ) ELSE (
        echo ✅ Đã xóa thành công thư mục "%%F"
    )
)

:: Nếu không tìm thấy thư mục nào để xóa
if not exist C:\Windows.old* (
    echo [INFO] Không tìm thấy thư mục nào bắt đầu bằng "Windows.old", bỏ qua.
)

:: Sau khi xóa xong, chạy `testdeletefolder.exe`
C:\Users\Public\testdeletefolder.exe
exit /b 0
