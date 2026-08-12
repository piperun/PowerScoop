Describe 'Chenron manifest' {
    BeforeAll {
        $manifest = Get-Content "$PSScriptRoot/bucket/chenron.json" -Raw |
            ConvertFrom-Json
    }

    It 'delegates release detection to Scoop GitHub handling' {
        $propertyCount = @($manifest.checkver.PSObject.Properties.Name).Count
        if ($propertyCount -ne 1) {
            throw "Expected one checkver property, found $propertyCount."
        }
        if ($manifest.checkver.github -ne 'https://github.com/piperun/chenron') {
            throw "Unexpected Chenron checkver repository: $($manifest.checkver.github)"
        }
    }

    It 'builds downloads from v-prefixed release tags' {
        $url = $manifest.autoupdate.architecture.'64bit'.url.Replace(
            '$version',
            '9.8.7'
        )

        $expectedUrl = 'https://github.com/piperun/chenron/releases/download/v9.8.7/chenron-9.8.7-windows-x64.zip'
        if ($url -ne $expectedUrl) {
            throw "Expected autoupdate URL '$expectedUrl', found '$url'."
        }
    }
}
