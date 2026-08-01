# Module 9 — Visa

Proof required:

- Degree verified
- University accredited
- Graduated

No transcript sharing.

## Notes

- "University accredited" is checked against [Module 1](01-did-identity.md)'s
  issuer accreditation flag as of the credential's issuance date — not just
  current accreditation, since accreditation status can change over time and
  the proof must reflect what was true when the degree was issued.
- This is a lighter-weight predicate set than [Module 8](08-scholarship-portal.md)
  (existence/equality checks, no numeric thresholds), but the same non-
  revocation requirement from [Module 10](10-revocation.md) applies — a
  since-revoked degree must not pass.

## Dependencies

- Requires [Module 5](05-proof-generator.md), [Module 1](01-did-identity.md)
  (issuer accreditation), and [Module 10](10-revocation.md).
