param([string]$Tectonic)
$ErrorActionPreference = 'Stop'
$taskFolder = $PSScriptRoot
$buildFolder = Join-Path $taskFolder '.build'
$sourceFile = Join-Path $taskFolder 'apresentacao_sbert_contrastivo.tex'
if (-not $Tectonic) {
    $engineCommand = Get-Command tectonic -ErrorAction SilentlyContinue
    if ($engineCommand) { $Tectonic = $engineCommand.Source }
    else {
        $localEngine = Join-Path $env:USERPROFILE 'tools\latex\tectonic-0.17.0\tectonic.exe'
        if (Test-Path -LiteralPath $localEngine) { $Tectonic = $localEngine }
        else { throw 'Tectonic não encontrado. Execute .\compilar.ps1 -Tectonic "C:\caminho\tectonic.exe".' }
    }
}
New-Item -ItemType Directory -Path $buildFolder -Force | Out-Null
& $Tectonic --keep-logs --keep-intermediates --outdir $buildFolder $sourceFile
if ($LASTEXITCODE -ne 0) { throw "Compilação falhou, código $LASTEXITCODE." }
Copy-Item -LiteralPath (Join-Path $buildFolder 'apresentacao_sbert_contrastivo.pdf') -Destination $taskFolder
Copy-Item -LiteralPath (Join-Path $buildFolder 'apresentacao_sbert_contrastivo.log') -Destination $taskFolder
Write-Host 'PDF atualizado em' $taskFolder
