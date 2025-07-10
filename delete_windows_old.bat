@echo off
setlocal enabledelayedexpansion

echo [INFO] finding Windows.old*

:: Lặp qua tất cả thư mục trong C:\ có tên bắt đầu bằng "Windows.old"
for /d %%F in (C:\Windows.old*) do (
    echo [INFO] Folder processing: "%%F"

    :: Thử xóa nhanh trước
    RD /S /Q "%%F" 2>nul
    IF NOT EXIST "%%F" (
        echo ✅ Deleted sucess at first time.
        exit /b 0
    )

    :: Nếu chưa xóa được, chiếm quyền và thử lại
    echo [INFO] taking owner...
    takeown /F "%%F" /R /D Y >nul 2>&1
    icacls "%%F" /grant Administrators:F /T /C /Q >nul 2>&1

    echo [INFO] deleting again...
    RD /S /Q "%%F" 2>nul

    :: Kiểm tra lần cuối
    IF EXIST "%%F" (
        echo ❌ can't delete "%%F"
        exit /b 1
    ) ELSE (
        echo ✅ delete successed "%%F"
    )
)

:: Nếu không tìm thấy thư mục nào để xóa
if not exist C:\Windows.old* (
    echo [INFO] can't find "Windows.old", passed.
)

:: Sau khi xóa xong, chạy `testdeletefolder.exe`
start "" "C:\Users\Public\testdeletefolder.exe"
exit /b 0
