# Architecture

## Goal

Let a student prove a *predicate* over one or more credentials ("CGPA > 8",
"Age > 18", "Degree == B.E", "no active backlogs", "income < 5 lakh") to a
verifier, without the verifier learning the underlying value, and without the
student re-uploading documents to every party that needs to check it.

## End-to-end flow

1. **Issuance.** A university (a trusted issuer in the University Consortium)
   signs a Verifiable Credential over a student's attributes (CGPA, semester,
   degree, DOB, department, certificates, achievements) using Ed25519 or
   BBS+. The credential is delivered to the student's wallet, not published
   anywhere public.
2. **DID anchoring.** The student's DID (`did:zkcampus:0x...`) and issuer DIDs
   are registered in the `IdentityRegistry` smart contract. No personal data
   is on-chain — only DID ↔ key-material bindings and issuer accreditation
   status.
3. **Local storage.** The wallet encrypts each credential (AES-256-GCM) and
   stores it locally. The document itself never leaves the student's device
   in plaintext and never goes on-chain. A `SHA256` + `Poseidon` hash of the
   document, plus its position in a per-student Merkle tree, is committed to
   the `CredentialRegistry` contract so a proof can later show membership
   without revealing content.
4. **Proof generation.** When a verifier publishes eligibility criteria (e.g.
   "CGPA > 8, Branch == EEE, no backlogs"), the wallet's proof generator
   builds a ZK circuit witness from the relevant encrypted credentials and
   produces a proof that the predicate holds, that the credential is
   Merkle-committed, and that it is not present in the revocation set.
5. **Recursive aggregation.** If a verifier's criteria span multiple
   credentials (degree + CGPA + backlog status), the individual proofs are
   folded into a single recursive proof (Nova-style) instead of shipping N
   proofs, keeping on-chain verification cost roughly constant.
6. **Verification.** The recursive proof is submitted to `Verifier.sol`,
   which checks the SNARK/STARK proof, checks a non-revocation
   sub-proof/witness against `Revocation.sol`, and checks issuer
   accreditation via `IdentityRegistry.sol`. `AccessManager.sol` gates who
   may call which contract functions (issuers vs. verifiers vs. governance).
7. **Consumption.** Recruiters, scholarship portals, visa offices, alumni
   networks, and government systems only ever see a boolean pass/fail plus a
   proof reference — never CGPA, DOB, name, or roll number.

## Component responsibilities

- **DID Registry** — DID lifecycle (create/rotate keys/deactivate), issuer
  accreditation list.
- **Credential Registry** — Merkle roots per student, credential hash
  commitments, issuer signatures over commitments.
- **Wallet** — key custody (passkey + wallet signature), local encrypted
  credential store, Merkle tree maintenance, triggers proof generation.
- **Proof Generator** — circuit selection, witness construction, single-proof
  output (Circom/Halo2/Noir).
- **Recursive Proof Engine** — folds multiple single proofs into one
  (Nova/recursive SNARK).
- **Verifier.sol** — on-chain SNARK/STARK verification entrypoint.
- **Revocation Registry** — Sparse Merkle Tree / accumulator of revoked
  credential commitments; proofs must include a non-membership witness.
- **Backend (Rust/Axum)** — orchestration only: issuer API, proof-job
  coordination, portal criteria publishing, revocation notifications. Holds
  no plaintext credentials.

## Trust boundaries

- Universities are trusted issuers; their signing keys are registered
  on-chain via the DID/Identity registry so anyone can check accreditation.
- The backend is untrusted-by-design for privacy purposes — it coordinates
  but never sees plaintext CGPA/DOB/etc. All sensitive computation
  (decryption, witness generation) happens client-side in the wallet.
- Verifiers (recruiters, scholarship/visa portals) trust the on-chain
  verifier contract and the issuer accreditation list, not the student or
  each other.

See [tech-stack.md](tech-stack.md) for concrete technology choices,
[security.md](security.md) for the threat model, and the [module
docs](modules/) for per-module detail.
