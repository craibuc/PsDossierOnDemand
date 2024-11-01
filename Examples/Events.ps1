<# 
VendorStores
#> 

[CmdletBinding()]
param ()

#requires -module PsDossierOnDemand

# if using .env file
# Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
# Read-DotEnv

$Credential = [pscredential]::new($Env:DOSSIER_USERNAME,($Env:DOSSIER_PASSWORD|ConvertTo-SecureString -AsPlainText -Force))

$Token = New-DossierSession -Environment Staging -ClientId $Env:DOSSIER_CLIENT_ID -ClientSecret $Env:DOSSIER_CLIENT_SECRET -Credential $Credential

$operation = [Operation]::new(
    1, 100, 
    $null,
    $null, 
    [Expand]::new( 'Disposition', ([Expand]::new('EventType'),[Expand]::new('EventStatus')) ),[Expand]::new('Reference'),[Expand]::new('EventDetailType')
)
$operation | convertto-json -depth 10

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Auditing/Events/WithEventDetailTypeAndReference' -Operation $Operation