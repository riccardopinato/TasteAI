# TasteAI Privacy & Data Architecture

## Local-first data

The canonical recipe catalog, search index, favorites and app settings are usable without an account. Core recipe search and Anti-Waste do not require a network connection.

## Cloud AI

TasteAI v1.0 has no Gemini runtime and no mandatory cloud LLM. CI rejects Gemini API-key/runtime references in Flutter source.

## Local AI

The Local Intelligence Runtime defaults to no model. Future Needle 3 support is optional, local-only and downloadable. Model weights are not bundled in the base application. A provider is rejected if local-only execution or telemetry opt-out cannot be guaranteed.

## Google account

Google Sign-In is optional. Without OAuth configuration the app remains in guest mode.

If the user explicitly requests backup or restore, TasteAI requests the Google Drive `drive.appdata` scope and stores only the TasteAI backup payload in the private app-data folder.

Backup v1 contains:
- favorite recipe IDs;
- unit preference;
- language preference;
- backup timestamp.

The canonical recipe catalog is not uploaded because it is distributed with the app.

## Purchases

TasteAI Plus uses RevenueCat only when a public RevenueCat SDK key is configured. Premium access is derived from the active `plus` entitlement; there is no local fake-unlock flag.

## Secrets

OAuth client secrets, private store credentials and private API secrets must never be committed. Public mobile SDK/client identifiers are supplied at release time through build configuration.
