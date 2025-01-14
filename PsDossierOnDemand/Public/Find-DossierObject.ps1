<#
.EXAMPLE
$FilterCondition = [FilterCondition]::new("primaryAssetIdentifier",'eq','DUMMY')
$Filter = [Filter]::new("and", $FilterCondition)
$OrderBy = [OrderBy]::new("primaryAssetIdentifier", "asc")
$Operation = [Operation]::new(1, 10, $Filter, $OrderBy, $null)

Find-DossierObject -Token $Env:DOSSIER_ACCESS_TOKEN -Path 'Assets/Assets' -Operation $Operation
#>

function Find-DossierObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ParameterSetName='Current')]
        [object]$Token,

        [Parameter(Mandatory)]
        [string]$Path,

        [Operation]$Operation
    )
    
    begin {

        $Headers = @{
            Authorization = "Bearer {0}" -f $Token.access_token
            Accept = 'application/json'
        }

        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Token.environment -eq 'Staging' ? 'stage.' : '')

    }
    
    process {

        Write-Debug "Find-DossierObject($Path)"

        $Uri = if ($Operation) {
            $O = $Operation | ConvertTo-Json -Depth 10 | ConvertTo-Base64
            '{0}/{1}?operation={2}' -f $BaseId, $Path, $O
        }
        else {
            '{0}/{1}' -f $BaseId, $Path
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