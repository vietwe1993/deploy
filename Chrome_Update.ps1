$version = "140.0.7339.128"

# Thư mục tạm cho installer
$tempDir = "C:\TempChromeInstall"
$chromeInstallerPath = "$tempDir\chrome_installer.exe"

# Tạo thư mục tạm
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

# Tìm và gỡ Chrome theo phiên bản
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$chromeFound = $false

foreach ($path in $regPaths) {
    $apps = Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*Google Chrome*" -and $_.DisplayVersion -eq $version }
    foreach ($app in $apps) {
        if ($app.UninstallString) {
            Write-Output "Uninstalling Google Chrome version $version..."
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$($app.UninstallString)`" /quiet /norestart" -Wait
            Write-Output "Google Chrome successfully uninstalled"
            $chromeFound = $true
        }
    }
}

if (-not $chromeFound) {
    Write-Output "Chrome version $version not found, skipping uninstall"
}

# Tải Chrome mới nhất
Write-Output "Downloading latest Chrome..."
Start-BitsTransfer -Source 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -Destination $chromeInstallerPath

# Cài Chrome silent
Write-Output "Installing latest Chrome silently..."
Start-Process -FilePath $chromeInstallerPath -ArgumentList '/silent','/install' -Wait
Write-Output "Chrome installation completed."

# Xóa cả thư mục tạm
Remove-Item $tempDir -Recurse -Force
Write-Output "Temporary folder removed."
