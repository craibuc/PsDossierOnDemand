function Set-DossierObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,ParameterSetName='Current')]
        [object]$Token,
        
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [int]$Id,

        [string]$Verb = 'Update',

        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$Data
    )
    
    begin {

        $Headers = @{
            Authorization = "Bearer {0}" -f $Token.access_token
            Accept = 'application/json'
        }

        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Token.environment -eq 'Staging' ? 'stage.' : '')

    }
    
    process {

        Write-Debug "Set-DossierObject($Path/$Id)"

        $Body = $Data | ConvertTo-Json -Depth 5
        Write-Debug "Body: $Body"

        $Uri = '{0}/{1}/{2}/{3}' -f $BaseId, $Path, $Id, $Verb

        if ($PSCmdlet.ShouldProcess("$Path/$Id/$Verb", "PUT")) {

            try {
                $Response = Invoke-WebRequest -Method Put -Uri $Uri -Headers $Headers -Body $Body -ContentType 'application/json' -Verbose:$false
                if ($Response.Content) { $Response.Content | ConvertFrom-Json }
            }
            catch {
                throw ( $_.ErrorDetails.Message | ConvertFrom-Json ).developerMessage
            }

        }

    }
    
    end {}

}