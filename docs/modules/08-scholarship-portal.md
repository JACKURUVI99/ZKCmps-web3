# Module 8 — Scholarship Portal

Scholarship criteria, e.g.:

- Income < 5 lakh
- CGPA > 9
- Hosteller
- Female

Student proves **TRUE** for the combined predicate — without revealing
income, exact CGPA, or any other underlying value.

## Why this needs recursive aggregation

Four independent predicates over (likely) four different credential
sources (income certificate, marksheet, hostel record, identity credential)
— this is the canonical case for [Module 6](06-recursive-aggregation.md):
fold four single-predicate proofs into one recursive proof rather than
verifying four separately.

## Sensitive-attribute handling

Gender and hosteller status are equality predicates over attributes that are
themselves sensitive — the same "prove without reveal" guarantee applies to
them as it does to income or CGPA. The portal never receives the attribute
value, only the proof that the (private) value equals the required one.

## Dependencies

- Requires [Module 5](05-proof-generator.md) and [Module 6](06-recursive-aggregation.md).
- Requires [Module 2](02-credential-issuance.md) to support issuing an income
  certificate as a credential (not just academic ones).
