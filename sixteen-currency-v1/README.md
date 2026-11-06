# SIXTEEN CURRENCY V1 — Wallet Gateway

เวอร์ชันแรกของแพลตฟอร์ม SIXTEEN CURRENCY (Wallet-only, read-only) — ไม่เกี่ยวข้องกับระบบเดิม

## Preview
- GitHub Pages (เมื่อ deploy แล้ว): https://jin1963.github.io/SixteenSuperWallet/sixteen-currency-v1/
- Source: https://github.com/jin1963/SixteenSuperWallet/tree/main/sixteen-currency-v1

## Files
- `index.html` — standalone single-file site; includes CSS, config and JavaScript, no build process or database required.

## Features
- Black/gold mobile-friendly home page
- Connect MetaMask / TokenPocket (in-app browser recommended on mobile)
- Request BNB Smart Chain Mainnet (chain ID 56 / 0x38)
- Display connected wallet address, BNB balance and STC BEP-20 balance
- Existing DApp links for NC Trading and THBC Reward
- No token approvals, transfers, signing, seed phrase or private-key collection

## Hosting at app.sixteeninter.com
1. Have the hosting administrator create the new subdomain `app.sixteeninter.com`, a separate document root and HTTPS certificate.
2. Download `index.html` from this directory and upload it to that document root as `index.html`.
3. Test in MetaMask and TokenPocket mobile browsers and check BSC chain switching, balances and external links.
4. Do **not** overwrite the root website, PHP files, database, or any old DApps.

V1 needs no MySQL, PHP, npm, server-side secrets or wallet private keys. Please rotate any previously shared FTP/database passwords. Use SFTP/FTPS for transfers.

**Important:** This is a wallet gateway, not a login/authentication backend. No on-chain write transaction is sent by this page. Test on the production HTTPS origin before public launch.
