param(
  [string]$HdcPath
)

$ErrorActionPreference = 'Stop'

if (-not $HdcPath) {
  $HdcPath = & "$PSScriptRoot\Find-HarmonyHdc.ps1"
}

if (-not (Test-Path -LiteralPath $HdcPath -PathType Leaf)) {
  throw "hdc.exe not found: $HdcPath"
}

$targets = & $HdcPath list targets
$targets |
  Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
  ForEach-Object { $_.Trim() }
