# TasteAI Release Checklist

## Core gates

- [ ] `flutter analyze` passes.
- [ ] Full Flutter test suite passes.
- [ ] Android ARM64 APK builds.
- [ ] Android AAB builds.
- [ ] Web release builds.
- [ ] Release size report reviewed.
- [ ] Canonical catalog quality test passes.
- [ ] UI locale key parity passes.
- [ ] No Gemini runtime/API-key residue in Flutter source.
- [ ] No local model weights bundled in the base app.

## Android production

- [ ] Application ID confirmed as `com.riccardopinato.tasteai`.
- [ ] Production keystore configured outside Git.
- [ ] AAB signed with production key.
- [ ] Version/code updated for store release.
- [ ] Google Play Data Safety reviewed.

## Google account / backup

- [ ] Android OAuth client created for final package + production SHA fingerprints.
- [ ] Web OAuth client configured if interactive web account support is shipped.
- [ ] Google Drive API enabled.
- [ ] Sign-in tested on a physical Android device.
- [ ] Backup and restore tested with real `appDataFolder`.

## TasteAI Plus / RevenueCat

- [ ] RevenueCat project connected to Play/App Store.
- [ ] `plus` entitlement exists.
- [ ] Current Offering contains intended monthly/lifetime products.
- [ ] Prices come from store metadata.
- [ ] Purchase cancellation leaves user Free.
- [ ] Successful purchase activates Plus.
- [ ] Restore activates only a valid entitlement.
- [ ] Sandbox purchase/restore tested on real devices.

## Optional Local AI

- [ ] Native Needle wrapper links official `libneedle.a`.
- [ ] Telemetry disabled before engine initialization.
- [ ] Model remains optional/downloadable.
- [ ] On-device RAM, startup, latency and battery benchmark recorded.
- [ ] TasteAI intent/reranking benchmark passes target quality.
- [ ] App remains fully functional when model is absent or unsupported.

## Final

- [ ] Privacy policy reflects shipped integrations.
- [ ] Open-source notices/licenses reviewed.
- [ ] Web Preview deployed.
- [ ] Release notes updated.
- [ ] No blocker marked NOT CERTIFIED remains for a feature advertised as available.
