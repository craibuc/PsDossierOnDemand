<#
.EXAMPLE

$Filter = [Filter]::new("and",[FilterCondition]::new("name",'startswith',$WarrantyName))
$OrderBy = [OrderBy]::new('name','asc')
$Expands = (
            [Expand]::new('Vendor'),
            [Expand]::new('WarrantySource'),
            [Expand]::new('WarrantyType'),
            [Expand]::new('WarrantyMetrics.Measure'),
            [Expand]::new('WarrantyMetrics.Measure.MeasureType')
        )

Find-DossierObjectAll -Token $Token -Path 'Warranty/Warranty' -Filter $Filter -OrderBy $OrderBy -Expands $Expands
#>

function Find-DossierObjectAll {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ParameterSetName='Current')]
        [object]$Token,

        [Parameter(Mandatory)]
        [string]$Path,

        [ValidateRange(1, 1000)]
        [int]$Amount=100,

        [Parameter()]
        [Filter]$Filter,

        [Parameter()]
        [OrderBy[]]$OrderBy,

        [Parameter()]
        [Expand[]]$Expands
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

        $Continue = $false

        $Operation = [Operation]::new(
            1, $Amount, $Filter, $OrderBy, $Expands
        )

        do {

            $Uri = if ($Operation) {
                Write-Debug ($Operation | ConvertTo-Json -Depth 10)
                $O = $Operation | ConvertTo-Json -Depth 10 | ConvertTo-Base64

                '{0}/{1}?operation={2}' -f $BaseId, $Path, $O
            }
            else {
                '{0}/{1}' -f $BaseId, $Path
            }
            
            try {
                $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -Verbose:$false
                if ($Response.Content) { 
                    $Content = $Response.Content | ConvertFrom-Json
                    $Continue = $null -ne $Content
                    $Content
                }
            }
            catch {
                throw ( $_.ErrorDetails.Message | ConvertFrom-Json ).developerMessage
            }

            $Operation.Page++

        } while ($Continue)
    
    }
    
    end {}

}