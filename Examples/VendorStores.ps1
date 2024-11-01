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
    1, 10, 
    [Filter]::new(
        "and",
        [FilterCondition]::new("vendorStoreIdentifier",'eq','NO10025')
    ),
    [OrderBy]::new("name", "asc"), 
    ( [Expand]::new('Disposition',[Expand]::new('Status')), [Expand]::new('Vendor',[Expand]::new('Disposition')) )
)
$operation | convertto-json -depth 10

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Procurement/VendorStores' -Operation $Operation