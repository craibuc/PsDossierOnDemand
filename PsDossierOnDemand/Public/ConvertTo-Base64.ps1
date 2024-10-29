function ConvertTo-Base64 {
    param (
        [Parameter(ValueFromPipeline)]
        [string]$InputString
    )

    # Convert the string to a byte array
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)

    # Convert the byte array to a Base64 string
    [Convert]::ToBase64String($bytes)
}