function New-DossierObject {

    [CmdletBinding(SupportsShouldProcess)]
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

        [string]$Verb = 'Create',

        [string]$Query,

        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$Data
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

        $Uri = $Query ? '{0}/{1}/{2}?{3}' -f $BaseId, $Path, $Verb, $Query : '{0}/{1}/{2}' -f $BaseId, $Path, $Verb
        Write-Debug "Uri: $Uri"

    }
    
    process {

        Write-Debug "New-DossierObject($Path)"

        $Body = $Data | ConvertTo-Json -Depth 5

        if ($PSCmdlet.ShouldProcess("$Path/$Verb", "POST")) {

            $Response = Invoke-WebRequest -Method Post -Uri $Uri -Headers $Headers -Body $Body -ContentType 'application/json' -Verbose:$false

            if ($Response.Content) {
                $Response.Content | ConvertFrom-Json
            }

        }

    }
    
    end {}

}