# Module 4 — Credential Storage

Don't upload PDFs. Store:

- `SHA256(document)` — general-purpose integrity hash.
- `Poseidon(document)` — circuit-efficient commitment used inside ZK proofs
  (Poseidon is dramatically cheaper than SHA-256 to compute inside a
  circuit).
- **Merkle root** over the student's committed credentials.

The actual PDF/document stays encrypted, either purely local (wallet) or as
an encrypted blob on IPFS + Filecoin if durability beyond the device is
needed (see [tech-stack.md](../tech-stack.md#storage)). Only the Merkle root
and per-credential commitments are published on-chain via
`CredentialRegistry.sol`.

## Why a Merkle tree instead of an array

A flat list of credential hashes requires a linear scan to prove membership.
A Merkle tree gives **O(log n)** membership proofs, which is what Module 5's
circuits actually consume as a witness (a Merkle path, not the whole credential
set).

## What goes on-chain vs. what stays local

| Data | Location |
|---|---|
| Plaintext document | Never leaves device (or encrypted blob on IPFS) |
| `SHA256`/`Poseidon` hash of document | Wallet-local, included in Merkle tree |
| Merkle root | `CredentialRegistry.sol` |
| Issuer signature over the commitment | `CredentialRegistry.sol` |

## Dependencies

- Requires [Module 2](02-credential-issuance.md) (signed credential to hash)
  and [Module 3](03-wallet.md) (tree maintenance).
- Feeds [Module 5](05-proof-generator.md) (Merkle membership witness) and
  [Module 10](10-revocation.md) (a revoked commitment references the same
  hash).
