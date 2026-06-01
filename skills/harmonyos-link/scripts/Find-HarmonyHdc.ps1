param(
  [string[]]$SearchRoots = @()
)

$ErrorActionPreference = 'Stop'

function Add-Candidate {
  param([System.Collections.Generic.List[string]]$List, [string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) { return }
  if (-not $List.Contains($Path)) { [void]$List.Add($Path) }
}

$candidates = [System.Collections.Generic.List[string]]::new()

if ($env:HDC_PATH) {
  Add-Candidate $candidates $env:HDC_PATH
}

$cmd = Get-Command hdc -ErrorAction SilentlyContinue
if ($cmd) {
  Add-Candidate $candidates $cmd.Source
}

$sdkRoots = @(
  $env:DEVECO_SDK_HOME,
  $env:OpenHarmony_SDK_HOME,
  $env:HarmonyOS_SDK_HOME,
  (Join-Path $env:LOCALAPPDATA 'Huawei\Sdk'),
  'D:\APP\DevEco Studio\sdk',
  'C:\Program Files\Huawei\DevEco Studio\sdk',
  'C:\Program Files (x86)\Huawei\DevEco Studio\sdk'
) + $SearchRoots

foreach ($root in $sdkRoots) {
  if ([string]::IsNullOrWhiteSpace($root)) { continue }
  Add-Candidate $candidates (Join-Path $root 'default\openharmony\toolchains\hdc.exe')
  Add-Candidate $candidates (Join-Path $root 'openharmony\toolchains\hdc.exe')
  Add-Candidate $candidates (Join-Path $root 'toolchains\hdc.exe')
}

foreach ($candidate in $candidates) {
  if (Test-Path -LiteralPath $candidate -PathType Leaf) {
    (Resolve-Path -LiteralPath $candidate).Path
    exit 0
  }
}

$recursiveRoots = @(
  (Join-Path $env:LOCALAPPDATA 'Huawei'),
  'D:\APP',
  'C:\Program Files\Huawei',
  'C:\Program Files (x86)\Huawei'
) + $SearchRoots | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) }

foreach ($root in $recursiveRoots | Select-Object -Unique) {
  $match = Get-ChildItem -LiteralPath $root -Recurse -Filter hdc.exe -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match '\\openharmony\\toolchains\\hdc\.exe$|\\toolchains\\hdc\.exe$' } |
    Select-Object -First 1
  if ($match) {
    $match.FullName
    exit 0
  }
}

Write-Error 'Unable to locate hdc.exe. Set HDC_PATH or DEVECO_SDK_HOME, or install DevEco Studio SDK toolchains.'
exit 1
