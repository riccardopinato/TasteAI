# TasteAI — Flutter CI immutable SDK baseline, 12 November 2026

GitHub Actions `TasteAI Flutter CI` failed on [main@61e544b](https://github.com/riccardopinato/TasteAI/commit/61e544b4716cd9a3e524d6a0ff3f989fb25e9237) in [run #43327327332](https://github.com/riccardopinato/TasteAI/actions/runs/43327327332), Linux **Analyze** step, because the unpinned `channel: stable` selected Flutter **3.50.0** on 2026-11-12. The toolchain reports 17 info diagnostics for `material.dart` and localization API deprecated in Flutter newer than the release toolchain, causing `flutter analyze` to fail. This is a version-drift issue; none of those 17 diagnostics refer to the pinned Factory profile kit.

**Repair:** pin Flutter `3.47.5` in both Linux and macOS jobs and enable exact-head PR trigger, so a future unreviewed stable upgrade cannot silently break CI. This is the same toolchain as [TasteAI source profile gate #6](https://github.com/riccardopinato/TasteAI/pull/6), which passed analyze/full tests/web build. No app source, pinned dependency, product state, Store credentials, billing, ads or user data is changed.

**Deferred**: a separately scoped compatibility migration to Flutter 3.50+ and `material_ui` may be planned after library/API readiness; do not change multiple production widgets or grant a fake release PASS merely to silence new SDK diagnostics.

**Gate**: run both Linux (analyze/test/Android AAB/APK/web build) and macOS iOS no-codesign checks on PR HEAD. This remains source/CI; physical/Play/native provider gates remain independent.
