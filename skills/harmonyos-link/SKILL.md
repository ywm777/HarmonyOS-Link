---
name: harmonyos-link
description: Connect Codex to HarmonyOS and DevEco Studio projects through hdc. Use when working with HarmonyOS, OpenHarmony, ArkUI, ArkTS, DevEco Studio, Hvigor builds, HAP install flows, emulator or device screenshots, hilog debugging, app launch automation, visual UI verification, or iterative UI adjustment that should be checked on a live HarmonyOS simulator or device.
---

# HarmonyOS Link

Use this skill to create a live feedback loop for HarmonyOS work:

```text
inspect project -> build -> install -> launch -> screenshot -> visually inspect -> adjust
```

## Core Rules

- Do not rely on code inspection alone for visual UI work when a HarmonyOS emulator or device is available.
- Prefer the scripts in `scripts/` before writing one-off `hdc` commands.
- Auto-detect `hdc`; do not hardcode a user-specific DevEco path unless the user explicitly provides one.
- Capture screenshots as `.jpeg`; some emulator images reject `.png` for `snapshot_display`.
- Save generated screenshots under `.codex-screenshots/` in the active workspace.
- Report exact build, install, launch, and screenshot paths when finishing a task.

## Scripts

Run PowerShell scripts from this skill directory or by absolute path:

- `scripts/Find-HarmonyHdc.ps1`: locate `hdc.exe` from `HDC_PATH`, PATH, SDK environment variables, and common DevEco locations.
- `scripts/List-HarmonyTargets.ps1`: list connected HarmonyOS emulator/device targets.
- `scripts/Capture-HarmonyScreen.ps1`: capture a live screenshot and pull it into the workspace.
- `scripts/Install-HarmonyHap.ps1`: install a `.hap` file to a selected target.
- `scripts/Launch-HarmonyApp.ps1`: start a bundle and ability, optionally force-stopping first.
- `scripts/Collect-HarmonyHilog.ps1`: collect recent `hilog` output into a local log file.

## Standard Workflow

1. Inspect the project layout and existing build commands. For DevEco layout reminders, read `references/deveco-project-layout.md`.
2. Locate `hdc`:

```powershell
& '<skill>\scripts\Find-HarmonyHdc.ps1'
```

3. Confirm the emulator or device:

```powershell
& '<skill>\scripts\List-HarmonyTargets.ps1'
```

4. Build with the repository's existing command. Prefer project-specific scripts or documented Hvigor commands over guessing.
5. Install the generated HAP:

```powershell
& '<skill>\scripts\Install-HarmonyHap.ps1' -HapPath '<path-to-hap>' -Device '<target>'
```

6. Launch the app:

```powershell
& '<skill>\scripts\Launch-HarmonyApp.ps1' -BundleName '<bundle>' -AbilityName '<ability>' -Device '<target>' -ForceStop
```

7. Capture and inspect the screen:

```powershell
& '<skill>\scripts\Capture-HarmonyScreen.ps1' -Device '<target>'
```

8. Use the returned local screenshot path with image inspection before deciding the next UI change.

## Diagnostics

When a build fails, fix the first real ArkTS/Hvigor error before running visual checks.

When install or launch fails:

```powershell
& '<skill>\scripts\Collect-HarmonyHilog.ps1' -Device '<target>'
```

For raw `hdc` command examples, read `references/hdc-commands.md`.

For visual iteration expectations, read `references/visual-qa-workflow.md`.

## Task Notes

- For animations or transient UI states, capture several frames separated by 300-800 ms.
- For touch navigation, use `hdc shell uitest uiInput click x y` only after a screenshot confirms the target coordinates.
- If multiple targets are connected, ask the user which target to use unless one is clearly specified.
- If no target is connected, explain that the skill can still inspect and build the project, but cannot complete visual verification.
