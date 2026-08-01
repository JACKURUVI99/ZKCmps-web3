// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/// @notice Central role registry shared by the other ZKCampus contracts.
/// @dev Each contract holds a reference to a single deployed AccessManager
///      instead of maintaining its own roles, so role grants/revocations are
///      administered in one place.
contract AccessManager is AccessControl {
    /// @notice May accredit/deaccredit issuer DIDs in IdentityRegistry.
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    /// @notice May write credential commitments to CredentialRegistry.
    /// @dev Granted to accredited issuer addresses.
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");

    /// @notice May submit revocations to Revocation.sol.
    /// @dev Granted to accredited issuer addresses; an issuer may only
    ///      revoke commitments it originally issued (enforced in
    ///      Revocation.sol, not here).
    bytes32 public constant REVOKER_ROLE = keccak256("REVOKER_ROLE");

    /// @notice May call verifier administration functions (e.g. registering
    ///      new circuit verification keys) in Verifier.sol.
    bytes32 public constant VERIFIER_ADMIN_ROLE = keccak256("VERIFIER_ADMIN_ROLE");

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(GOVERNANCE_ROLE, admin);
    }
}
