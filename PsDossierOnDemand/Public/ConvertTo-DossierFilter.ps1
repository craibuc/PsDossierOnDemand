<#
.SYNOPSIS

.PARAMETER SystemPattern

.PARAMETER AssemblyPattern

.PARAMETER ComponentPattern

.EXAMPLE

[pscustomobject]@{System='045';Assembly='018';Component='*'} | ConvertTo-DossierFilter | ConvertTo-Json -Depth 5

{
  "Logic": "and",
  "Filters": [
    {
      "Logic": "or",
      "Filters": [
        {
          "Field": "assemblyCode.systemCode.code",
          "Operator": "eq",
          "Value": "045"
        }
      ]
    },
    {
      "Logic": "or",
      "Filters": [
        {
          "Field": "assemblyCode.code",
          "Operator": "eq",
          "Value": "018"
        }
      ]
    }
  ]
}
#>
function ConvertTo-DossierFilter {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('System')]
        [string]$SystemPattern,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Assembly')]
        [string]$AssemblyPattern,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Component')]
        [string]$ComponentPattern
    )
    
    begin {
        $Filters = @()
    }
    
    process {
        Write-Verbose ('{0} / {1} / {2}' -f $SystemPattern, $AssemblyPattern, $ComponentPattern)

        if ($SystemPattern -and $SystemPattern -ne '*') {

            $SystemCondition = @()
            $SystemCondition += [FilterCondition]::new("assemblyCode.systemCode.code",'eq',$SystemPattern)

            $Filters += [Filter]::new(
                "or",
                $SystemCondition
            )

        }

        if ($AssemblyPattern -and $AssemblyPattern -ne '*') {

            $AssemblyCondition = @()
            $AssemblyCondition += [FilterCondition]::new("assemblyCode.code",'eq',$AssemblyPattern)

            $Filters += [Filter]::new(
                "or",
                $AssemblyCondition
            )

        }

        if ($ComponentPattern -and $ComponentPattern -ne '*') {

            $ComponentCondition = @()

            $ComponentPattern.Split(',') | ForEach-Object {
                if ($_ -match '^[0-9]{3}$') {
                    $ComponentCondition += [FilterCondition]::new("code",'eq',$_)
                }
                else {
                    $ComponentCondition += [FilterCondition]::new("description",'contains',$_)
                }
                
            }

            $Filters += [Filter]::new(
                "or",
                $ComponentCondition
            )

        }

    }
    
    end {
        [Filter]::new(
            "and",
            $Filters
        )        
    }

}
