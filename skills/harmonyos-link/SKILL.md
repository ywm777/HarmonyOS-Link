---
name: harmonyos-link
description: "Use when working with HarmonyOS ArkTS projects that need a closed loop: edit code, build with DevEco/Hvigor, install to a running emulator or device through hdc, launch the app, capture screenshots, visually inspect, then iterate. Also use when diagnosing HarmonyOS build, install, launch, screenshot, or hilog flows."
---

# HarmonyOS Link

Use this skill for HarmonyOS UI and runtime iteration:

```text
inspect project -> edit code -> build -> install -> launch -> screenshot -> visually inspect -> adjust
```

## Data Policy

Keep this skill free of project-specific and business-specific data.

Do not store:

- bundle names, ability names, product names, page names, route names, coordinates, or UI copy from a specific project
- local workspace paths, generated artifact paths, emulator IDs, or machine-specific SDK paths
- certificates, passwords, keys, tokens, account identifiers, cookies, API secrets, or entitlement material
- business rules, domain models, mock data, user data, addresses, map locations, route names, or analytics values

Read those values from the active project or current environment each time the skill is used.

## Core Rules

- Prefer command-line DevEco/Hvigor and hdc over GUI clicking when a reproducible loop is needed.
- Discover tool paths from the active environment, PATH, SDK environment variables, or documented project configuration.
- Discover the app bundle and launch ability from the active project's app/module configuration.
- Build before installing after code changes.
- Install the signed HAP when both signed and unsigned artifacts are emitted.
- If installation fails with sign information inconsistency, uninstall the old package once, then reinstall the freshly built signed HAP.
- Capture a screenshot after launching before assuming which screen is visible.
- For animation checks, capture multiple screenshots separated by 300-800 ms.
- Keep screenshots inside a temporary verification folder in the active workspace.
- Report exact build, install, launch, and screenshot status when finishing.

## Discover Project Values

Before build/install/launch, determine these values from the active project:

```text
workspace root
Hvigor command or wrapper
hdc executable
connected target
signed HAP path
bundle name
main ability name
```

Common places to inspect:

```text
AppScope/app.json5
entry/src/main/module.json5
build-profile.json5
entry/build/**/outputs/**/*.hap
```

## Build

Use the repository's existing build command when documented. For DevEco/Hvigor projects, a typical module build is:

```powershell
& '<hvigor-wrapper>' assembleHap --mode module -p module=<module-name> --no-daemon --no-incremental
```

If the SDK environment is not available to Hvigor, set temporary process-level SDK environment variables for the current command only. Do not permanently modify system environment variables unless the user asks.

Expected success marker:

```text
BUILD SUCCESSFUL
```

## Install And Launch

After a successful build, install the signed HAP and launch the main ability:

```powershell
$hdc = '<path-to-hdc>'
$device = '<target-id>'
$hap = '<path-to-signed-hap>'
$bundle = '<bundle-name>'
$ability = '<main-ability-name>'

& $hdc -t $device shell aa force-stop $bundle
& $hdc -t $device install -r $hap
& $hdc -t $device shell aa start -b $bundle -a $ability
```

Expected success markers:

```text
install bundle successfully
start ability successfully
```

If install fails with sign information inconsistency:

```powershell
& $hdc -t $device shell bm uninstall -n $bundle
& $hdc -t $device install -r $hap
& $hdc -t $device shell aa start -b $bundle -a $ability
```

## Capture Screenshots

Capture as JPEG unless the target is known to support PNG:

```powershell
New-Item -ItemType Directory -Force -Path '.codex-screenshots' | Out-Null
& $hdc -t $device shell snapshot_display -f /data/local/tmp/current.jpeg
& $hdc -t $device file recv /data/local/tmp/current.jpeg '.codex-screenshots/current.jpeg'
```

For animation validation:

```powershell
foreach ($i in 1..4) {
  Start-Sleep -Milliseconds 500
  & $hdc -t $device shell snapshot_display -f "/data/local/tmp/frame_$i.jpeg" | Out-Null
  & $hdc -t $device file recv "/data/local/tmp/frame_$i.jpeg" ".codex-screenshots/frame_$i.jpeg" | Out-Null
}
```

Inspect screenshots visually before making the next UI decision.

## Navigation

Use `hdc shell uitest uiInput` only after a screenshot confirms the target coordinates:

```powershell
& $hdc -t $device shell uitest uiInput click <x> <y>
```

Do not store project-specific coordinates in this skill. Recalculate from the current screenshot each time.

## Diagnostics

When build fails:

- read the first real Hvigor or ArkTS compiler error
- fix that error before doing visual work
- avoid stacking UI changes on top of an unbuildable state

When install or launch fails:

- confirm the target is online
- confirm the HAP path exists
- confirm the bundle and ability are read from the active project
- check for sign information inconsistency
- collect recent hilog if the failure is not obvious

When runtime behavior is wrong:

- capture the screen first
- collect targeted hilog output for the running app process
- compare the live screen against the current source entry point, not stale generated build files
