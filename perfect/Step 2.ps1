function Install-Scoop {
    $scoopExists = Get-Command scoop
    if (!$scoopExists) {
        irm get.scoop.sh | iex
    }
    scoop install 7zip git
    scoop bucket add extras
    scoop bucket add java
    scoop install qbittorrent mpv ripgrep ventoy rufus yt-dlp ffmpeg winscp openjdk libreoffice kate kdenlive innounp imagemagick gimp kdiff3
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
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Value 0
    reg import "data\rightclick.reg"
    reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"
    RemoveEdgeStartup
    Stop-Process -Name explorer -Force    
}

function RemoveEdgeStartup {
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
}

function Admin {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSScriptRoot\data\7.ps1" -Verb RunAs
} 

function Show-Menu() {
    Clear-Host
    Write-Host '1. Install scoop apps'
    Write-Host '2. Install task scheduler task for scoop updates'
    Write-Host '3. Install registry edits'
    Write-Host '4. Set file type assocations'
    Write-Host '5. Delete MS-Apps'
    Write-Host '6. Move extras to desktop'
    Write-Host '7. Remove Ads, OneDrive, LegacyMediaPlayer (ADMIN)'
    Write-Host 'To do all steps, type all numbers (123456), recommended to do 7 after'
    Write-Host 'Enter q to quit'
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

    if($choice.Contains('1')) {
        Install-Scoop
    }
    if($choice.Contains('2')) {
        Install-UpdateScoop-Task
    }
    if($choice.Contains('3')) {
        Install-Registry-Edits
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
        Admin
    }
    
} while (!$choice.ToLower().Contains('q'))

Stop-Transcript