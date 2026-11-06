# SIXTEEN CURRENCY V2 — Integrated Wallet & Staking Dashboard (Preview)

This is an **isolated preview**, not a replacement for any existing production DApp.

## Preview
https://jin1963.github.io/SixteenSuperWallet/sixteen-currency-integrated-v2/

## What is integrated
- Existing SIXTEEN CURRENCY black-and-gold UI and **one** MetaMask/TokenPocket wallet connection
- BNB + STC balance from the existing gateway
- NC, THBC, STC, USDT balances from the original Sixteen Super Wallet
- NC/USDT and THBC/USDT PancakeSwap V2 pool-derived indicative rates
- NC Staking V5
- NC Whale Staking V12
- NC Reward Core + Reward Staking
- THBC Whale Reward 500 days
- Existing DApp links for actions such as claim or withdrawal

All integrated staking and reward panels are **read-only**. No token approval, transfers, signature request, or smart-contract write transaction was added. The dashboard uses a wallet state event from the original gateway; it does not ask to connect a second time.

## Before production
1. Test MetaMask on desktop and TokenPocket in its mobile DApp browser.
2. Test with a wallet that has stakes and one with none.
3. Confirm all read-only contract addresses, ABI selectors, staking counts, balances and reward calculations against the existing DApps.
4. Check the indicative rates and RPC availability; the prices may differ from executable trade prices.
5. Confirm THBC Reward links point to the correct production DApp.
6. After approval, copy this **new** `index.html` to `sixteeninter-ux/SixteenSuperWallet/sixteen-currency-integrated-v2/index.html` for independent testing. **Do not overwrite** `sixteen-currency-v1/index.html` or the repository root `index.html`.
7. Only after successful tests, coordinate deployment on the new `app.sixteeninter.com` subdomain with the server administrator.

## GitHub copy instructions (when the source and destination accounts differ)
1. Open the preview source file: https://github.com/jin1963/SixteenSuperWallet/blob/main/sixteen-currency-integrated-v2/index.html
2. Use the **Raw** or **Download raw file** control to save `index.html` locally.
3. Open `https://github.com/sixteeninter-ux/SixteenSuperWallet`, choose **Add file → Upload files** on the `main` branch and upload the file to a new directory named `sixteen-currency-integrated-v2`. If the web UI does not support placing it in a new folder directly, use **Add file → Create new file**, enter `sixteen-currency-integrated-v2/index.html`, and paste the complete source.
4. Commit the new file and preview it using GitHub Pages. Keep all existing folders untouched.

This preview was checked for JavaScript syntax and HTML tag nesting, but not tested against live wallets or chain responses yet.
