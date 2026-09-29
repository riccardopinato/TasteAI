# TasteAI Flutter v0.11 — Release Hardening

## Cleanup

- Removed the obsolete Kotlin/Jetpack Compose application tree from the Flutter branch.
- Removed old Gradle root files belonging to the Kotlin application.
- Removed the legacy Gemini environment/template residue.
- Removed the superseded v0.3 `RecipeSearchEngine` and its tests.
- Git history remains the archive for the previous Kotlin implementation.

## Quality gates

- Canonical catalog contract validates 111 unique ready recipes.
- Expected anti-waste and Premium catalog counts are pinned.
- UI localization key parity is tested across EN/IT/ES/FR/PT.
- Flutter tests run with coverage.
- CI rejects Gemini/cloud-AI runtime residue.
- CI rejects bundled model weight files in the base app.

## Release outputs

CI now builds:
- Android ARM64 APK;
- Android AAB;
- Flutter Web release;
- release-size report.

The Android application ID is normalized to `com.riccardopinato.tasteai`.

## Repository hardening

The first v0.11 CI run persists the generated Flutter `android/` scaffold back to the branch, removing the long-term dependency on an ephemeral CI-only scaffold.

## Remaining external certification gates

- v0.8B Needle native wrapper + real-device benchmark.
- v0.9B Google production OAuth credentials.
- v0.10B RevenueCat/store sandbox configuration.
- Production signing and store metadata.
- Stable Web Preview deployment.

Internal Flutter release core can be CERTIFIED once the v0.11 CI gate is green.
