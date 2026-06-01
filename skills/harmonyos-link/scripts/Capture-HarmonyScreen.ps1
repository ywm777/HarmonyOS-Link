param(
  [string]$Device,
  [string]$OutputDir = (Join-Path (Get-Location) '.codex-screenshots'),
  [string]$Name = ("screen_{0:yyyyMMdd_HHmmss}.jpeg" -f (Get-Date)),
  [string]$HdcPath,
  [int]$DisplayId = 0
)

$ErrorActionPreference = 'Stop'

if (-not $HdcPath) {
  $HdcPath = & "$PSScriptRoot\Find-HarmonyHdc.ps1"
}

if (-not $Device) {
  $Device = (& "$PSScriptRoot\List-HarmonyTargets.ps1" -HdcPath $HdcPath | Select-Object -First 1)
}

if (-not $Device) {
  throw 'No HarmonyOS target found. Start an emulator or connect a device, then run hdc list targets.'
}

if (-not $Name.EndsWith('.jpeg', [System.StringComparison]::OrdinalIgnoreCase)) {
  $Name = [System.IO.Path]::GetFileNameWithoutExtension($Name) + '.jpeg'
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$remote = "/data/local/tmp/$Name"
$local = Join-Path $OutputDir $Name

& $HdcPath -t $Device shell "snapshot_display -i $DisplayId -f $remote"
& $HdcPath -t $Device file recv $remote $local

(Resolve-Path -LiteralPath $local).Path
