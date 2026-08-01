# ZKCampus Contracts

Hardhat + TypeScript project for the five contracts described in
[../docs/architecture.md](../docs/architecture.md):

| Contract | Status |
|---|---|
| `AccessManager.sol` | Implemented — role registry (`GOVERNANCE_ROLE`, `ISSUER_ROLE`, `REVOKER_ROLE`, `VERIFIER_ADMIN_ROLE`) shared by the other contracts |
| `IdentityRegistry.sol` | Implemented — Module 1 (DID registration, key rotation, issuer accreditation) |
| `CredentialRegistry.sol` | Stub — Module 4, fleshed out in Phase 2 |
| `Revocation.sol` | Stub — Module 10, fleshed out in Phase 8 |
| `Verifier.sol` | Stub — Modules 5-7, fleshed out in Phase 4 once circuits exist |

## Usage

```bash
npm install
npm run compile
npm test
```

## Layout

```
src/       Solidity sources
test/      Hardhat/Mocha/Chai tests (TypeScript)
scripts/   Deployment scripts (added alongside first real deployment)
```
