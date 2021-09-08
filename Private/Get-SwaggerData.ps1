function Get-SwaggerData {
    [CmdletBinding()]
    param (
        # Uri of Swagger Json file to parse
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [uri]
        $Uri
    )

    try {
        # Attempt the "correct" way, and remove any junk char bytes at the beginning.
        $Swagger = Invoke-RestMethod -Method 'Get' -Uri $Uri
        $SwaggerObject = $Swagger.Substring($Swagger.IndexOf('{')) | ConvertFrom-Json -Depth 8
    }
    catch {
        # Fallback to the "ugly" way...
        $TempFile = New-TemporaryFile
        Invoke-WebRequest -Uri $Uri -OutFile $TempFile
        $SwaggerObject = Get-Content -Path $TempFile -Raw | ConvertFrom-Json -Depth 8
        Remove-Item -Path $TempFile    
    }
    $SwaggerObject
}