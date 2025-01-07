<#
.SYNOPSIS

.PARAMETER Token
Includes access token and environment.

.PARAMETER Path
.PARAMETER Id
.PARAMETER Expand

.EXAMPLE
Get-DossierObject -Token $Token -Path 'Inventory/Parts' -ID 12345

.EXAMPLE

Get-DossierObject -Token $Token -Path 'Inventory/Parts' -ID 12345 -Expand ([Expand]::new('SystemCode'),[Expand]::new('AssemblyCode'),[Expand]::new('ComponentCode'))
#>
function Get-DossierObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]$Token,
        
        [Parameter(Mandatory)]
        [string]$Path,

        [int]$Id,

        [Expand[]]$Expand
    )
    
    begin {
        $Headers = @{
            Authorization = "Bearer {0}" -f $Token.access_token
            Accept = 'application/json'
        }        
        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Token.environment -eq 'Staging' ? 'stage.' : '')
    }
    
    process {

        Write-Debug "Get-DossierObject($Path/$Id)"

        # $Uri = if ($Operation) {
        #     $Json = $Operation | ConvertTo-Json -Depth 10
        #     Write-Debug "Json: $Json"
        #     $Base64 = $Json | ConvertTo-Base64
        #     '{0}/{1}/{2}?operation={3}' -f $BaseId, $Path, $Id, $Base64
        # }
        
        $Uri = if ($Expand) {
            $Json = @{ Expands = $Expand } | ConvertTo-Json -Depth 10
            Write-Debug "Json: $Json"
            $Base64 = $Json | ConvertTo-Base64
            '{0}/{1}/{2}?operation={3}' -f $BaseId, $Path, $Id, $Base64
        }
        else {
            '{0}/{1}/{2}' -f $BaseId, $Path, $Id
        }

        try {
            $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -Verbose:$false
            if ($Response.Content) { $Response.Content | ConvertFrom-Json }
        }
        catch {
            throw ( $_.ErrorDetails.Message | ConvertFrom-Json ).developerMessage
        }
    }
    
    end {}

}