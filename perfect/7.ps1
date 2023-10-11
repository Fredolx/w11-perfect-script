$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
$tempLogPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "perfect-log.txt")
$logPath = Get-Content -Path $tempLogPath
Start-Transcript -Path $logPath -Append

$tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "perfect.txt")
$path = Get-Content -Path $tempPath

Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$path\vc.exe"
$oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
reg import "$path\bing.reg"
& "$path\vc.exe"
& "$oneDriveUninstall"
Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart

Stop-Process -Name explorer -Force