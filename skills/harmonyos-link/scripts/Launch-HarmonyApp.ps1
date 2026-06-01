param(
  [Parameter(Mandatory = $true)]
  [string]$BundleName,
  [Parameter(Mandatory = $true)]
  [string]$AbilityName,
  [string]$Device,
  [string]$HdcPath,
  [switch]$ForceStop
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

if ($ForceStop) {
  & $HdcPath -t $Device shell "aa force-stop $BundleName"
}

& $HdcPath -t $Device shell "aa start -b $BundleName -a $AbilityName"
