# Development Roadmap

## Phased timeline

| Phase | Goal |
|---|---|
| 1 | DID + Wallet |
| 2 | VC Issuance |
| 3 | ZK Proof Generation |
| 4 | Smart Contract Verifier |
| 5 | Recruiter Portal |
| 6 | Scholarship Portal |
| 7 | Recursive Proofs |
| 8 | Revocation Registry |
| 9 | Cross-chain Support |
| 10 | AI Matching + Benchmarking |

Each phase should ship independently testable: a phase is "done" when its
module doc's flow can be demonstrated end-to-end against the previous
phases' output, not just when its code compiles.

## Suggested phase dependencies

- Phase 1 (DID + Wallet) blocks everything else — it's the identity root.
- Phase 2 (Issuance) depends on Phase 1's DID registry existing.
- Phase 3 (Proof Generation) depends on Phase 2 producing real credentials to
  build circuits/witnesses against.
- Phase 4 (Verifier contract) can be developed in parallel with Phase 3 once
  the proof system and public-input schema are fixed.
- Phases 5–6 (portals) are consumers of Phases 3–4 and can be built in
  parallel with each other.
- Phase 7 (Recursive proofs) is an optimization layer on top of Phase 3 — it
  changes internals, not the verifier's external interface, so it should not
  block Phases 5–6.
- Phase 8 (Revocation) can start as soon as Phase 2 defines what a
  "credential commitment" looks like, but must land before any portal goes
  to production use.
- Phase 9 (Cross-chain) depends on Phase 1's DID scheme and Phase 4's
  verifier being stable enough to redeploy on a second chain.
- Phase 10 (AI matching + benchmarking) is a research/product layer on top of
  a working Phase 5–8 system.

## Research contribution framing

The contribution is not "a recruiter dashboard that checks CGPA > 8" — it's
the underlying framework. Publish/pitch it as:

> **A Recursive Zero-Knowledge Academic Identity Framework with
> Privacy-Preserving Multi-Credential Verification and Efficient
> Revocation**

## Research directions worth tracking

- **Recursive proof aggregation** — folding e.g. 100 credential proofs into
  1 proof; directly addresses on-chain verification cost at scale.
- **AI job matching without exposure** — a matching model that only ever
  receives an "eligible/not eligible" bit per (student, job) pair, never
  CGPA/DOB/name, by consuming ZK proof outputs instead of profile data.
- **Cross-chain DID** — one identity resolvable across Ethereum, Polygon, and
  Base rather than a chain-locked identity.
- **Post-quantum upgrade path** — migrate the proof system from Groth16
  (pairing-based, not post-quantum secure) to zk-STARK (hash-based) ahead of
  any practical quantum threat to elliptic-curve cryptography.
- **zkTLS** — proving facts fetched from an existing university HTTPS system
  (e.g. a legacy student portal) without exposing the raw response, as a
  bridge for issuers who won't adopt VC issuance directly. Emerging/unstable
  tooling — track but don't depend on it for early phases.
