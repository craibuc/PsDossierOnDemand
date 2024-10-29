function ConvertFrom-Base64 {
    param (
        [Parameter(ValueFromPipeline)]
        [string]$InputString
    )

    # Convert Base64 to byte array
    $bytes = [Convert]::FromBase64String($InputString)

    # Convert byte array to string
    [System.Text.Encoding]::UTF8.GetString($bytes)
}