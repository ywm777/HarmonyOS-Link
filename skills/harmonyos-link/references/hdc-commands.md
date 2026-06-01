# HDC Commands

Use these commands through the scripts first. Fall back to raw `hdc` only when the scripts do not cover the case.

```powershell
hdc list targets
hdc -t <device> shell param get const.product.model
hdc -t <device> shell snapshot_display -f /data/local/tmp/screen.jpeg
hdc -t <device> file recv /data/local/tmp/screen.jpeg .codex-screenshots\screen.jpeg
hdc -t <device> install -r path\to\entry-default-unsigned.hap
hdc -t <device> shell aa force-stop <bundle>
hdc -t <device> shell aa start -b <bundle> -a <ability>
hdc -t <device> shell uitest uiInput click <x> <y>
hdc -t <device> shell hilog -x
```

Some HarmonyOS emulator images reject `.png` output from `snapshot_display`; prefer `.jpeg`.
