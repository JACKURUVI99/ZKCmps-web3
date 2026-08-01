import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { base, baseSepolia, polygon, polygonAmoy } from "wagmi/chains";

const projectId = process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID;

// RainbowKit throws at config time if projectId is empty, which would break
// the production build before real secrets are configured. Fall back to a
// placeholder so the app builds/runs with injected wallets (e.g. MetaMask
// extension); set NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID (see .env.example)
// before relying on WalletConnect-based wallets.
export const wagmiConfig = getDefaultConfig({
  appName: "ZKCampus",
  projectId: projectId || "00000000000000000000000000000000000000",
  chains: [base, baseSepolia, polygon, polygonAmoy],
  ssr: true,
});
