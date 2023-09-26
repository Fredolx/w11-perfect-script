$fileName = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "perfect.txt")
$textContent = $PSScriptRoot
$textContent | Set-Content -Path $fileName

Start-Process -FilePath "powershell.exe" -ArgumentList {
    $tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "perfect.txt")
    $path = Get-Content -Path $tempPath
    Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "$path\data\vc.exe"
    $oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
    reg import "$path\data\bing.reg"
    & "$path\data\vc.exe"
    & "$oneDriveUninstall"
    Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart
    Stop-Process -Name explorer -Force
} -Verb RunAs

Move-Item -Path "data\desktop\*" -Destination "$env:USERPROFILE\Desktop"
Stop-Process -Name explorer -Force