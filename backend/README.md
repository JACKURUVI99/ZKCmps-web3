# ZKCampus Backend

Rust (Axum) orchestration API described in
[../docs/architecture.md](../docs/architecture.md). Coordinates issuance,
proof jobs, portal criteria, and revocation notifications — it never holds
plaintext credential data; that stays in the client-side wallet.

## Status

Skeleton only: a working `/healthz` endpoint plus stub routes for the
modules that land in later phases, each returning `501 Not Implemented`
with a `lands_in` phase marker.

| Route | Module | Lands in |
|---|---|---|
| `GET /healthz` | — | implemented |
| `GET /v1/issuance` | Module 2 — Credential Issuance | Phase 2 |
| `GET /v1/proofs` | Modules 5-6 — Proof Generator / Recursive Aggregation | Phase 3 |
| `GET /v1/portals` | Modules 7-9 — Recruitment / Scholarship / Visa | Phase 5 |
| `GET /v1/revocation` | Module 10 — Revocation | Phase 8 |

Module 1 (DID Identity) is served directly from `IdentityRegistry.sol`
on-chain — there is no backend DID route by design.

## Usage

```bash
cargo run                 # starts on :8080 (override with PORT env var)
cargo test
cargo clippy
```

Postgres and Redis (see [../docs/tech-stack.md](../docs/tech-stack.md)) are
wired in once a module actually needs to persist state (Phase 2 onward).
