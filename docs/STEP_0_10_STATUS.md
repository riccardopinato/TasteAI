# TasteAI Flutter v0.10 — Premium Engine

## Implemented

- RevenueCat Flutter SDK integration through `purchases_flutter 10.13.2`.
- No fake or local Premium unlock.
- Public SDK key supplied only at build/release time with `TASTEAI_REVENUECAT_API_KEY`.
- Entitlement ID supplied with `TASTEAI_REVENUECAT_ENTITLEMENT`, default `plus`.
- Plus access is granted only when RevenueCat returns an active entitlement.
- Offering packages and localized price strings come from the store.
- Real purchase and restore flows.
- Premium recipes remain discoverable, but opening one without Plus routes to the Premium screen.
- Search and Anti-Waste remain part of the useful Free core.
- Optional Local AI is positioned as a future Plus capability only after v0.8B certification.
- Automatic device identifier collection is disabled in the RevenueCat configuration.
- Web Preview stays usable, but store purchase/restore is not presented as supported where the SDK documents limitations.

## Production certification still required

Before shipping purchases:
- create the RevenueCat project;
- connect Google Play / App Store products;
- configure the `plus` entitlement and Offering;
- provide the public SDK key at build time;
- test purchases, cancellation and restore using real store sandboxes.

Until those values exist, TasteAI truthfully remains Free instead of simulating Premium.
