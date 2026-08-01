// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessManager} from "./AccessManager.sol";

/// @title Revocation
/// @notice Module 10 (Revocation): Sparse-Merkle-Tree root of revoked
///         credential commitments. Verifiers check a non-membership witness
///         against `currentRoot` as part of proof acceptance. Full SMT
///         update logic lands in Phase 8 — this stub only tracks the root
///         and emits the revocation event so Phase 4's Verifier.sol has a
///         stable interface to build against.
contract Revocation {
    AccessManager public immutable accessManager;

    bytes32 public currentRoot;

    event CredentialRevoked(bytes32 indexed commitment, bytes32 newRoot);

    error Unauthorized();

    modifier onlyRevoker() {
        if (!accessManager.hasRole(accessManager.REVOKER_ROLE(), msg.sender)) revert Unauthorized();
        _;
    }

    constructor(address accessManagerAddress) {
        accessManager = AccessManager(accessManagerAddress);
    }

    /// @notice Record a revocation. `newRoot` is the updated Sparse Merkle
    ///         Tree root computed off-chain by the revoker; this contract
    ///         does not yet verify the update proof (Phase 8).
    function revoke(bytes32 commitment, bytes32 newRoot) external onlyRevoker {
        currentRoot = newRoot;
        emit CredentialRevoked(commitment, newRoot);
    }
}
