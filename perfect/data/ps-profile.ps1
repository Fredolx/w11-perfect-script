function Encode-H264 {
    param (
        [string]$Path,
        [string]$Start,
        [string]$End,
        [string]$CRF = 28,
        [string]$Speed = "veryslow",
        [string]$Output
    )

    if ([string]::IsNullOrEmpty($Path)) {
        throw "Invalid Path"
    }
    if ([string]::IsNullOrEmpty($Output)) {
        throw "Invalid Output"
    }
    if (-Not [string]::IsNullOrEmpty($Start)) {
        $Start = " -ss $Start"
    }
    if (-Not [string]::IsNullOrEmpty($End)) {
        $End = " -to $End"
    }

    $Command = "ffmpeg -i `"$Path`"$Start$End -c:v libx264 -c:a copy -crf $CRF -preset $Speed `"$Output`""
    Write-Host $Command
    Invoke-Expression $Command
}

function Encode-H265 {
    param (
        [string]$Path,
        [string]$Start,
        [string]$End,
        [string]$CRF = 23,
        [string]$Speed = "slow",
        [string]$Output
    )

    if ([string]::IsNullOrEmpty($Path)) {
        throw "Invalid Path"
    }
    if ([string]::IsNullOrEmpty($Output)) {
        throw "Invalid Output"
    }
    if (-Not [string]::IsNullOrEmpty($Start)) {
        $Start = " -ss $Start"
    }
    if (-Not [string]::IsNullOrEmpty($End)) {
        $End = " -to $End"
    }

    $Command = "ffmpeg -i `"$Path`"$Start$End -c:v libx265 -c:a copy -crf $CRF -preset $Speed `"$Output`""
    Write-Host $Command
    Invoke-Expression $Command
}

function Encode-VP9 {
    param (
        [string]$Path,
        [string]$Start,
        [string]$End,
        [String]$Bitrate = "2M",
        [string]$Output
    )

    if ([string]::IsNullOrEmpty($Path)) {
        throw "Invalid Path"
    }
    if ([string]::IsNullOrEmpty($Output)) {
        throw "Invalid Output"
    }
    if (-Not [string]::IsNullOrEmpty($Start)) {
        $Start = " -ss $Start"
    }
    if (-Not [string]::IsNullOrEmpty($End)) {
        $End = " -to $End"
    }

    $CommandPass1 = "ffmpeg -i `"$Path`"$Start$End -c:v libvpx-vp9 -b:v $Bitrate -pass 1 -an -f null NUL"
    $CommandPass2 = "ffmpeg -i `"$Path`"$Start$End -c:v libvpx-vp9 -b:v $Bitrate -pass 2 -c:a libopus $Output"
    Write-Host $CommandPass1
    Write-Host $CommandPass2
    Invoke-Expression $CommandPass1
    Invoke-Expression $CommandPass2
}