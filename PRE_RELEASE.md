# Color OTD — Pre-release notes

Deferred work to revisit before App Store submission. Do not implement during the current scaffold pass.

## Monetization

### Premium subscription
- Surface on **Profile** under a new "Premium" group at the top (above Daily colour / Display / About).
- Paywall 2–3 of the 6 lenses for free-tier users. Candidate gates: **Etymology**, **Symbolism**, **Pop Culture**. (Art History, Fashion, Nature stay free — those carry the strongest "color story" hook.)
- Free-tier UX: lens index rows render normally on Today / ColorDetail; tapping a paywalled lens opens an **upgrade sheet** instead of pushing CategoryDetail.
- A small "Premium" pill should render next to paywalled lens row labels so users see the gating before they tap.
- Tiers to decide: monthly + annual + lifetime? Lifetime fits the contemplative, ad-free brand.
- StoreKit 2 integration (`Product.products(for:)`, `Transaction.updates`). Add a `SubscriptionService` protocol in `Repo/Factory/` + memory + StoreKit implementations following the existing pattern.
- Restore-purchases path is required by App Review.
- Receipt-verification: do it via `Transaction.currentEntitlements` (no server needed for individual app, but if we want cross-device sync the Cloud Functions API can add a `/v1/me/entitlements` endpoint).

### Buy Me a Coffee
- Surface on **Profile**, either:
  - (a) New "Support" group with a single row, *or*
  - (b) Inside the existing "About" group as a tappable row.
- Implementation choice — pick one:
  - **External URL** to a buymeacoffee.com page (simplest, no IAP friction)
  - **Consumable IAPs** at $1 / $3 / $5 (keeps everything in-app; allows multiple tips)
- If consumable IAPs: thank-you sheet after purchase, no entitlement granted.

### Interstitial ads
- Free-tier only, premium subscribers see no ads.
- Considered placements:
  - Between CategoryDetail entries (after entry 1 of 3)
  - Before opening ColorDetail from Archive / Search (max once per session)
- **Risk:** breaks the contemplative editorial tone. Validate with a small user test first.
- Frequency cap aggressively: ≤ 1/day per user, never within 60s of session start, never on Today.
- Networks to investigate: Google AdMob (largest fill), Apple Search Ads / iAd revival, Vungle for editorial-friendly creatives.
- Track impact on subscription conversion — if it cannibalizes subs, drop it.

## Other pre-release work

- **Real lens content** for all 16+ archive colors. Currently only Prussian Blue ships a full corpus; everything else falls back to `BundledData.placeholderLenses`.
- **Real imagery** for lens entries. Currently `StripePlaceholder` is used everywhere — the design treats this as a finished treatment but we'd want at least some hero shots per color.
- **App icon + launch screen** assets.
- **Onboarding** flow (first launch only): explain the daily cadence, ask for notification permission with intent.
- **App Store** screenshots + metadata + age rating + privacy questionnaire.
- **Privacy manifest** (`NSPrivacyAccessedAPITypes`) — required by App Review since 2024.
- **Localization** — the editorial tone makes this expensive; ship English-only at launch.
- **Daily-color content pipeline** — who owns curating future colors? Editorial workflow needs spec.
