# Security Model

## Threats addressed by the architecture itself

| Threat (from the problem statement) | Mitigation |
|---|---|
| Identity theft | No PII on-chain; DID reveals nothing; proofs reveal only a boolean predicate |
| Forged certificates | Credentials are signed by accredited issuers and Merkle-committed on-chain; a forged document has no valid signature/commitment |
| Data leaks | Documents never leave the student's device in plaintext; only hashes/commitments and ZK proofs are shared |
| No ownership of identity | Student controls the wallet's private keys; DID is self-custodied |
| Repeated verification | One proof, reusable across any verifier that accepts the same predicate schema |

## Replay protection

Every proof submission includes a **nonce** and a **timestamp**, bound into
the circuit's public inputs (or signed alongside the proof). Verifiers reject
proofs with a stale timestamp or a previously seen nonce. Nonces are tracked
per-(student DID, verifier) pair to prevent a valid proof from being replayed
against a different verifier or resubmitted later.

## Phishing prevention

Wallet actions (signing, proof submission) are gated by a **challenge–nonce**
wallet signature flow: the relying party issues a challenge, the wallet signs
it with the student's key, and the signature is checked against the
registered DID key material before any credential material is touched. This
prevents a malicious site from replaying a captured signature against a
different challenge.

## Rate limiting

**Token bucket** limiting per DID and per IP at the API layer (Redis-backed
counters), applied to proof-submission and issuance endpoints to blunt
credential-stuffing and DoS-style abuse without penalizing normal usage
bursts.

## Backend hardening

- **Mutual TLS** between backend services (issuer API, proof coordination,
  portal API) so only authenticated services can call each other.
- **Secrets** (signing keys for the backend's own service identity, DB
  credentials, Vault tokens) are never in config files — stored and rotated
  via **HashiCorp Vault**.
- The backend is designed to hold no plaintext credential data at rest or in
  transit — it coordinates jobs and stores only commitments/metadata in
  Postgres.

## Monitoring

**Prometheus** for metrics (proof verification latency, rate-limit
rejections, revocation-check failures) and **Grafana** for dashboards/alerts,
so anomalous verification patterns (e.g. a spike in rejected proofs from one
DID) are visible operationally, not just logged.

## Revocation as a security control

Every verifier must check the credential's non-membership in the
`Revocation.sol` Sparse Merkle Tree / accumulator as part of proof
verification — a valid ZK proof over a since-revoked credential must fail
verification, not just fail a separate UI check. This is enforced at the
contract level so no verifier can accidentally skip it.

## Out of scope for this document

Formal circuit audits, trusted-setup ceremony procedures (if a setup-requiring
proof system is used), and legal/compliance requirements (e.g. data
protection regulation for the university consortium) are tracked separately
as the relevant modules are implemented.
