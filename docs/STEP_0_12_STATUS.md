# TasteAI Flutter v0.12 — Web Preview & Release Automation

## Web

- Dedicated Web Preview workflow.
- Uses the current Flutter stable channel.
- Builds with repository base href `/TasteAI/`.
- Publishes directly to the `gh-pages` branch.
- No recurring generic Actions artifact is retained.

## Android release

- Production signing support added to Gradle using `android/key.properties`.
- Normal CI keeps using debug signing when release credentials are absent.
- Tag-triggered production release refuses to run without signing secrets.
- Analyze and tests run again on the tagged commit.
- Google OAuth and RevenueCat public configuration are injected at build time.
- Signed ARM64 APK and AAB are attached directly to the GitHub Release.

## Cleanup

- Android namespace/applicationId/package are normalized to `com.riccardopinato.tasteai`; the source folder keeps Flutter's generated `taste_ai` project path.
- Version advanced to 0.12.0+12.

## Remaining external setup

- Enable GitHub Pages from `gh-pages` once if not already configured.
- Add Android production signing secrets.
- Add production Google OAuth configuration.
- Add RevenueCat/store production configuration.
- Complete Needle 3 native on-device certification.
