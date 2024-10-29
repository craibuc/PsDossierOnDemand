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

$filterCondition = [FilterCondition]::new("assetType.type",'eq','Bus')
$filter = [Filter]::new("and", $filterCondition)

$orderBy = [OrderBy]::new("primaryAssetIdentifier", "asc")

$expands = [Expand]::new('AssetType'),[Expand]::new('Disposition',[Expand]::new('Status'))

$operation = [Operation]::new(1, 10, $filter, $orderBy, $expands)

Write-Debug ('$Operation: {0}' -f ($operation | convertto-json -depth 10))

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Assets/Assets' -Operation $Operation
