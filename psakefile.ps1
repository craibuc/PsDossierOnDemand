Properties {
  $Here = Get-Location
  $ModuleName = Get-Location | Split-Path -Leaf
  $RepositoryName = $Env:REPOSITORY_NAME
  $NuGetApiKey = $Env:NUGET_API_KEY
}

Task Whoami {
  Write-Host "Here: $Here"
  Write-Host "ModuleName: $ModuleName"
  Write-Host "RepositoryName: $RepositoryName"
  Write-Host "NuGetApiKey: $NuGetApiKey"
}

Task Symlink -description "Create a symlink for '$RepositoryName' module" {
  Push-Location ~/.local/share/powershell/Modules
  ln -s "$Here/$ModuleName" $ModuleName
  Pop-Location
}

Task Publish -description "Publish module '$ModuleName' to repository '$RepositoryName'" {
  Publish-Module -name $ModuleName -Repository $RepositoryName -NuGetApiKey $NuGetApiKey
}
