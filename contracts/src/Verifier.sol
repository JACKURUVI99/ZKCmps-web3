// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessManager} from "./AccessManager.sol";
import {Revocation} from "./Revocation.sol";

/// @title Verifier
/// @notice On-chain entrypoint for ZK proof verification (Modules 5-7).
///         The actual SNARK/STARK verification key and pairing checks are
///         generated per-circuit from the Phase 3 circuits and wired in
///         here in Phase 4 — this stub fixes the external interface
///         (proof, public inputs, revocation check) so downstream modules
///         can be built against it now.
contract Verifier {
    AccessManager public immutable accessManager;
    Revocation public immutable revocation;

    error Unauthorized();
    error NotImplemented();

    modifier onlyVerifierAdmin() {
        if (!accessManager.hasRole(accessManager.VERIFIER_ADMIN_ROLE(), msg.sender)) revert Unauthorized();
        _;
    }

    constructor(address accessManagerAddress, address revocationAddress) {
        accessManager = AccessManager(accessManagerAddress);
        revocation = Revocation(revocationAddress);
    }

    /// @notice Verify a (possibly recursively aggregated) proof against its
    ///         public inputs. Reverts until the Phase 4 circuit-specific
    ///         verifying key is wired in.
    function verifyProof(bytes calldata proof, uint256[] calldata publicInputs) external pure returns (bool) {
        proof;
        publicInputs;
        revert NotImplemented();
    }
}
