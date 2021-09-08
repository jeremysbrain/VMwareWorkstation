# Check for -verbose switch
if ($MyInvocation.Line -match '-Verbose') {
    $OriginalVerbosePreference = $VerbosePreference
    $VerbosePreference = 'Continue'
}

# Load any enumerators
if (Test-Path -Path "$PSScriptRoot\.enum.ps1") {
    . "$PSScriptRoot\.enum.ps1"
}

$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach ($Import in @($Public + $Private)) {
    Try {
        Write-Verbose "Importing $Import.fullname"
        . $Import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename

# Reset Verbose Preference
if ($MyInvocation.Line -match '-Verbose') {
    $VerbosePreference = $OriginalVerbosePreference
}