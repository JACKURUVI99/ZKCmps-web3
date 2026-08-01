# Module 7 — Recruitment Portal

1. Company publishes eligibility criteria, e.g.:
   - CGPA > 8
   - Branch == EEE
   - Graduating year == 2028
   - No active backlogs
2. Students generate a proof against those criteria (via [Module
   5](05-proof-generator.md), folded through [Module 6](06-recursive-aggregation.md)
   since this is 4 predicates).
3. Company verifies the proof on-chain via `Verifier.sol`.
4. Done — no documents change hands.

## What the recruiter sees

A boolean per candidate DID: eligible / not eligible, backed by an on-chain
verifiable proof reference. No CGPA value, no name, no transcript.

## Dependencies

- Requires [Module 5](05-proof-generator.md), [Module 6](06-recursive-aggregation.md),
  and [Module 10](10-revocation.md) (a proof over a revoked degree must
  fail).
