param(
  [Parameter(Mandatory = $true)]
  [string]$HapPath,
  [string]$Device,
  [string]$HdcPath
)

$ErrorActionPreference = 'Stop'

if (-not $HdcPath) {
  $HdcPath = & "$PSScriptRoot\Find-HarmonyHdc.ps1"
}

if (-not $Device) {
  $Device = (& "$PSScriptRoot\List-HarmonyTargets.ps1" -HdcPath $HdcPath | Select-Object -First 1)
}

if (-not (Test-Path -LiteralPath $HapPath -PathType Leaf)) {
  throw "HAP not found: $HapPath"
}

if (-not $Device) {
  throw 'No HarmonyOS target found.'
}

& $HdcPath -t $Device install -r $HapPath
