# DevEco Project Layout

Common files to inspect:

- `AppScope/app.json5`: bundle name and app-level metadata.
- `entry/src/main/module.json5`: abilities, pages, and module metadata.
- `entry/src/main/ets/`: ArkTS source.
- `entry/build/default/outputs/default/`: typical HAP output location.
- `hvigorfile.ts`, `build-profile.json5`, `oh-package.json5`: build configuration.

Common environment variables:

```powershell
$env:DEVECO_SDK_HOME='<DevEco Studio>\sdk'
$env:HarmonyOS_SDK_HOME='<DevEco Studio>\sdk\default\hms'
$env:OpenHarmony_SDK_HOME='<DevEco Studio>\sdk\default\openharmony'
```

Prefer the project's existing wrapper or documented build command. If no project command exists, inspect `hvigor` configuration before guessing task names.
