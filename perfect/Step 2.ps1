function Install-Scoop {
    $scoopExists = Get-Command scoop
    if (!$scoopExists) {
        irm get.scoop.sh | iex
    }
    scoop install 7zip git
    scoop bucket add extras
    scoop bucket add java
    scoop install qbittorrent mpv ripgrep ventoy rufus yt-dlp ffmpeg winscp openjdk libreoffice kate innounp imagemagick kdiff3
    Move-Item -Force -Path "data\mpv.conf" -Destination $env:USERPROFILE\scoop\persist\mpv\portable_config
}

function Install-UpdateScoop-Task {
    New-Item C:\Tools -Type Directory
    New-Item C:\Tools\Logs -Type Directory
    Copy-Item -Force -Path "data\run-hidden.exe", "data\scoop.ps1" -Destination C:\Tools
    $sid = (Get-LocalUser -Name $env:USERNAME).sid.value
    (Get-Content "data\scoop update.xml").replace('DESKTOP-CO2MH39\fred', "$env:COMPUTERNAME\$env:USERNAME") | Set-Content "data\scoop update.xml"
    (Get-Content "data\scoop update.xml").replace('S-1-5-21-3097793162-3442654354-2889156627-1000', "$sid") | Set-Content "data\scoop update.xml"
    Register-ScheduledTask -Xml (Get-Content -Path "data\scoop update.xml" | Out-String) -TaskName "scoop update" -TaskPath "\"
}

function Install-Registry-Edits {
    Remove-Edge-Startup
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name RotatingLockScreenEnabled -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-338387Enabled -Value 0
    reg import "$PSScriptRoot\data\rightclick.reg"
    reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"
    Stop-Process -Name explorer -Force    
}

function Set-PowerPlan {
    $powerplans = powercfg list
    $pattern = "Power Scheme GUID: ([a-f0-9-]+)\s+\(High performance\)"
    $match = $powerplans | Select-String -Pattern $pattern
    $guid = $match.Matches.Groups[1].Value
    powercfg /setactive $guid
    powercfg /change monitor-timeout-ac 0
    powercfg /change monitor-timeout-dc 0
    powercfg /change standby-timeout-ac 0
    powercfg /change standby-timeout-dc 0
}

function Remove-Edge-Startup {
    Write-Host "Go to the startup tab in the task manager window that will appear and then close it"
    Write-Host "Sleeping 5 seconds..."
    sleep 5
    $proc = Start-Process taskmgr.exe -Wait
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
    $values = Get-ItemProperty -Path $registryPath | Get-ItemProperty | ForEach-Object { $_.PSObject.Properties }
    $valueName = $($values | Where-Object { $_.Name -like 'MicrosoftEdgeAutoLaunch*' } | Select-Object -First 1).Name
    $binaryData = 3, 0, 0, 0, 21, 117, 166, 208, 33, 252, 217, 1
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $binaryData -Type Binary
}

function Set-FTAs {
    $cliPath="C:\cli"
    if(!(Test-Path -Path $cliPath)){
        New-Item $cliPath -Type Directory
    }
    Copy-Item -Force -Path "data\SFTA.ps1" -Destination $cliPath
    if(!$env:Path.Contains("$cliPath")){
        $env:Path += ";C:\cli"
        [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\cli", [System.EnvironmentVariableTarget]::User)
    }
    . SFTA.ps1
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mkv
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mp4
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mp3
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .webm
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .opus
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .avi
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .mov
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .ogg
    Register-FTA "$env:USERPROFILE\scoop\apps\mpv\current\mpv.exe" .flv
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
    Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .nfo
    Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .xml
    Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .json
    Register-FTA "$env:USERPROFILE\scoop\apps\kate\current\bin\kate.exe" .yml
    Register-FTA "$env:USERPROFILE\scoop\apps\7zip\current\7zFM.exe" .7z
    Register-FTA "$env:USERPROFILE\scoop\apps\7zip\current\7zFM.exe" .zip
    Register-FTA "$env:USERPROFILE\scoop\apps\7zip\current\7zFM.exe" .rar
    Register-FTA "$env:USERPROFILE\scoop\apps\qbittorrent\current\qbittorrent.exe" .torrent
}

function Delete-MS-Apps {
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
}

function Move-Extras {
    Move-Item -Path "data\desktop\*" -Destination "$env:USERPROFILE\Desktop"
    $FolderPath = Split-Path $PROFILE.CurrentUserCurrentHost
    New-Item -ItemType Directory -Force -Path $FolderPath
    Copy-Item -Path "data\ps-profile.ps1" -Destination $PROFILE.CurrentUserCurrentHost -Force
}

function Admin {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSScriptRoot\data\7.ps1" -Verb RunAs
} 

function Show-Menu() {
    Clear-Host
    Write-Host '1. Set Power Plan to High Performance'
    Write-Host '2. Install scoop apps'
    Write-Host '3. Install task scheduler task for scoop updates'
    Write-Host '4. Set file type assocations'
    Write-Host '5. Delete MS-Apps'
    Write-Host '6. Move extras to desktop'
    Write-Host '7. Install registry edits'
    Write-Host '8. Remove Ads, OneDrive, LegacyMediaPlayer (ADMIN)'
    Write-Host 'Q to quit'
    Write-Host 'To do all steps, type all numbers (12345), it''s strongly recommended to do 123456 then 78 seperately'
}

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
if(!(Test-Path -Path "logs")) {
        New-Item "logs" -Type Directory
}
$logFilePath = "logs/$(Get-Date -Format "yyyy_MM_dd_HH_mm_ss").log"
Start-Transcript -Path $logFilePath -Append

do {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    Clear-Host
    if($choice.Contains('1')) {
        Set-PowerPlan
    }
    if($choice.Contains('2')) {
        Install-Scoop
    }
    if($choice.Contains('3')) {
        Install-UpdateScoop-Task
    }
    if($choice.Contains('4')) {
        Set-FTAs
    }
    if($choice.Contains('5')) {
        Delete-MS-Apps
    }
    if($choice.Contains('6')) {
        Move-Extras
    }
    if($choice.Contains('7')) {
        Install-Registry-Edits
    }
    if($choice.Contains('8')) {
        Admin
    }
    
} while (!$choice.ToLower().Contains('q'))

Stop-Transcript
