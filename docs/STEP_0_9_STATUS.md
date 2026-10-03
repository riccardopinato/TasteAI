# TasteAI Flutter v0.9 — Profile & Google Drive Sync

## Implemented

- Guest/local-first remains the default mode.
- Google Sign-In is optional and never blocks app startup.
- OAuth identifiers are supplied at release time with `TASTEAI_GOOGLE_CLIENT_ID` and `TASTEAI_GOOGLE_SERVER_CLIENT_ID`.
- No OAuth client secret is stored in the repository.
- Google Sign-In v7 API is used.
- Drive authorization is requested only when the user presses Backup/Restore.
- Backup uses Google Drive `appDataFolder`.
- Backup payload v1 contains favorites, units preference and selected language.
- Restore filters stale favorite IDs against the installed catalog.
- No Firebase dependency is required.

Production authentication still requires real OAuth clients, Android signing SHA fingerprints and final package identifiers.

Core implementation complete. Production OAuth certification remains pending credentials.
