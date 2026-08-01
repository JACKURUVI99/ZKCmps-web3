# Technology Stack

## Blockchain

**Base** or **Polygon** (both EVM-compatible L2s settling to Ethereum).

- Low gas cost for frequent verifier interactions (recruiters/scholarships
  checking proofs at scale).
- Inherits Ethereum's security via settlement.
- Large existing ecosystem/tooling (wallets, indexers, RPC providers).

## Smart contracts (Solidity, one concern per file)

| Contract | Responsibility |
|---|---|
| `IdentityRegistry.sol` | DID registration, key rotation, issuer accreditation |
| `CredentialRegistry.sol` | Per-student Merkle roots, credential commitments |
| `Verifier.sol` | On-chain SNARK/STARK proof verification |
| `Revocation.sol` | Sparse Merkle Tree / accumulator of revoked credentials |
| `AccessManager.sol` | Role-based access control across the other contracts |

Never combine these into a single monolithic contract — each has a distinct
upgrade path, audit surface, and access-control policy.

## Backend

- **Language:** Rust — faster than Node, safer memory model, better
  concurrency for proof-job coordination and issuer APIs.
- **Framework:** Axum.
- **Database:** PostgreSQL (durable state: DID/issuer metadata, portal
  criteria, job status) + Redis (caching, rate-limit counters, short-lived
  proof-job queues).
- The backend never holds plaintext credentials or private keys — it
  coordinates issuance/verification workflows only.

## Frontend

- Next.js + TypeScript + Tailwind CSS.
- **Wallet connectivity:** RainbowKit + Wagmi.
- Runs the wallet's crypto (decryption, witness generation) client-side so
  sensitive data never reaches the backend.

## Storage

- **IPFS + Filecoin**, encrypted client-side before upload, for the (rare)
  cases where an encrypted blob needs durable off-chain storage beyond the
  student's device. Only hashes/commitments ever go on-chain.

## Cryptography

| Purpose | Choice | Why |
|---|---|---|
| In-circuit hashing | Poseidon | Much cheaper than SHA-256 inside ZK circuits |
| Document integrity hash | SHA-256 (off-circuit) + Poseidon (in-circuit) | SHA-256 for general integrity, Poseidon for circuit-efficient commitments |
| Digital signatures (issuance) | Ed25519 or BLS | Fast verification; BLS supports aggregation |
| Selective disclosure signatures | BBS+ | Natively supports revealing a subset of signed attributes |
| Symmetric encryption (wallet) | AES-256-GCM (baseline), XChaCha20-Poly1305 (alternative) | Authenticated encryption for local credential storage |
| Key exchange | X25519 | Wallet ↔ issuer/verifier secure channel setup |

## ZK stack

Not just snarkjs — a serious deployment needs multiple tools for different
jobs:

- **Circom** — circuit definitions for well-understood predicates (range
  checks, equality, Merkle membership).
- **Halo2** — no trusted setup, good for the recursive/aggregation layer.
- **SP1** — zkVM option for more complex, code-like predicate logic.
- **Noir** — developer-friendly circuit language, backend-agnostic proving.
- **Future:** zk-STARK for post-quantum readiness (SNARKs based on
  pairing-friendly curves are not post-quantum secure; STARKs rely only on
  hashes).

## Data structures

| Instead of | Use | Benefit |
|---|---|---|
| Array scan for credential lookup | Merkle Tree | O(log n) membership verification |
| Array/list of revoked IDs | Sparse Merkle Tree | O(log n) revocation membership/non-membership |
| Global proof re-verification per credential | Nova / recursive SNARK | Constant-ish verification cost as credential count grows |
| Flat credential index | Indexed Merkle Forest | Fast credential search across types/issuers |

## Algorithms by problem

| Problem | Method |
|---|---|
| Credential integrity | Merkle Tree |
| Fast membership check | Sparse Merkle Tree |
| Proof aggregation | Nova / Recursive SNARK |
| Selective disclosure | BBS+ signatures |
| Revocation | Cryptographic accumulator |
| Fast lookup | Patricia Trie |
| Large-scale verification | Batch verification |
| Secure identity | DID + Verifiable Credentials |

## Security infrastructure

- **Secrets:** HashiCorp Vault.
- **Service-to-service transport:** mutual TLS.
- **Monitoring:** Prometheus + Grafana.

See [security.md](security.md) for how these are applied (replay protection,
phishing prevention, rate limiting).
