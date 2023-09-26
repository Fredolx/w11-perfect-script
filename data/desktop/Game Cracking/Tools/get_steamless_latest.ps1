function readLineNoColon {
    param($prompt)
    Write-Host $prompt -NoNewLine
    $Host.UI.ReadLine()
}

$version = (Invoke-RestMethod -Uri "https://api.github.com/repos/atom0s/steamless/releases/latest").tag_name
Write-Host Downloading $version
$download_url = "https://github.com/atom0s/Steamless/releases/latest/download/Steamless.$version.-.by.atom0s.zip"
Invoke-WebRequest -Uri $download_url -OutFile "steamless_$version.zip"
Write-Host "Download finished"
readLineNoColon("Press enter to continue...")
