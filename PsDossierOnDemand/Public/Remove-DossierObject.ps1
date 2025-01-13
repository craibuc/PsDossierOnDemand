function Remove-DossierObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [object]$Token,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [int]$Id,

        [string]$Verb = 'Delete'
    )
    
    begin {

        $Headers = @{
            Authorization = "Bearer {0}" -f $Token.access_token
            Accept = 'application/json'
        }

        $BaseId = "https://{0}d7.dossierondemand.com/api" -f ( $Token.environment -eq 'Staging' ? 'stage.' : '')

    }
    
    process {

        Write-Debug "Remove-DossierObject($Path/$Id/$Verb)"

        $Uri = '{0}/{1}/{2}/{3}' -f $BaseId, $Path, $Id, $Verb

        if ($PSCmdlet.ShouldProcess("$Path/$Id/$Verb", "DELETE")) {

            try {
                $Response = Invoke-WebRequest -Method Delete -Uri $Uri -Headers $Headers -Verbose:$false
            }
            catch {
                throw ( $_.ErrorDetails.Message | ConvertFrom-Json ).developerMessage
            }

        }

    }
    
    end {}

}