<#
.EXAMPLE
$Credential = [pscredential]::new($Env:DOSSIER_USERNAME,($Env:DOSSIER_PASSWORD|ConvertTo-SecureString -AsPlainText -Force))

New-DossierSession -Environment Production -ClientId $Env:DOSSIER_CLIENT_ID -ClientSecret $Env:DOSSIER_CLIENT_SECRET -Credential $Credential

@{
    access_token=[redacted]; 
    expires_in=604800; 
    token_type=Bearer; 
    scope=DossierApi
}
#>
function New-DossierSession {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Staging','Production')]
        [string]$Environment,
        
        [Parameter(Mandatory)]
        [string]$ClientId,

        [Parameter(Mandatory)]
        [string]$ClientSecret,

        [Parameter(Mandatory)]
        [pscredential]$Credential
    )

    $Uri = "https://{0}.d7.dossierondemand.com/connect/token" -f ( $Environment -eq 'Staging' ? 'authstage' : 'authentication')

    $Headers = @{
        Accept = 'application/json'
    }

    $Body = @{
        grant_type = 'password'
        scope = 'DossierApi'
        client_id = $ClientId
        client_secret = $ClientSecret
        username = $Credential.UserName
        password = $Credential.Password | ConvertFrom-SecureString -AsPlainText
    }

    $Response = Invoke-WebRequest -Method Post -Uri $Uri -Headers $Headers -Body $Body -ContentType 'application/x-www-form-urlencoded'

    if ($Response.Content) {
        $Response.Content | ConvertFrom-Json
    }

}