# HarmonyOS Link

HarmonyOS Link is a Codex Skill for HarmonyOS and DevEco Studio projects. It connects Codex to `hdc`, detects emulators or devices, installs HAP files, launches apps, captures live screenshots, and collects `hilog` output so UI work can be verified on a real HarmonyOS target.

## Install

After publishing this repository to GitHub, install with Codex:

```text
$skill-installer install https://github.com/<owner>/<repo>/tree/main/skills/harmonyos-link
```

Or from a repository path:

```text
$skill-installer install --repo <owner>/<repo> --path skills/harmonyos-link
```

Restart Codex after installation.

## What It Includes

- `Find-HarmonyHdc.ps1`: locate `hdc.exe`
- `List-HarmonyTargets.ps1`: list HarmonyOS devices and emulators
- `Capture-HarmonyScreen.ps1`: capture and pull screenshots
- `Install-HarmonyHap.ps1`: install `.hap` files
- `Launch-HarmonyApp.ps1`: start a bundle and ability
- `Collect-HarmonyHilog.ps1`: collect recent `hilog`

## Requirements

- Windows
- DevEco Studio or OpenHarmony/HarmonyOS SDK toolchains
- `hdc.exe`
- A running HarmonyOS emulator or connected device for live visual verification

## License

MIT
