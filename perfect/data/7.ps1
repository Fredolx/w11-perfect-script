$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue

Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$PSScriptRoot\vc.exe"
$oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
reg import "$PSScriptRoot\bing.reg"
& "$PSScriptRoot\vc.exe"
& "$oneDriveUninstall"
Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart

Stop-Process -Name explorer -Force