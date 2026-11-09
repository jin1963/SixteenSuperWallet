# SIXTEEN CURRENCY V3 — Premium Black & Gold (Preview)

## Preview
https://jin1963.github.io/SixteenSuperWallet/sixteen-currency-premium-v3/

## Source
https://github.com/jin1963/SixteenSuperWallet/blob/main/sixteen-currency-premium-v3/index.html

## Design
- Preserves the original SIXTEEN CURRENCY black-and-gold hero, S emblem, header, wallet connection modal, and ecosystem cards.
- Rebuilds the integrated wallet dashboard in the same black-and-gold visual system.
- Responsive layouts for laptop and mobile.
- BNB and STC in the original Wallet Overview; NC, THBC, STC, USDT in the unified Assets section.

## Read-only integration
- PancakeSwap V2 indicative NC/USDT and THBC/USDT pool rates.
- NC Staking V5, NC Whale Staking V12.
- NC Reward Core and Reward Staking V1.
- THBC Whale Reward (500-day).
- One MetaMask/TokenPocket wallet connection, reused via the `sixteen:wallet` event.
- No new smart-contract write methods, wallet signatures, approvals, or token transfers.

## Deployment safety
1. Do not overwrite `sixteen-currency-v1/index.html` or the old `sixteen-currency-integrated-v2/index.html`.
2. Verify wallet provider selection on MetaMask desktop and TokenPocket mobile.
3. Test wallet balances and contract data against the existing DApps for an account with stakes and an account without stakes.
4. Verify the NC Reward and THBC Reward links before production.
5. Validate responsive display and market rate updates in the live hosted site.
6. Copy this single `index.html` into a new `sixteen-currency-premium-v3` folder in `sixteeninter-ux/SixteenSuperWallet` only after testing.

## Validation scope
The generated source passed JavaScript syntax checks, HTML tag nesting checks, and a required-ID consistency check. This does **not** constitute a live-wallet, chain-data, or visual browser test.
