$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
Write-Host $PSScriptRoot

Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$PSScriptRoot\data\vc.exe"
$oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
reg import "$PSScriptRoot\data\bing.reg"
& "$PSScriptRoot\data\vc.exe"
& "$oneDriveUninstall"
Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart

Stop-Process -Name explorer -Force