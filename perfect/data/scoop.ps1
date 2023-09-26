# Get the current date and time components
$DateTime = Get-Date
$FormattedDate = $DateTime.ToString("yyyyMMdd_HHmmss")
$LogDirectory = "C:\Tools\Logs"
$LogFile = "$LogDirectory\${FormattedDate}.log"

function UpdateScoopApps {
    scoop update --all *> $LogFile
}

function DeleteOldLogs {
    # Calculate the date three days ago
    $CutoffDate = (Get-Date).AddDays(-1)

# Get a list of log files older than three days
    $OldLogFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log" | Where-Object { $_.LastWriteTime -lt $CutoffDate }

# Delete the old log files
    foreach ($oldLog in $OldLogFiles) {
        Remove-Item -Path $oldLog.FullName -Force
        "Deleted $($oldLog.Name)" >> $LogFile
    }
}

UpdateScoopApps
DeleteOldLogs