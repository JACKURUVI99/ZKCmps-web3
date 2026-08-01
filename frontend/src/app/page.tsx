"use client";

import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";

const MODULES = [
  { name: "DID Identity", detail: "did:zkcampus:0x… — no personal data on-chain" },
  { name: "Credential Issuance", detail: "University-signed VCs (Ed25519 / BBS+)" },
  { name: "Wallet", detail: "AES-256-GCM local storage, passkey + wallet signature" },
  { name: "Proof Generator", detail: "Prove predicates without revealing values" },
] as const;

export default function Home() {
  const { address, isConnected } = useAccount();

  return (
    <div className="flex flex-col flex-1 items-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex w-full max-w-2xl flex-1 flex-col items-center gap-10 px-6 py-24">
        <div className="flex flex-col items-center gap-3 text-center">
          <h1 className="text-3xl font-semibold tracking-tight text-black dark:text-zinc-50">
            ZKCampus
          </h1>
          <p className="max-w-md text-lg leading-8 text-zinc-600 dark:text-zinc-400">
            Verify without revealing.
          </p>
        </div>

        <ConnectButton />

        {isConnected && address && (
          <p className="text-sm text-zinc-500 dark:text-zinc-400">
            Wallet connected — DID will be derived as{" "}
            <code className="rounded bg-zinc-200 px-1.5 py-0.5 dark:bg-zinc-800">
              did:zkcampus:{address}
            </code>
          </p>
        )}

        <ul className="flex w-full flex-col gap-3">
          {MODULES.map((mod) => (
            <li
              key={mod.name}
              className="rounded-lg border border-black/[.08] px-4 py-3 dark:border-white/[.145]"
            >
              <p className="font-medium text-black dark:text-zinc-50">{mod.name}</p>
              <p className="text-sm text-zinc-600 dark:text-zinc-400">{mod.detail}</p>
            </li>
          ))}
        </ul>
      </main>
    </div>
  );
}
