<#
.EXAMPLE
$FilterCondition = [FilterCondition]::new("primaryAssetIdentifier",'eq','DUMMY')
$Filter = [Filter]::new("and", $FilterCondition)
$OrderBy = [OrderBy]::new("primaryAssetIdentifier", "asc")
$Operation = [Operation]::new(1, 10, $Filter, $OrderBy, $null)

Find-DossierObject -AccessToken $Env:DOSSIER_ACCESS_TOKEN -Environment Produciton -Path 'Assets/Assets' -Operation $Operation
#>

function Find-DossierObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [ValidateSet('Staging','Production')]
        [string]$Environment,

        [Parameter(Mandatory)]
        [string]$Path,

        [Operation]$Operation
    )
    
    begin {
        $Headers = @{
            Authorization = "Bearer $AccessToken"
            Accept = 'application/json'
        }
        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Environment -eq 'Staging' ? 'stage.' : '')
        Write-Debug "BaseId: $BaseId"
    }
    
    process {

        Write-Debug "Find-DossierObject($Path)"

        $Uri = if ($Operation) {
            # Write-Debug ($Operation | ConvertTo-Json -Depth 5)
            $O = $Operation | ConvertTo-Json -Depth 10 | ConvertTo-Base64

            '{0}/{1}?operation={2}' -f $BaseId, $Path, $O
        }
        else {
            '{0}/{1}' -f $BaseId, $Path
        }
        
        $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -Verbose:$false

        if ($Response.Content) {
            $Response.Content | ConvertFrom-Json
        }
    }
    
    end {}

}