# Define the path to the Apache access log file
$logFilePath = "C:\temp\access.log"

# Create a DataTable to store the extracted log fields
$dataTable = New-Object System.Data.DataTable
$dataTable.Columns.Add("IP Address", [string])
$dataTable.Columns.Add("Timestamp", [string])
$dataTable.Columns.Add("Method", [string])
$dataTable.Columns.Add("URI", [string])
$dataTable.Columns.Add("Protocol", [string])
$dataTable.Columns.Add("Status Code", [string])
$dataTable.Columns.Add("Response Size", [int])

# Read the contents of the log file
$logContents = Get-Content -Path $logFilePath

# Define the regular expression pattern to match the log entries
$logEntryPattern = '^(?<ipAddress>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s-\s-\s\[(?<timestamp>[^\]]+)\]\s"(?<method>[A-Z]+)\s(?<uri>[^"]+)\s(?<protocol>[^"]+)"\s(?<statusCode>\d{3})\s(?<responseSize>\d+)'

# Iterate through each log entry and extract the desired fields
foreach ($logEntry in $logContents) {
    $matches = $logEntry | Select-String -Pattern $logEntryPattern -AllMatches
    foreach ($match in $matches.Matches) {
        $ipAddress = $match.Groups["ipAddress"].Value
        $timestamp = $match.Groups["timestamp"].Value
        $method = $match.Groups["method"].Value
        $uri = $match.Groups["uri"].Value
        $protocol = $match.Groups["protocol"].Value
        $statusCode = $match.Groups["statusCode"].Value
        $responseSize = [int]$match.Groups["responseSize"].Value

        # Add the extracted fields to the DataTable
        $row = $dataTable.NewRow()
        $row["IP Address"] = $ipAddress
        $row["Timestamp"] = $timestamp
        $row["Method"] = $method
        $row["URI"] = $uri
        $row["Protocol"] = $protocol
        $row["Status Code"] = $statusCode
        $row["Response Size"] = $responseSize
        $dataTable.Rows.Add($row)
    }
}

# Output the DataTable
$dataTable | ogv

