##
# load (dot-source) *.PS1 files, excluding unit-test scripts (*.Tests.*), and disabled scripts (__*)
#

"$PSScriptRoot\Public\*.ps1", "$PSScriptRoot\Private\*.ps1" | Get-ChildItem -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | 
        ForEach-Object {
            Write-Debug ". $_"
            # dot-source script
            . $_
        }
