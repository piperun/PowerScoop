#Requires -Version 5.1
#Requires -Modules @{ ModuleName = 'BuildHelpers'; RequiredVersion = '2.0.16' }
#Requires -Modules @{ ModuleName = 'Pester'; RequiredVersion = '5.9.1' }

$pesterConfig = New-PesterConfiguration -Hashtable @{
    Run    = @{
        Path     = "$PSScriptRoot/.."
        PassThru = $true
    }
    Output = @{
        Verbosity = 'Detailed'
    }
}
$result = Invoke-Pester -Configuration $pesterConfig
exit $result.FailedCount
