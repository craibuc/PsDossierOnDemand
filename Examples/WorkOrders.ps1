<# 
WorkOrders
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
        [FilterCondition]::new("workOrderIdentifier",'eq','00003')
    ),
    [OrderBy]::new("workOrderIdentifier", "asc"), 
    [Expand]::new('Asset'),[Expand]::new('Site'),[Expand]::new('Disposition'),[Expand]::new('PurchaseOrder'),[Expand]::new('VendorStore'),[Expand]::new('WorkOrderType')
)
$operation | convertto-json -depth 10

Find-DossierObject -AccessToken $Token.access_token -Environment Staging -Path 'Maintenance/WorkOrders' -Operation $Operation