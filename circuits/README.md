# ZKCampus Circuits

ZK circuits for Module 5 (Proof Generator) and Module 6 (Recursive
Aggregation) — see [../docs/modules/05-proof-generator.md](../docs/modules/05-proof-generator.md)
and [../docs/modules/06-recursive-aggregation.md](../docs/modules/06-recursive-aggregation.md).
Not implemented yet: this lands in Phase 3, once [Module 4](../docs/modules/04-credential-storage.md)'s
credential commitment format is finalized in the contracts (`CredentialRegistry.sol`).

## Planned layout

```
circom/    Circuits for well-understood predicates (range checks, equality,
           Merkle membership) — see docs/tech-stack.md#zk-stack
halo2/     No-trusted-setup circuits, used for the recursive aggregation layer
noir/      Developer-friendly, backend-agnostic circuit definitions
```

Circuit tooling choice (Circom vs. Halo2 vs. SP1 vs. Noir) is made
per-predicate-type, not globally — see
[../docs/tech-stack.md](../docs/tech-stack.md#zk-stack) for the rationale.
All circuits share one public-input schema (predicate, student DID, nonce,
timestamp, Merkle root, revocation root) so `Verifier.sol` can check them
uniformly regardless of which tool produced the proof.
