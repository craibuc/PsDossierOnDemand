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
        [Parameter(Mandatory,ParameterSetName='Current')]
        [object]$Token,

        [Parameter(Mandatory,ParameterSetName='Deprecated')]
        [ValidateSet('Staging','Production')]
        [string]$Environment,

        [Parameter(Mandatory,ParameterSetName='Deprecated')]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [string]$Path,

        [Operation]$Operation

        # [int]$Page=1,
        # [ValidateRange(1, 1000)]
        # [int]$Amount=100,
        # [Filter]$Filter,
        # [OrderBy[]]$OrderBy,
        # [Expand[]]$Expands

    )
    
    begin {

        switch ($PSCmdlet.ParameterSetName) {
            'Current' {
                $Headers = @{
                    Authorization = "Bearer {0}" -f $Token.access_token
                    Accept = 'application/json'
                }
        
                $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Token.environment -eq 'Staging' ? 'stage.' : '')
                break
            }
            'Deprecated' {
                $Headers = @{
                    Authorization = "Bearer $AccessToken"
                    Accept = 'application/json'
                }
        
                $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Environment -eq 'Staging' ? 'stage.' : '')
                break
            }
        }

    }
    
    process {

        Write-Debug "Find-DossierObject($Path)"

        # $Operation2 = [Operation]::new(
        #     $Page, $Amount, $Filter, $OrderBy, $Expands
        # )

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