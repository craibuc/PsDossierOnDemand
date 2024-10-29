<#
.EXAMPLE
Read-DotEnv

.NOTES
gci env:* | sort-object name

List the environment variables.
#>
function Read-DotEnv {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Path = '.env'
    )
    
    Write-Debug "Path: $Path"

    Get-Content -Path $Path | ForEach-Object {
        if ($_ -match '^(.*)=(.*)$') {
            $key = $matches[1]
            $value = $matches[2]

            Write-Debug "$key`: $value"
            [System.Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process)
        }
    }
    
}