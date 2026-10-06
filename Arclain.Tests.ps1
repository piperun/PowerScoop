Describe 'Arclain manifest' {
    It 'updates the ZIP extraction folder with the release' {
        $manifest = Get-Content "$PSScriptRoot/bucket/archive-tools/arclain.json" -Raw |
            ConvertFrom-Json
        $scoopHome = $env:SCOOP_HOME
        if (!$scoopHome) { $scoopHome = scoop prefix scoop }
        . "$scoopHome/lib/core.ps1"
        . "$scoopHome/lib/manifest.ps1"
        . "$scoopHome/lib/autoupdate.ps1"

        $substitutions = Get-VersionSubstitution '9.8.7'
        $null = Update-ManifestProperty -Manifest $manifest `
            -Property @('url', 'extract_dir') `
            -Version '9.8.7' -Substitutions $substitutions

        if ($manifest.architecture.'64bit'.url -ne 'https://codeberg.org/0xdev/Arclain/releases/download/9.8.7/arclain-9.8.7-windows-x64.zip') {
            throw "Unexpected updated download URL: $($manifest.architecture.'64bit'.url)"
        }
        if ($manifest.architecture.'64bit'.extract_dir -ne 'arclain-9.8.7-windows-x64') {
            throw "Unexpected updated extraction folder: $($manifest.architecture.'64bit'.extract_dir)"
        }
        $checksumUrl = substitute $manifest.autoupdate.hash.url $substitutions
        if ($checksumUrl -ne 'https://codeberg.org/0xdev/Arclain/releases/download/9.8.7/arclain-9.8.7-windows-x64.zip.sha256') {
            throw "Unexpected updated checksum URL: $checksumUrl"
        }
        if ($manifest.bin -ne 'arclain.exe' -or $manifest.shortcuts[0][0] -ne 'arclain.exe') {
            throw 'The extracted executable must remain the shim and shortcut target.'
        }
    }
}
