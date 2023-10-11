$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
$logFilePath = "$(Get-Date -Format "yyyy_MM_dd_HH_mm_ss").log"
Start-Transcript -Path $logFilePath -Append
Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$PSScriptRoot\vc.exe"
$oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
reg import "$PSScriptRoot\bing.reg"
& "$PSScriptRoot\vc.exe"
& "$oneDriveUninstall"
Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart
Stop-Process -Name explorer -Force
Stop-Transcript