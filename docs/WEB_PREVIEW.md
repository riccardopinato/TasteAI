# TasteAI Web Preview

The Flutter Web release is published by GitHub Actions to the `gh-pages` branch.

Stable target URL:

`https://riccardopinato.github.io/TasteAI/`

The workflow does not upload a generic Actions artifact. It force-updates the dedicated `gh-pages` Git branch, avoiding routine artifact-storage accumulation.

## One-time GitHub Pages setting

If Pages is not already enabled:

1. Open repository **Settings -> Pages**.
2. Choose **Deploy from a branch**.
3. Select branch **gh-pages** and folder **/(root)**.
4. Save.

The Web Preview validates UI, navigation, catalog, search, Anti-Waste, favorites and settings. Store purchases and some account flows remain platform-specific.
