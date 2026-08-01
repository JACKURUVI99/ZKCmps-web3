# ZKCampus — Recursive Zero-Knowledge Academic Identity Framework

Privacy-preserving, multi-credential verification and revocation for academic
and professional identity: **verify without revealing**.

Students collect signed credentials (degree, CGPA, certificates, income
certificates, etc.) from trusted issuers into a personal wallet, then generate
zero-knowledge proofs of specific claims ("CGPA > 8", "Age > 18", "No active
backlogs") without exposing the underlying documents or values. Recruiters,
scholarship portals, visa offices, and government systems verify the proof
on-chain instead of collecting and storing raw documents.

## Problem

Students repeatedly upload Aadhaar, passport, degree, CGPA, marksheets,
income certificates, and internship certificates to every recruiter,
scholarship portal, higher-studies portal, and visa office. This causes:

- Identity theft
- Forged certificates
- Data leaks
- No ownership of identity
- Repeated, redundant verification

## Approach

Each student holds a DID (`did:zkcampus:0x...`) with no public personal
information. Universities issue signed Verifiable Credentials into the
student's wallet. The wallet stores credentials encrypted locally (not on
chain) alongside a Merkle tree of credential hashes. A ZK circuit proves
predicates over the credentials (thresholds, equality, non-membership in a
revocation set) and a Solidity verifier checks the proof on-chain. Multiple
proofs can be recursively aggregated into a single proof to keep verification
cost constant as the number of credentials grows.

## Architecture

```
                  ┌─────────────────────────┐
                  │ University Consortium   │
                  │ Trusted Issuers         │
                  └────────────┬────────────┘
                               │
                  Issue Signed VC (Ed25519 / BBS+)
                               │
                               ▼
                   DID Registry Smart Contract
                               │
                               ▼
                     Student Identity Wallet
      ┌───────────────────────────────────────────┐
      │                                           │
Encrypted Credentials                   Merkle Credential Tree
      │                                           │
      └──────────────┬────────────────────────────┘
                      │
               zk Proof Generator
                      │
              Recursive Proof Engine
                      │
                      ▼
        Solidity Verifier Smart Contract
                      │
          Revocation Registry Check
                      │
                      ▼
 Recruiters | Scholarships | Visa | Alumni | Government
```

## Modules

| # | Module | Summary |
|---|--------|---------|
| 1 | [DID Identity](docs/modules/01-did-identity.md) | `did:zkcampus:0x...` identifiers, no public PII |
| 2 | [Credential Issuance](docs/modules/02-credential-issuance.md) | University-signed VCs (Ed25519 / BBS+) |
| 3 | [Wallet](docs/modules/03-wallet.md) | Local AES-256-GCM encrypted storage, passkey + wallet-signature auth |
| 4 | [Credential Storage](docs/modules/04-credential-storage.md) | SHA-256 / Poseidon hashes + Merkle root, encrypted docs off-chain |
| 5 | [Proof Generator](docs/modules/05-proof-generator.md) | Predicate proofs (CGPA, degree, branch, age, backlogs) |
| 6 | [Recursive Aggregation](docs/modules/06-recursive-aggregation.md) | Many proofs → one recursive proof |
| 7 | [Recruitment Portal](docs/modules/07-recruitment-portal.md) | Companies publish eligibility criteria, students prove, no documents |
| 8 | [Scholarship Portal](docs/modules/08-scholarship-portal.md) | Multi-predicate eligibility (income, CGPA, hosteller, gender) |
| 9 | [Visa](docs/modules/09-visa.md) | Degree verified / accredited / graduated, no transcript sharing |
| 10 | [Revocation](docs/modules/10-revocation.md) | Sparse Merkle Tree / accumulator-based revocation registry |

See [docs/architecture.md](docs/architecture.md) for the full system design,
[docs/tech-stack.md](docs/tech-stack.md) for the chosen stack and rationale,
[docs/security.md](docs/security.md) for the threat-model and controls, and
[docs/roadmap.md](docs/roadmap.md) for the phased development timeline.

## Repository layout

```
contracts/     Hardhat project. AccessManager + IdentityRegistry implemented
               (Module 1); CredentialRegistry, Verifier, Revocation stubbed
               with fixed external interfaces for later phases.
circuits/      Circom / Halo2 / Noir circuits, recursive aggregation (Nova).
               Not started — lands in Phase 3.
backend/       Rust (Axum) API. Health check + 501 stub routes for
               issuance/proofs/portals/revocation, each tagged with the
               phase it lands in.
frontend/      Next.js + TypeScript + Tailwind + RainbowKit + Wagmi.
               Wallet-connect landing page implemented.
docs/          Architecture, module specs, security notes, roadmap
```

## Status

Phase 1 in progress (DID + Wallet). `IdentityRegistry.sol` (Module 1) is
implemented and tested; the wallet's local encrypted credential storage
(Module 3) has not started. See [docs/roadmap.md](docs/roadmap.md) for the
full phase plan.
