# Module 2 — Credential Issuance

A university signs a Verifiable Credential over a student's attributes:

- CGPA
- Semester
- Degree
- DOB
- Department
- Certificates
- Achievements

using **Ed25519** or **BBS+**.

## Why BBS+

BBS+ signatures support **selective disclosure** natively: the issuer signs
a set of attributes once, and the holder can later prove statements about a
*subset* of them (or predicates over them) without revealing the rest or
even revealing which signature scheme was used per-attribute. This maps
directly onto Module 5's proof requirements ("CGPA > 8" without revealing
CGPA, DOB, or roll number) and avoids needing a separate credential per
disclosable attribute combination.

Ed25519 remains the simpler default for credentials that will only ever be
proven over as a whole (e.g. "this specific certificate exists and is
signed by this issuer") rather than needing attribute-level selective
disclosure.

## Delivery

The signed credential goes directly to the student's wallet — never to a
public registry or the backend in plaintext. Only a hash/commitment of the
credential is later published (see [Module 4](04-credential-storage.md)).

## Dependencies

- Requires [Module 1](01-did-identity.md) (issuer DID must be accredited).
- Feeds [Module 3](03-wallet.md) (storage) and [Module 4](04-credential-storage.md)
  (commitment).
