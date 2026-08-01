# Module 3 — Wallet

Stores encrypted credentials **locally** — not on the blockchain.

## Encryption

**AES-256-GCM** for local encryption of each credential at rest. Encryption
keys are derived from the wallet's key material, never stored in plaintext
alongside the ciphertext.

## Authentication

Two factors, both required:

1. **Passkey** (device-bound, biometric/PIN-backed) — unlocks the local
   wallet app/session.
2. **Wallet signature** — proves control of the DID's private key for any
   action that touches the chain (issuance acknowledgement, proof
   submission, revocation acknowledgement).

Neither alone is sufficient: a stolen device without the wallet key can't
sign on-chain actions; a leaked wallet key without the passkey can't unlock
the local encrypted store.

## Responsibilities

- Hold encrypted credentials and their decryption keys.
- Maintain the student's Merkle credential tree (see [Module
  4](04-credential-storage.md)) as credentials are added/removed.
- Perform all decryption and ZK witness construction **client-side** — the
  backend never receives plaintext credential data.
- Trigger [Module 5](05-proof-generator.md) when a proof is requested.

## Dependencies

- Requires [Module 1](01-did-identity.md) for the DID/key material.
- Consumes credentials from [Module 2](02-credential-issuance.md).
