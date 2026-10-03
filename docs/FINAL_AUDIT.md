# TasteAI v0.13 — Final UX / Accessibility / Performance Audit

## Audit scope

Static product/code audit against the current App Factory quality rules: core usability, small/large screens, accessible controls, large text, performance headroom, platform portability, monetization integrity, local-first behavior and release readiness.

## Findings resolved

### P1 — Desktop/Web layout was over-wide

**Before:** phone layouts were stretched across large Web windows.

**Fix:** shared `TasteContentFrame` caps reading/content width while preserving full-height scrolling. Main navigation switches from bottom `NavigationBar` to `NavigationRail` from 900 px upward.

### P1 — Favorite action target was compact

**Before:** recipe-card favorite icon explicitly used compact visual density.

**Fix:** compact density removed; app theme enforces padded Material tap targets and 48 dp minimum button height. Favorite actions now expose state-specific tooltips.

### P2 — Search accessibility feedback

**Before:** clear-search action had no explicit tooltip and dynamic result count was not announced as a live region.

**Fix:** localized clear-search tooltip, visible field label, live result-count semantics and a stronger empty state.

### P2 — Large-text resilience

**Before:** three time values were forced into a single row and section headers could become fragile under large accessibility text.

**Fix:** time metadata uses a wrapping layout; section headings use flexible width. A widget test runs recipe detail at 320×640 with 2× text scaling.

### P1 — Flutter platform parity

**Before:** Android/Web were validated but iOS was not materialized or built.

**Fix:** CI now generates/persists the iOS scaffold and a macOS runner executes `flutter build ios --release --no-codesign`.

### P2 — Future catalog scale

The planned PDF import can grow the catalog well beyond the current 111 recipes.

**Fix:** CI includes a 1,500-recipe retrieval contract test to ensure the unified index/search path still returns the correct grounded result at the intended near-term catalog size.

## Internal release-core verdict

**CERTIFIED only after the v0.13 CI run is completely green** across:
- analyze;
- tests + coverage;
- cloud-AI/model-weight guardrails;
- Android APK;
- Android AAB;
- Web;
- iOS no-codesign.

## External/native gates intentionally not certified

These require credentials, store/native setup or physical-device evidence and are not simulated:

- Needle 3 native wrapper/model pack and real-device benchmark;
- Google production OAuth clients + Android signing fingerprints + real Drive backup test;
- RevenueCat products/Offering/store sandbox purchase + restore;
- Android production keystore and signed tag release;
- App Store signing/distribution;
- final store metadata, screenshots, privacy/data-safety forms.

No external gate is allowed to masquerade as completed in development builds.
