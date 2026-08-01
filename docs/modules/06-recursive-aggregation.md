# Module 6 — Recursive Aggregation

Instead of submitting 5 separate proofs for 5 predicates, generate **1
recursive proof** that folds them together.

This is one of the highest-value optimizations in the system: on-chain
verification cost is what students and verifiers actually pay for, and it
does not need to scale linearly with the number of credentials/predicates
being checked.

## Approach

Use a recursive/folding proof system (Nova-style) to combine N individual
proofs from [Module 5](05-proof-generator.md) into a single proof that
attests "all N underlying statements hold," verified once by
`Verifier.sol` instead of N times.

## When to use it

- **Multi-predicate checks** — e.g. a scholarship requiring income, CGPA,
  hosteller status, and gender simultaneously ([Module 8](08-scholarship-portal.md)).
- **At scale** — aggregating many students' or many credentials' proofs for
  batch verification (see `Batch verification` in the [algorithms
  table](../tech-stack.md#algorithms-by-problem)).

## Dependencies

- Requires [Module 5](05-proof-generator.md) to produce the individual
  proofs being folded.
- Feeds [Verifier.sol](../architecture.md) — the on-chain contract only ever
  sees the final recursive proof, not the intermediate ones.
