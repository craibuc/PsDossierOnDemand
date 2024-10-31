function Set-DossierObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [ValidateSet('Staging','Production')]
        [string]$Environment,
        
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [int]$Id,

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

        Write-Verbose "Set-DossierObject($Path/$Id)"

        $Body = $Data | ConvertTo-Json -Depth 5

        $Uri = '{0}/{1}/{2}/Update' -f $BaseId, $Path, $Id

        if ($PSCmdlet.ShouldProcess("$Path/$Id/Update", "PUT")) {

            $Response = Invoke-WebRequest -Method Put -Uri $Uri -Headers $Headers -Body $Body -ContentType 'application/json' -Verbose:$false

            if ($Response.Content) {
                $Response.Content | ConvertFrom-Json
            }

        }

    }
    
    end {}

}