# ZKCampus Frontend

Next.js + TypeScript + Tailwind + RainbowKit/Wagmi client described in
[../docs/architecture.md](../docs/architecture.md). This is the surface
Module 3's wallet builds on: wallet connection today, local encrypted
credential storage and proof generation as the wallet module lands.

## Status

Landing page with wallet connect (`src/app/page.tsx`) wired through
RainbowKit/Wagmi (`src/lib/wagmi.ts`, `src/app/providers.tsx`), configured
for Base, Base Sepolia, Polygon, and Polygon Amoy.

## Usage

```bash
cp .env.example .env.local   # fill in NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID
npm install
npm run dev
npm run build
npm run lint
```

`NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID` (get one at
https://cloud.walletconnect.com) is required for WalletConnect-based
wallets; without it the app still builds/runs with injected wallets (e.g.
the MetaMask browser extension) via a placeholder ID.

`dev`/`build` pin `next --webpack` rather than Next 16's default Turbopack —
a transitive dependency (RainbowKit → wagmi connectors → Coinbase's Base
Account connector) statically references optional `@x402/*` payment
packages we don't install; `next.config.ts` ignores that scope via a
webpack `IgnorePlugin`, which needs the webpack builder to apply.
