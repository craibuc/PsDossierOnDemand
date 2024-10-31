function Get-DossierObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [ValidateSet('Staging','Production')]
        [string]$Environment,
        
        [Parameter(Mandatory)]
        [string]$Path,

        [int]$Id
    )
    
    begin {
        $Headers = @{
            Authorization = "Bearer $AccessToken"
            Accept = 'application/json'
        }
        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Environment -eq 'Staging' ? 'stage.' : '')
    }
    
    process {

        Write-Verbose "Get-DossierObject($Path/$Id)"

        $Uri = '{0}/{1}/{2}' -f $BaseId, $Path, $Id

        $Response = Invoke-WebRequest -Method Get -Uri $Uri -Headers $Headers -Verbose:$false

        if ($Response.Content) {
            $Response.Content | ConvertFrom-Json
        }
    }
    
    end {}

}