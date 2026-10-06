# Scoop Bucket Template

<!-- Uncomment the following line after replacing placeholders -->
<!-- [![Tests](https://github.com/<username>/<bucketname>/actions/workflows/ci.yml/badge.svg)](https://github.com/<username>/<bucketname>/actions/workflows/ci.yml) [![Excavator](https://github.com/<username>/<bucketname>/actions/workflows/excavator.yml/badge.svg)](https://github.com/<username>/<bucketname>/actions/workflows/excavator.yml) -->

Template bucket for [Scoop](https://scoop.sh), the Windows command-line installer.

## How do I use this template?

1. Generate your own copy of this repository with the "Use this template"
   button.
2. Allow all GitHub Actions:
   - Navigate to `Settings` - `Actions` - `General` - `Actions permissions`.
   - Select `Allow all actions and reusable workflows`.
   - Then `Save`.
3. Allow writing to the repository from within GitHub Actions:
   - Navigate to `Settings` - `Actions` - `General` - `Workflow permissions`.
   - Select `Read and write permissions`.
   - Then `Save`.
4. Document the bucket in `README.md`.
5. Replace the placeholder repository string in `bin/auto-pr.ps1`.
6. Create new manifests by copying `bucket/app-name.json.template` to
   `bucket/<app-name>.json`.
7. Commit and push changes.
8. If you'd like your bucket to be indexed on `https://scoop.sh`, add the
   topic `scoop-bucket` to your repository.

## How do I install these manifests?

After manifests have been committed and pushed, run the following:

```pwsh
scoop bucket add powerscoop https://github.com/piperun/PowerScoop
scoop install <bucketname>/<manifestname>
```

## How do I contribute new manifests?

To make a new manifest contribution, please read the [Contributing
Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md)
and [App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
wiki page.

## Tests

Install the test modules from PowerShell Gallery in the shell you will use
for testing (PowerShell 7 or Windows PowerShell 5.1):

```powershell
Install-Module -Name Pester -RequiredVersion 5.9.1 -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
Install-Module -Name BuildHelpers -RequiredVersion 2.0.16 -Repository PSGallery -Scope CurrentUser -Force
```

With Scoop installed, run the complete suite from the repository root:

```powershell
.\bin\test.ps1
```

The test runner and both CI jobs use these exact module versions. If Scoop
is checked out separately, set `SCOOP_HOME` to that checkout first.

Keep profiling output, PDB files, and private rollback scripts outside this
checkout. Scoop's style checks scan every file in the working directory,
including untracked files. They check CRLF line endings and other text
formatting, so binary diagnostic files cause false failures. Use a clean
checkout to verify the committed project without moving saved diagnostics.
