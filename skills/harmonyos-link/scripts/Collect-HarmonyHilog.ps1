param(
  [string]$Device,
  [string]$OutputDir = (Join-Path (Get-Location) '.codex-hilog'),
  [string]$Name = ("hilog_{0:yyyyMMdd_HHmmss}.log" -f (Get-Date)),
  [string]$HdcPath,
  [int]$Lines = 400
)

$ErrorActionPreference = 'Stop'

if (-not $HdcPath) {
  $HdcPath = & "$PSScriptRoot\Find-HarmonyHdc.ps1"
}

if (-not $Device) {
  $Device = (& "$PSScriptRoot\List-HarmonyTargets.ps1" -HdcPath $HdcPath | Select-Object -First 1)
}

if (-not $Device) {
  throw 'No HarmonyOS target found.'
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$local = Join-Path $OutputDir $Name

& $HdcPath -t $Device shell "hilog -x | tail -n $Lines" | Out-File -LiteralPath $local -Encoding utf8

(Resolve-Path -LiteralPath $local).Path
