# Visual QA Workflow

Use a closed loop for HarmonyOS UI work:

1. Read the relevant ArkTS/ETS files and identify the smallest visual change.
2. Build with the repository's existing DevEco/Hvigor command.
3. Install the generated HAP.
4. Launch the target bundle and ability.
5. Capture a screenshot with `Capture-HarmonyScreen.ps1`.
6. Inspect the screenshot before deciding whether the UI matches the target.
7. Repeat after each visual adjustment.

For animations or transient states, capture 2-4 screenshots separated by 300-800 ms.

Do not declare visual work complete from code inspection alone when an emulator or device is connected.
