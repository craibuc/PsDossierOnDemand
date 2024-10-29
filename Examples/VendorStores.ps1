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

$filterCondition = [FilterCondition]::new("vendorStoreIdentifier",'eq','NO10025')
$filter = [Filter]::new("and", $filterCondition)

# useful when multiple records are returned
$orderBy = $null
# $orderBy = [OrderBy]::new("name", "asc")

# include details of referenced objects
$expands = [Expand]::new('Disposition',[Expand]::new('Status')), [Expand]::new('Vendor',[Expand]::new('Disposition'))

$operation = [Operation]::new(1, 10, $filter, $orderBy, $expands)

Write-Debug ('$Operation: {0}' -f ($operation | convertto-json -depth 10))

$VendorStore = Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Procurement/VendorStores' -Operation $Operation #| 
$VendorStore
