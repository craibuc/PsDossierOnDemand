<#
.SYNOPSIS

.PARAMETER SystemPattern

.PARAMETER AssemblyPattern

.PARAMETER ComponentPattern

.EXAMPLE

[pscustomobject]@{System='045';Assembly='018';Component='*'} | ConvertTo-DossierVmrsFilter | ConvertTo-Json -Depth 5

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
function ConvertTo-DossierVmrsFilter {
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
      
        if ( [string]::IsNullOrEmpty($SystemPattern) -or [string]::IsNullOrEmpty($AssemblyPattern) -or [string]::IsNullOrEmpty($ComponentPattern) ) {
            Write-Error "Invalid system/assembly/component pattern"
            return
        }

        Write-Verbose ('{0} / {1} / {2}' -f $SystemPattern, $AssemblyPattern, $ComponentPattern)

        if ($SystemPattern -and $SystemPattern -ne '*') {

          $SystemCondition = @()
          $SystemPattern -split '[,\s]' | ForEach-Object {
            if ($_ -match '^[A-Z0-9]{3}$') {
                $SystemCondition += [FilterCondition]::new("assemblyCode.systemCode.code",'eq',$_)
            }
            else {
                $SystemCondition += [FilterCondition]::new("assemblyCode.systemCode.description",'contains',$_)
            }  
          }

          $Filters += [Filter]::new(
              "or",
              $SystemCondition
          )

      }

      if ($AssemblyPattern -and $AssemblyPattern -ne '*') {

          $AssemblyCondition = @()
          $AssemblyPattern -split '[,\s]' | ForEach-Object {
            if ($_ -match '^[A-Z0-9]{3}$') {
                $AssemblyCondition += [FilterCondition]::new("assemblyCode.code",'eq',$_)
            }
            else {
                $AssemblyCondition += [FilterCondition]::new("assemblyCode.description",'contains',$_)
            }
          }

          $Filters += [Filter]::new(
              "or",
              $AssemblyCondition
          )

      }

      if ($ComponentPattern -and $ComponentPattern -ne '*') {

          $ComponentCondition = @()
          $ComponentPattern.Split(',') | ForEach-Object {
              if ($_ -match '^[A-Z0-9]{3}$') {
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
        $Filters ? [Filter]::new("and",$Filters) : $null
    }

}
