# Module 1 — DID Identity

Each student receives a decentralized identifier:

```
did:zkcampus:0x893...
```

No personal information is public. The DID document (resolvable on-chain via
`IdentityRegistry.sol`) contains only:

- The DID itself.
- Current public key material (for signature verification / key rotation).
- Status (active / deactivated).

It contains **no** name, DOB, roll number, or institution — those live only
in encrypted credentials in the student's wallet (see [Module
3](03-wallet.md)).

## Issuer identities

Universities and other trusted issuers also have DIDs, registered with an
accreditation flag in `IdentityRegistry.sol`. A credential is only usable in
a proof if its issuer DID is currently accredited — this is what lets
verifiers trust a credential without contacting the university directly.

## Key rotation

Students can rotate their DID's key material (e.g. after a suspected
compromise) without changing the DID itself. Old credentials remain valid as
long as they were signed against a key that was valid at issuance time — the
registry keeps a key history, not just current state.

## Dependencies

- Blocks all other modules — it's the identity root credentials, wallets,
  and proofs are anchored to.
