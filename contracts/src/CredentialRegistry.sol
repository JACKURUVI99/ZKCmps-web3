// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessManager} from "./AccessManager.sol";
import {IdentityRegistry} from "./IdentityRegistry.sol";

/// @title CredentialRegistry
/// @notice Module 4 (Credential Storage): stores each student's Merkle root
///         over their credential commitments (SHA256/Poseidon hashes), not
///         the documents themselves. Implementation lands in Phase 2.
contract CredentialRegistry {
    AccessManager public immutable accessManager;
    IdentityRegistry public immutable identityRegistry;

    mapping(address => bytes32) public credentialMerkleRoot;

    event MerkleRootUpdated(address indexed student, bytes32 newRoot);

    error Unauthorized();

    modifier onlyAccreditedIssuer() {
        if (!identityRegistry.isAccreditedIssuer(msg.sender)) revert Unauthorized();
        _;
    }

    constructor(address accessManagerAddress, address identityRegistryAddress) {
        accessManager = AccessManager(accessManagerAddress);
        identityRegistry = IdentityRegistry(identityRegistryAddress);
    }

    /// @notice Update a student's credential Merkle root after a new
    ///         credential is issued. Only an accredited issuer may call
    ///         this, and only for a root it co-signs off-chain with the
    ///         student (signature check to be added alongside Module 2).
    function updateMerkleRoot(address student, bytes32 newRoot) external onlyAccreditedIssuer {
        credentialMerkleRoot[student] = newRoot;
        emit MerkleRootUpdated(student, newRoot);
    }
}
