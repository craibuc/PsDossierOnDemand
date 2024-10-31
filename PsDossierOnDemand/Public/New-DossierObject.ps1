function New-DossierObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [ValidateSet('Staging','Production')]
        [string]$Environment,
        
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$Data
    )
    
    begin {

        $Headers = @{
            Authorization = "Bearer $AccessToken"
            Accept = 'application/json'
        }

        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Environment -eq 'Staging' ? 'stage.' : '')
    }
    
    process {

        Write-Verbose "New-DossierObject($Path)"

        $Body = $Data | ConvertTo-Json -Depth 5

        $Uri = '{0}/{1}' -f $BaseId, $Path

        if ($PSCmdlet.ShouldProcess($Path, "POST")) {

            $Response = Invoke-WebRequest -Method Post -Uri $Uri -Headers $Headers -Body $Body -ContentType 'application/json' -Verbose:$false

            if ($Response.Content) {
                $Response.Content | ConvertFrom-Json
            }

        }

    }
    
    end {}

}