import { expect } from "chai";
import { ethers } from "hardhat";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { AccessManager, IdentityRegistry } from "../typechain-types";

describe("IdentityRegistry", () => {
  let accessManager: AccessManager;
  let identityRegistry: IdentityRegistry;
  let admin: HardhatEthersSigner;
  let student: HardhatEthersSigner;
  let university: HardhatEthersSigner;

  const KEY_1 = ethers.encodeBytes32String("key-1");
  const KEY_2 = ethers.encodeBytes32String("key-2");

  beforeEach(async () => {
    [admin, student, university] = await ethers.getSigners();

    const AccessManagerFactory = await ethers.getContractFactory("AccessManager");
    accessManager = await AccessManagerFactory.deploy(admin.address);

    const IdentityRegistryFactory = await ethers.getContractFactory("IdentityRegistry");
    identityRegistry = await IdentityRegistryFactory.deploy(await accessManager.getAddress());
  });

  it("registers a student DID as active with no accreditation", async () => {
    await identityRegistry.connect(student).registerDid(KEY_1, false);

    expect(await identityRegistry.isActive(student.address)).to.equal(true);
    expect(await identityRegistry.isAccreditedIssuer(student.address)).to.equal(false);
    expect(await identityRegistry.currentKey(student.address)).to.equal(KEY_1);
  });

  it("rejects double registration of the same DID", async () => {
    await identityRegistry.connect(student).registerDid(KEY_1, false);
    await expect(identityRegistry.connect(student).registerDid(KEY_1, false)).to.be.revertedWithCustomError(
      identityRegistry,
      "AlreadyRegistered",
    );
  });

  it("rotates keys and keeps the DID active", async () => {
    await identityRegistry.connect(student).registerDid(KEY_1, false);
    await identityRegistry.connect(student).rotateKey(KEY_2);

    expect(await identityRegistry.currentKey(student.address)).to.equal(KEY_2);
  });

  it("only lets governance accredit a registered issuer", async () => {
    await identityRegistry.connect(university).registerDid(KEY_1, true);

    await expect(identityRegistry.connect(student).accreditIssuer(university.address)).to.be.revertedWithCustomError(
      identityRegistry,
      "Unauthorized",
    );

    await identityRegistry.connect(admin).accreditIssuer(university.address);
    expect(await identityRegistry.isAccreditedIssuer(university.address)).to.equal(true);
  });

  it("rejects accrediting a DID that is not registered as an issuer", async () => {
    await identityRegistry.connect(student).registerDid(KEY_1, false);
    await expect(identityRegistry.connect(admin).accreditIssuer(student.address)).to.be.revertedWithCustomError(
      identityRegistry,
      "NotIssuer",
    );
  });

  it("deactivates a DID", async () => {
    await identityRegistry.connect(student).registerDid(KEY_1, false);
    await identityRegistry.connect(student).deactivate();

    expect(await identityRegistry.isActive(student.address)).to.equal(false);
    await expect(identityRegistry.connect(student).rotateKey(KEY_2)).to.be.revertedWithCustomError(
      identityRegistry,
      "NotActive",
    );
  });
});
