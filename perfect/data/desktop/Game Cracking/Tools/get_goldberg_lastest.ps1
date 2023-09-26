function readLineNoColon {
    param($prompt)
    Write-Host $prompt -NoNewLine
    $Host.UI.ReadLine()
}

# Specify the URL of the webpage you want to download
$webpageUrl = "https://mr_goldberg.gitlab.io/goldberg_emulator"

# Use Invoke-WebRequest to download the webpage content
$response = Invoke-WebRequest -Uri $webpageUrl

# Parse the HTML content of the webpage
$html = $response.ParsedHtml

# Find the <a> tag with the text "Latest Build"
$latestBuildLink = $html.getElementsByTagName("a") | Where-Object { $_.innerText -eq "Latest Build" }

# Check if the <a> tag was found
if ($latestBuildLink -eq $null) {
    Write-Host "Latest Build link not found on the webpage."
} else {
    # Get the URL from the href attribute of the <a> tag
    $latestBuildUrl = $latestBuildLink.href

    # Use Invoke-WebRequest to download the file
    $outputFilePath = "."  # Replace with the desired file path
    Invoke-WebRequest -Uri $latestBuildUrl -OutFile "goldberg_latest.zip"

    Write-Host "Latest Build file downloaded to $outputFilePath"
}

readLineNoColon("Press enter to continue...")
