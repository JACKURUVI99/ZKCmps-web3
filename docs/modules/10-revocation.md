# Module 10 — Revocation

If a university revokes a degree, credential, or certificate, it updates the
**Revocation Registry**. Verifiers automatically check revocation status
before accepting any proof — this check is enforced at the contract level
(inside `Verifier.sol`'s acceptance logic), not left as an optional UI step.

## Data structure

Prefer an **accumulator-based or Sparse-Merkle-Tree-based** revocation
registry over storing every revoked credential individually in a list:

- A flat list of revoked IDs requires linear scanning (or a centralized
  lookup service) and leaks the *size* and *growth rate* of the revoked set.
- A **Sparse Merkle Tree** gives O(log n) membership *and* non-membership
  proofs — a student's ZK proof can include a witness that their credential's
  commitment is absent from the tree, verified in-circuit alongside the
  predicate proof itself.
- A **cryptographic accumulator** achieves similar non-membership proving
  with different tradeoffs (typically smaller witnesses, different update
  costs) and is worth evaluating against the SMT once revocation volume and
  update frequency are known.

## Revocation flow

1. University submits a revocation for a credential commitment (identified by
   its Module 4 hash) to `Revocation.sol`, signed by the issuer's DID.
2. The Sparse Merkle Tree / accumulator is updated on-chain.
3. Any subsequent proof referencing that commitment must include a
   non-membership witness against the *current* revocation root; a stale
   root should be rejected (bounded by a max-age check, consistent with the
   [replay-protection](../security.md#replay-protection) timestamp policy)
   so a student can't prove non-revocation against an outdated tree.

## Dependencies

- Requires [Module 4](04-credential-storage.md) (the commitment being
  revoked) and [Module 1](01-did-identity.md) (only the accredited issuer
  who issued a credential may revoke it).
- Consumed by every verifier module ([7](07-recruitment-portal.md), [8](08-scholarship-portal.md),
  [9](09-visa.md)) as a mandatory part of proof acceptance.
