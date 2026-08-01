# Module 5 — Proof Generator

The student proves predicates such as:

- CGPA > 8
- Degree == B.E
- Branch == EEE
- Age > 18
- Backlogs == 0

**without revealing** CGPA, DOB, or Roll Number.

## Circuit inputs

- **Private (witness):** the actual attribute value, the Merkle path proving
  it belongs to a credential committed in [Module 4](04-credential-storage.md),
  and the issuer's signature over that credential.
- **Public:** the predicate being proven (e.g. threshold `8` for CGPA), the
  student's DID, a nonce/timestamp (see [security.md](../security.md#replay-protection)),
  and the Merkle root the credential is checked against.

The circuit proves, in zero knowledge:

1. The witness value satisfies the stated predicate.
2. The witness is committed under the public Merkle root (membership).
3. The commitment is signed by an accredited issuer.
4. (Optionally, folded in from [Module 10](10-revocation.md)) the commitment
   is **not** present in the current revocation set.

## Circuit implementation

See [tech-stack.md](../tech-stack.md#zk-stack) for the multi-tool ZK stack
(Circom / Halo2 / SP1 / Noir) — different predicate types (range checks vs.
equality vs. more complex logic) may use different circuit tooling, but all
share the same public-input schema so [Verifier.sol](../architecture.md)
can check them uniformly.

## Dependencies

- Requires [Module 3](03-wallet.md) (witness data) and [Module 4](04-credential-storage.md)
  (Merkle membership).
- Feeds [Module 6](06-recursive-aggregation.md) when multiple predicates are
  needed at once, and is consumed directly by [Modules 7–9](07-recruitment-portal.md)
  when only a single predicate is needed.
