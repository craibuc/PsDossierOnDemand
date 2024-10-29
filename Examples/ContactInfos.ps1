<# 
ContactInfos
#> 

[CmdletBinding()]
param ()

#requires -module PsDossierOnDemand

# if using .env file
# Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
# Read-DotEnv

$Credential = [pscredential]::new($Env:DOSSIER_USERNAME,($Env:DOSSIER_PASSWORD|ConvertTo-SecureString -AsPlainText -Force))

$Token = New-DossierSession -Environment Staging -ClientId $Env:DOSSIER_CLIENT_ID -ClientSecret $Env:DOSSIER_CLIENT_SECRET -Credential $Credential

$filter = $null
$filterCondition = [FilterCondition]::new("referencedEntityId",'eq','942')
$filter = [Filter]::new("and", $filterCondition)

$orderBy = [OrderBy]::new("name", "asc")

$expands = $null

$operation = [Operation]::new(1, 100, $filter, $orderBy, $expands)

Write-Debug ('$Operation: {0}' -f ($operation | convertto-json -depth 10))

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'ContactInfo/ContactInfos' -Operation $Operation