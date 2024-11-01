<# 
Vendors
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
    [Filter]::new(
        "and",
        [FilterCondition]::new("vendorIdentifier",'eq','napa.com')
    ),
    $null, 
    [Expand]::new('Disposition',[Expand]::new('Status')),[Expand]::new('VendorStores')
)
$operation | convertto-json -depth 10

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Procurement/Vendors' -Operation $Operation