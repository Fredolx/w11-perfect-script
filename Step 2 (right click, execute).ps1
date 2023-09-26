Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "data\vc.exe"
$oneDriveUninstall = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe).UninstallString
Start-Process -FilePath "powershell.exe" -ArgumentList {
    reg import "$env:USERPROFILE\Desktop\perfect\data\bing.reg"
    & "$env:USERPROFILE\Desktop\perfect\data\vc.exe"
    & "$oneDriveUninstall" /uninstall
    Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart
} -Verb RunAs

irm get.scoop.sh | iex
scoop install 7zip git
scoop bucket add extras
scoop bucket add java
scoop install qbittorrent mpv ripgrep ventoy rufus yt-dlp ffmpeg winscp openjdk libreoffice kate kdenlive innounp imagemagick gimp krita inkscape kdiff3
Move-Item -Force -Path "data\mpv.conf" -Destination $env:USERPROFILE\scoop\persist\mpv\portable_config

New-Item C:\Tools -Type Directory
New-Item C:\Tools\Logs -Type Directory
Move-Item -Force -Path "data\run-hidden.exe", "data\scoop.ps1" -Destination C:\Tools
$sid = (Get-LocalUser -Name $env:USERNAME).sid.value
(Get-Content "data\scoop update.xml").replace('DESKTOP-CO2MH39\fred', "$env:COMPUTERNAME\$env:USERNAME") | Set-Content "data\scoop update.xml"
(Get-Content "data\scoop update.xml").replace('S-1-5-21-3097793162-3442654354-2889156627-1000', "$sid") | Set-Content "data\scoop update.xml"
Register-ScheduledTask -Xml (Get-Content -Path "data\scoop update.xml" | Out-String) -TaskName "scoop update" -TaskPath "\"

Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
reg import "data\rightclick.reg"
reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"

New-Item C:\Cli -Type Directory
Move-Item -Force -Path "data\SFTA.ps1" -Destination C:\cli
$env:Path += ";C:\cli"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\cli", [System.EnvironmentVariableTarget]::User)
. SFTA.ps1

Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mkv
Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mp4
Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mp3
Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .webm
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\swriter.exe" .doc
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\swriter.exe" .docx
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\swriter.exe" .rtf
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\scalc.exe" .xls
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\scalc.exe" .xlsx
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\simpress.exe" .ppt
Register-FTA "$env:USERPROFILE\scoop\apps\libreoffice\current\LibreOffice\program\simpress.exe" .pptx
Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .txt
Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .cfg
Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .conf
Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .ini

Get-AppxPackage "Clipchamp.Clipchamp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
Get-AppxPackage "MicrosoftTeams" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Todos" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage

Move-Item -Path "data\desktop\*" -Destination "$env:USERPROFILE\Desktop"
Stop-Process -Name explorer -Force