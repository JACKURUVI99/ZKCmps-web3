// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessManager} from "./AccessManager.sol";

/// @title IdentityRegistry
/// @notice Module 1 (DID Identity): binds a `did:zkcampus:0x...` identifier
///         to key material and, for issuers, an accreditation flag. Holds
///         no personal information — only the DID, its current/historical
///         public keys, and status.
contract IdentityRegistry {
    AccessManager public immutable accessManager;

    enum DidStatus {
        Unregistered,
        Active,
        Deactivated
    }

    struct KeyRecord {
        bytes32 publicKey;
        uint64 validFrom;
        uint64 validUntil; // 0 while the key is still current
    }

    struct DidRecord {
        DidStatus status;
        bool isIssuer;
        bool isAccredited;
        uint32 keyCount;
    }

    /// @dev DID is represented by the controlling address, matching the
    ///      `did:zkcampus:0x<address>` scheme described in the module docs.
    mapping(address => DidRecord) public dids;
    mapping(address => mapping(uint256 => KeyRecord)) public keyHistory;

    event DidRegistered(address indexed did, bytes32 publicKey, bool isIssuer);
    event KeyRotated(address indexed did, bytes32 newPublicKey, uint256 keyIndex);
    event DidDeactivated(address indexed did);
    event IssuerAccredited(address indexed did);
    event IssuerAccreditationRevoked(address indexed did);

    error AlreadyRegistered();
    error NotRegistered();
    error NotActive();
    error NotIssuer();
    error Unauthorized();

    modifier onlyGovernance() {
        if (!accessManager.hasRole(accessManager.GOVERNANCE_ROLE(), msg.sender)) {
            revert Unauthorized();
        }
        _;
    }

    constructor(address accessManagerAddress) {
        accessManager = AccessManager(accessManagerAddress);
    }

    /// @notice Register a new DID controlled by `msg.sender`.
    /// @param publicKey Initial signing key bound to this DID.
    /// @param isIssuer Whether this DID represents a credential issuer
    ///        (e.g. a university). Issuers still require a separate
    ///        governance accreditation step before they may issue.
    function registerDid(bytes32 publicKey, bool isIssuer) external {
        if (dids[msg.sender].status != DidStatus.Unregistered) revert AlreadyRegistered();

        dids[msg.sender] = DidRecord({
            status: DidStatus.Active,
            isIssuer: isIssuer,
            isAccredited: false,
            keyCount: 1
        });
        keyHistory[msg.sender][0] = KeyRecord({
            publicKey: publicKey,
            validFrom: uint64(block.timestamp),
            validUntil: 0
        });

        emit DidRegistered(msg.sender, publicKey, isIssuer);
    }

    /// @notice Rotate the calling DID's active key. The previous key remains
    ///         in history (closed out with `validUntil`) so credentials
    ///         signed against it before rotation remain verifiable.
    function rotateKey(bytes32 newPublicKey) external {
        DidRecord storage record = dids[msg.sender];
        if (record.status != DidStatus.Active) revert NotActive();

        uint256 currentIndex = record.keyCount - 1;
        keyHistory[msg.sender][currentIndex].validUntil = uint64(block.timestamp);

        uint256 newIndex = record.keyCount;
        keyHistory[msg.sender][newIndex] = KeyRecord({
            publicKey: newPublicKey,
            validFrom: uint64(block.timestamp),
            validUntil: 0
        });
        record.keyCount = uint32(newIndex + 1);

        emit KeyRotated(msg.sender, newPublicKey, newIndex);
    }

    /// @notice Deactivate the calling DID. Deactivated DIDs can no longer
    ///         be used to sign new credentials or submit proofs; existing
    ///         credentials remain independently verifiable via key history.
    function deactivate() external {
        DidRecord storage record = dids[msg.sender];
        if (record.status != DidStatus.Active) revert NotActive();
        record.status = DidStatus.Deactivated;
        emit DidDeactivated(msg.sender);
    }

    /// @notice Grant issuer accreditation. Governance-only.
    function accreditIssuer(address did) external onlyGovernance {
        DidRecord storage record = dids[did];
        if (record.status == DidStatus.Unregistered) revert NotRegistered();
        if (!record.isIssuer) revert NotIssuer();
        record.isAccredited = true;
        emit IssuerAccredited(did);
    }

    /// @notice Revoke issuer accreditation. Governance-only. Credentials
    ///         already issued remain checkable against the accreditation
    ///         status *at issuance time* by consumers that track history
    ///         off-chain; this call only affects current status.
    function revokeAccreditation(address did) external onlyGovernance {
        dids[did].isAccredited = false;
        emit IssuerAccreditationRevoked(did);
    }

    /// @notice Whether `did` is currently an active, accredited issuer.
    function isAccreditedIssuer(address did) external view returns (bool) {
        DidRecord storage record = dids[did];
        return record.status == DidStatus.Active && record.isIssuer && record.isAccredited;
    }

    /// @notice Whether `did` is currently active (registered, not deactivated).
    function isActive(address did) external view returns (bool) {
        return dids[did].status == DidStatus.Active;
    }

    /// @notice Current signing key for `did`.
    function currentKey(address did) external view returns (bytes32) {
        DidRecord storage record = dids[did];
        if (record.status == DidStatus.Unregistered) revert NotRegistered();
        return keyHistory[did][record.keyCount - 1].publicKey;
    }
}
