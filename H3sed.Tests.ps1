Describe 'H3sed manifest' {
    BeforeEach {
        $manifest = Get-Content "$PSScriptRoot/bucket/h3sed.json" -Raw |
            ConvertFrom-Json
    }

    It 'points the shim at the downloaded executable' {
        $filename = [System.IO.Path]::GetFileName(
            ([Uri]$manifest.architecture.'64bit'.url).AbsolutePath
        )
        if ($manifest.bin -ne $filename) {
            throw "Shim target '$($manifest.bin)' does not match '$filename'."
        }
    }

    It 'points the shortcut at the downloaded executable' {
        $filename = [System.IO.Path]::GetFileName(
            ([Uri]$manifest.architecture.'64bit'.url).AbsolutePath
        )
        if ($manifest.shortcuts[0][0] -ne $filename) {
            throw "Shortcut target '$($manifest.shortcuts[0][0])' does not match '$filename'."
        }
    }

    It 'updates download, shim and shortcut targets together' {
        $scoopHome = $env:SCOOP_HOME
        if (!$scoopHome) { $scoopHome = scoop prefix scoop }
        . "$scoopHome/lib/core.ps1"
        . "$scoopHome/lib/manifest.ps1"
        . "$scoopHome/lib/autoupdate.ps1"

        $substitutions = Get-VersionSubstitution '9.8.7'
        $null = Update-ManifestProperty -Manifest $manifest `
            -Property @('url', 'bin', 'shortcuts') `
            -Version '9.8.7' -Substitutions $substitutions

        if ($manifest.architecture.'64bit'.url -ne 'https://erki.lap.ee/downloads/h3sed/h3sed_9.8.7.exe') {
            throw "Unexpected updated download URL: $($manifest.architecture.'64bit'.url)"
        }
        if ($manifest.bin -ne 'h3sed_9.8.7.exe') {
            throw "Shim still targets '$($manifest.bin)' after autoupdate."
        }
        if ($manifest.shortcuts[0][0] -ne 'h3sed_9.8.7.exe') {
            throw "Shortcut still targets '$($manifest.shortcuts[0][0])' after autoupdate."
        }
        if ($manifest.shortcuts[0][1] -ne 'H3sed') {
            throw "Unexpected updated shortcut name: $($manifest.shortcuts[0][1])"
        }
    }
}
